import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/model/supply_fields_data.dart';

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
  final ValueChanged<SupplyClient?> onChanged;
  final List<SupplyClient> clients;

  const ClientNameSpinner({
    required this.onChanged,
    required this.clients,
    Key? key,
  }) : super(key: key);

  @override
  _ClientNameSpinnerState createState() => _ClientNameSpinnerState();
}

class _ClientNameSpinnerState extends State<ClientNameSpinner> {
  final TextEditingController _searchController = TextEditingController();
  List<SupplyClient> _filteredClients = [];
  SupplyClient? _selectedClient;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _filteredClients = widget.clients;
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
    _filterClients(_searchController.text);
  }

  void _filterClients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredClients = widget.clients;
      } else {
        _filteredClients = widget.clients
            .where((client) =>
            client.name.toLowerCase().contains(query.toLowerCase()))
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
        top: offset.dy + size.height + 5.0, // Position below the spinner
        left: offset.dx,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0), // Ensure the overlay appears below the spinner
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _filteredClients.map((client) {
                return ListTile(
                  title: Text(
                    '${client.name} - ${client.city}', // Combine name and city with a dash
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold, // Make text bold
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
                    _filteredClients = widget.clients;
                  });
                  _removeOverlay();
                },
              ),
            ),
            onTap: _showOverlay,
          )
              : DropdownButtonFormField<SupplyClient>(
            value: _selectedClient,
            hint: Text('Select a client'),
            items: widget.clients.map((SupplyClient client) {
              return DropdownMenuItem<SupplyClient>(
                value: client,
                child: Text('${client.name} - ${client.city}'), // Show name and city in the dropdown
              );
            }).toList(),
            onChanged: (SupplyClient? newClient) {
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
                    _filteredClients = widget.clients;
                  });
                  _showOverlay();
                },
              ),
            ),
            // Display only the name of the selected client

            selectedItemBuilder: (BuildContext context) {
              return widget.clients.map((SupplyClient client) {
                return DropdownMenuItem<SupplyClient>(
                  value: client,
                  child: Text(client.name), // Display only name in the selected item
                );
              }).toList();
            },
          )
          ,
        ],
      ),
    );
  }
}


class SerialNoSpinner extends StatefulWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final List<String> modelList;

  const SerialNoSpinner({
    required this.selectedValue,
    required this.onChanged,
    required this.modelList,
    Key? key,
  }) : super(key: key);

  @override
  _SerialNoSpinnerState createState() => _SerialNoSpinnerState();
}

class _SerialNoSpinnerState extends State<SerialNoSpinner> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredModelList = [];
  String? _selectedModel;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _filteredModelList = widget.modelList;
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
    _filterModels(_searchController.text);
  }

  void _filterModels(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredModelList = widget.modelList;
      } else {
        _filteredModelList = widget.modelList
            .where((model) => model.toLowerCase().contains(query.toLowerCase()))
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
              children: _filteredModelList.map((model) {
                return ListTile(
                  title: Text(
                    model,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedModel = model;
                      _isSearching = false;
                      _searchController.clear();
                    });
                    widget.onChanged(model);
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
                    _filteredModelList = widget.modelList;
                  });
                  _removeOverlay();
                },
              ),
            ),
            onTap: _showOverlay,
          )
              : DropdownButtonFormField<String>(
            value: _selectedModel,
            hint: const Text('Select a serial number'),
            items: widget.modelList.map((String model) {
              return DropdownMenuItem<String>(
                value: model,
                child: Text(model),
              );
            }).toList(),
            onChanged: (String? newModel) {
              setState(() {
                _selectedModel = newModel;
                widget.onChanged(newModel);
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
                    _filteredModelList = widget.modelList;
                  });
                  _showOverlay();
                },
              ),
            ),
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


