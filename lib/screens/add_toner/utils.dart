import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/model/supply_fields_data.dart';

import '../../model/all_clients.dart';
import '../../model/all_machine.dart';
import '../../model/machines_by_client_id.dart';

class ManualCodeField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onAddPressed;

  const ManualCodeField(
      {super.key, required this.controller, required this.onAddPressed});

  @override
  _ManualCodeFieldState createState() => _ManualCodeFieldState();
}

class _ManualCodeFieldState extends State<ManualCodeField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            keyboardType: TextInputType.text,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: 'Enter code manually',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: colorMixGrad),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 16.0),
        SizedBox(
          width: 80,
          child: GradientButton(
              gradientColors: const [colorFirstGrad, colorSecondGrad],
              height: 45.0,
              width: double.infinity,
              radius: 25.0,
              buttonText: "Add",
              onPressed: () {
                String enteredCode = widget.controller.text.trim();
                if (enteredCode.isNotEmpty) {
                  widget.controller.clear(); // Clear the text field
                  widget.onAddPressed(enteredCode); // Call parent callback
                }
              }),
        ),
      ],
    );
  }
}

class ReferenceInputTextField extends StatefulWidget {
  final TextEditingController controller;

  ReferenceInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _ReferenceInputTextField createState() => _ReferenceInputTextField();
}

class _ReferenceInputTextField extends State<ReferenceInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Reference (optional)',

        // Changed hintText to 'Email'
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              const BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class DispatchReceiveRadioButton extends StatefulWidget {
  final ValueChanged<DispatchReceive?> onChanged;

  const DispatchReceiveRadioButton({Key? key, required this.onChanged})
      : super(key: key);

  @override
  _DispatchReceiveRadioButtonState createState() =>
      _DispatchReceiveRadioButtonState();
}

enum DispatchReceive { dispatch, receive }

class _DispatchReceiveRadioButtonState
    extends State<DispatchReceiveRadioButton> {
  DispatchReceive? _selectedOption = DispatchReceive.dispatch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select an option:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<DispatchReceive>(
                title: const Text('Dispatch'),
                value: DispatchReceive.dispatch,
                groupValue: _selectedOption,
                activeColor: colorMixGrad,
                onChanged: (DispatchReceive? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                  widget.onChanged(value);
                },
              ),
            ),
            Expanded(
              child: RadioListTile<DispatchReceive>(
                title: const Text('Receive'),
                value: DispatchReceive.receive,
                groupValue: _selectedOption,
                activeColor: colorMixGrad,
                onChanged: (DispatchReceive? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                  widget.onChanged(value);
                },
              ),
            ),
          ],
        ),
      ],
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
        client.name.toLowerCase().contains(query.toLowerCase()) ||
            client.city.toLowerCase().contains(query.toLowerCase()))
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


class SerialNoSpinner extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final Future<List<Machine>> machines;

  const SerialNoSpinner({
    required this.onChanged,
    required this.machines,
    Key? key,
  }) : super(key: key);

  @override
  _SerialNoSpinnerState createState() => _SerialNoSpinnerState();
}

class _SerialNoSpinnerState extends State<SerialNoSpinner> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredSerialNos = [];
  String? _selectedSerialNo;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late Future<List<Machine>> _machinesFuture;

  @override
  void initState() {
    super.initState();
    _machinesFuture = widget.machines;
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
      final machines = await _machinesFuture;
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
      // Handle error
      print('Error filtering machines: $e');
    }
  }

  void _updateFilteredSerialNos() async {
    try {
      final machines = await _machinesFuture;
      setState(() {
        _filteredSerialNos = _formatMachines(machines);
      });
    } catch (e) {
      // Handle error
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

  List<String> _formatMachines(List<Machine> machines) {
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
            onTap: _showOverlay,
          )
              : FutureBuilder<List<Machine>>(
            future: _machinesFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
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


class CityNameTextField extends StatelessWidget {
  final TextEditingController controller;

  const CityNameTextField({super.key,required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Selected City',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
          const BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}



class DateTimeInputField extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  const DateTimeInputField({
    required this.initialDateTime,
    required this.onDateTimeChanged,
    Key? key,
  }) : super(key: key);

  @override
  _DateTimeInputFieldState createState() => _DateTimeInputFieldState();
}

class _DateTimeInputFieldState extends State<DateTimeInputField> {
  late DateTime selectedDateTime;
  late TextEditingController _controller;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd | HH:mm');

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
    _controller = TextEditingController(
      text: _dateFormat.format(selectedDateTime),
    );
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _controller.text = _dateFormat.format(selectedDateTime);
          widget.onDateTimeChanged(selectedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      onTap: _pickDateTime,
      decoration: InputDecoration(
        hintText: 'Select Date and Time',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              const BorderSide(color: colorMixGrad), // Change color as needed
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}


