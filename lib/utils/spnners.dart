import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import '../../model/all_machine.dart';
import '../../model/machines_by_client_id.dart';

import '../../model/all_clients.dart';

class SerialNoSpinner extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final Future<List<Machine>> machines;
  final List<String> excludeSerialNos; // List of serial numbers to exclude from dropdown

  const SerialNoSpinner({
    required this.onChanged,
    required this.machines,
    this.excludeSerialNos = const [],
    Key? key,
  }) : super(key: key);

  @override
  _SerialNoSpinnerState createState() => _SerialNoSpinnerState();
}

class _SerialNoSpinnerState extends State<SerialNoSpinner> {
  final TextEditingController _searchController = TextEditingController();
  List<Machine> _allMachines = [];
  List<String> _filteredSerialNos = [];
  String? _selectedSerialNo;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late Future<List<Machine>> _machinesFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _machinesFuture = widget.machines;
    _searchController.addListener(_onSearchChanged);
    _loadMachines();
  }

  void _loadMachines() async {
    try {
      final machines = await _machinesFuture;
      setState(() {
        _allMachines = machines;
        _isLoading = false;
        _updateFilteredSerialNos();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading machines: $e');
    }
  }

  @override
  void didUpdateWidget(SerialNoSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the list if the excluded items change
    if (!listEquals(oldWidget.excludeSerialNos, widget.excludeSerialNos)) {
      _updateFilteredSerialNos();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterSerialNos(_searchController.text);
  }

  void _filterSerialNos(String query) {
    setState(() {
      if (query.isEmpty) {
        _updateFilteredSerialNos();
      } else {
        _filteredSerialNos = _getAvailableMachines()
            .where((serialNo) => serialNo.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    _updateOverlay();
  }

  void _updateFilteredSerialNos() {
    setState(() {
      _filteredSerialNos = _getAvailableMachines();
    });
  }

  // Get available machines (excluding the ones that are already selected)
  List<String> _getAvailableMachines() {
    return _formatMachines(_allMachines
        .where((machine) => !widget.excludeSerialNos.contains(machine.serialNo))
        .toList());
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 5.0,
        left: offset.dx,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              constraints: BoxConstraints(maxHeight: 250),
              child: _filteredSerialNos.isEmpty
                  ? ListTile(
                title: Text(
                  'No machines available',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredSerialNos.length,
                itemBuilder: (context, index) {
                  final serialNo = _filteredSerialNos[index];
                  return ListTile(
                    title: Text(
                      serialNo,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedSerialNo = serialNo;
                        _isSearching = false;
                        _searchController.clear();
                      });
                      widget.onChanged(serialNo);
                      _removeOverlay();
                    },
                    tileColor: index % 2 == 0 ? Colors.grey.shade50 : Colors.white,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _formatMachines(List<Machine> machines) {
    return machines
        .where((machine) => machine.serialNo != null && machine.modelName != null)
        .map((machine) => '${machine.serialNo} - ${machine.modelName}')
        .toList();
  }

  // Get original Machine object from formatted string
  Machine? _getMachineFromFormattedString(String formattedString) {
    try {
      final serialNo = formattedString.split(' - ')[0];
      return _allMachines.firstWhere((machine) => machine.serialNo == serialNo);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isLoading)
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colorMixGrad),
                ),
              ),
            )
          else if (_isSearching)
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search serial number...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder:  OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.grey),
    ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: colorMixGrad),
                ),

                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: colorMixGrad),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _updateFilteredSerialNos();
                    });
                    _removeOverlay();
                  },
                ),
                prefixIcon: const Icon(Icons.search, color: colorMixGrad),
              ),
              onTap: _showOverlay,
              autofocus: true,
            )
          else
            InkWell(
              onTap: () {
                if (_getAvailableMachines().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All machines have been assigned'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                setState(() {
                  _isSearching = true;
                  _updateFilteredSerialNos();
                });
                _showOverlay();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedSerialNo ?? 'Select a serial number',
                        style: TextStyle(
                          color: _selectedSerialNo == null ? Colors.grey : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: colorMixGrad,
                    ),
                  ],
                ),
              ),
            ),
          if (_getAvailableMachines().isEmpty && !_isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'All machines have been assigned',
                style: TextStyle(
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MachineByClientIdSpinner extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final Future<List<MachineByClientId>> machinesFuture;

  const MachineByClientIdSpinner({
    required this.onChanged,
    required this.machinesFuture,
    Key? key,
  }) : super(key: key);

  @override
  _MachineByClientIdSpinnerState createState() => _MachineByClientIdSpinnerState();
}

class _MachineByClientIdSpinnerState extends State<MachineByClientIdSpinner> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredSerialNos = [];
  String? _selectedSerialNo;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterSerialNos(_searchController.text);
  }

  void _filterSerialNos(String query) async {
    try {
      final machines = await widget.machinesFuture;
      setState(() {
        if (query.isEmpty) {
          _filteredSerialNos = _formatMachines(machines);
        } else {
          _filteredSerialNos = _formatMachines(machines)
              .where((serialNo) => serialNo.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
      _updateOverlay();
    } catch (e) {
      print('Error filtering machines: $e');
    }
  }

  void _updateFilteredSerialNos() async {
    try {
      final machines = await widget.machinesFuture;
      setState(() {
        _filteredSerialNos = _formatMachines(machines);
      });
    } catch (e) {
      print('Error updating filtered serial numbers: $e');
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 5.0,
        left: offset.dx,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _filteredSerialNos.map((serialNo) {
                return ListTile(
                  title: Text(
                    serialNo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedSerialNo = serialNo;
                      _isSearching = false;
                      _searchController.clear();
                    });
                    widget.onChanged(serialNo);
                    _removeOverlay();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _formatMachines(List<MachineByClientId> machines) {
    return machines
        .where((machine) => machine.serialNo != null && machine.modelName != null)
        .map((machine) => '${machine.serialNo} - ${machine.modelName}')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        children: [
          _isSearching
              ? TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search serial number...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: colorMixGrad),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: colorMixGrad),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _updateFilteredSerialNos();
                  });
                  _removeOverlay();
                },
              ),
            ),
            onTap: () {
              _updateFilteredSerialNos();
              _showOverlay();
            },
          )
              : FutureBuilder<List<MachineByClientId>>(
            future: widget.machinesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No machines available');
              } else {
                return DropdownButtonFormField<String>(
                  value: _selectedSerialNo,
                  hint: const Text('Select a serial number'),
                  items: _formatMachines(snapshot.data!).map((serialNo) {
                    return DropdownMenuItem<String>(
                      value: serialNo,
                      child: Text(serialNo),
                    );
                  }).toList(),
                  onChanged: (String? newSerialNo) {
                    setState(() {
                      _selectedSerialNo = newSerialNo;
                      widget.onChanged(newSerialNo);
                    });
                  },
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: colorMixGrad),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: colorMixGrad),
                      onPressed: () {
                        setState(() {
                          _isSearching = true;
                          _updateFilteredSerialNos();
                        });
                        _showOverlay();
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}


class ClientNameSpinner extends StatefulWidget {
  final Future<List<Client>> Function(String? search) fetchClients;
  final ValueChanged<Client?> onChanged;

  const ClientNameSpinner({
    required this.fetchClients,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _ClientNameSpinnerState createState() => _ClientNameSpinnerState();
}

class _ClientNameSpinnerState extends State<ClientNameSpinner> {
  final TextEditingController _searchController = TextEditingController();
  List<Client> _clients = [];
  List<Client> _filteredClients = [];
  Client? _selectedClient;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _fetchClients();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  Future<void> _fetchClients() async {
    try {
      List<Client> clients = await widget.fetchClients(null);
      setState(() {
        _clients = clients;
        _filteredClients = clients;
      });
    } catch (e) {
      print('Error fetching clients: $e');
    }
  }

  void _onSearchChanged() {
    _filterClients(_searchController.text);
  }

  void _filterClients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredClients = _clients;
      } else {
        _filteredClients = _clients
            .where((client) =>
        client.name!.toLowerCase().contains(query.toLowerCase()) ||
            client.city!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    _updateOverlay();
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 5.0,
        left: offset.dx,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _filteredClients.map((client) {
                return ListTile(
                  title: Text(
                    '${client.name} - ${client.city}', // Display name and city
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedClient = client;
                      _isSearching = false;
                      _searchController.clear();
                    });
                    widget.onChanged(client);
                    _removeOverlay();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        children: [
          _isSearching
              ? TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search client...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: colorMixGrad),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: colorMixGrad),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _filteredClients = _clients;
                  });
                  _removeOverlay();
                },
              ),
            ),
            onTap: _showOverlay,
          )
              : DropdownButtonFormField<Client>(
            value: _selectedClient,
            hint: Text('Select a client'),
            items: _clients.map((Client client) {
              return DropdownMenuItem<Client>(
                value: client,
                child: Text('${client.name} - ${client.city}'), // Display name and city
              );
            }).toList(),
            onChanged: (Client? newClient) {
              setState(() {
                _selectedClient = newClient;
                widget.onChanged(newClient);
              });
            },
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: colorMixGrad),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: colorMixGrad),
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                    _filteredClients = _clients;
                  });
                  _showOverlay();
                },
              ),
            ),
            selectedItemBuilder: (BuildContext context) {
              return _clients.map((Client client) {
                return DropdownMenuItem<Client>(
                  value: client,
                  child: Text('${client.name} - ${client.city}'), // Display name and city
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}



class MasterSpinner extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> dataFuture;
  final String displayKey;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final String? searchHint;
  final Color? borderColor;
  final List<String>? excludeItems;

  const MasterSpinner({
    required this.dataFuture,
    required this.displayKey,
    required this.onChanged,
    this.searchHint = 'Search...',
    this.borderColor,
    this.excludeItems = const [],
    Key? key,
  }) : super(key: key);

  @override
  _MasterSpinnerState createState() => _MasterSpinnerState();
}

class _MasterSpinnerState extends State<MasterSpinner> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allItems = [];
  List<Map<String, dynamic>> _filteredItems = [];
  Map<String, dynamic>? _selectedItem;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final response = await widget.dataFuture;
      setState(() {
        _allItems = response;
        _filteredItems = _getAvailableItems();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  void _onSearchChanged() {
    _filterItems(_searchController.text);
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _getAvailableItems();
      } else {
        _filteredItems = _getAvailableItems()
            .where((item) => item[widget.displayKey]
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
    _updateOverlay();
  }

  List<Map<String, dynamic>> _getAvailableItems() {
    return _allItems
        .where((item) => !widget.excludeItems!
        .contains(item[widget.displayKey].toString()))
        .toList();
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 5.0,
        left: offset.dx,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              constraints: BoxConstraints(maxHeight: 250),
              child: _filteredItems.isEmpty
                  ? ListTile(
                title: Text(
                  'No items available',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    title: Text(
                      item[widget.displayKey].toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedItem = item;
                        _isSearching = false;
                        _searchController.clear();
                      });
                      widget.onChanged(item);
                      _removeOverlay();
                    },
                    tileColor: index % 2 == 0
                        ? Colors.grey.shade50
                        : Colors.white,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isLoading)
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.borderColor ?? Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_isSearching)
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.blue),
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close,
                      color: widget.borderColor ?? Colors.blue),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _filteredItems = _getAvailableItems();
                    });
                    _removeOverlay();
                  },
                ),
                prefixIcon:
                Icon(Icons.search, color: widget.borderColor ?? Colors.blue),
              ),
              onTap: _showOverlay,
              autofocus: true,
            )
          else
            InkWell(
              onTap: () {
                if (_getAvailableItems().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No items available'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                setState(() {
                  _isSearching = true;
                  _filteredItems = _getAvailableItems();
                });
                _showOverlay();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.borderColor ?? Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedItem != null
                            ? _selectedItem![widget.displayKey].toString()
                            : 'Select an item',
                        style: TextStyle(
                          color: _selectedItem == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.search,
                        color: widget.borderColor ?? Colors.blue),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}