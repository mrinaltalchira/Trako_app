import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/model/all_clients.dart';
import 'package:Trako/network/ApiService.dart';
import '../../../model/all_machine.dart';
import '../../../utils/global_textfields.dart';
import '../../../utils/popup_radio_checkbox.dart';
import '../../../utils/spnners.dart';
import '../../add_toner/utils.dart';
import '../../authFlow/utils.dart';

class AddClient extends StatefulWidget {
  final Map<String, dynamic>? client;

  const AddClient({super.key, this.client});

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  bool activeChecked = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> addressControllers = [TextEditingController()];
  final TextEditingController contactPersonController = TextEditingController();
  // Use a Set instead of List to ensure unique values
  late Set<String> assignedMachines = {}; // Set to store unique assigned machine IDs
  String? fullPhoneNumber;
  Map<String, dynamic>? selectedMachine;

  late Future<List<Map<String, dynamic>>> machineFuture;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    machineFuture = getMachineList("unassigned");
    if (widget.client != null) {
      nameController.text = widget.client!['name'].toString();
      cityController.text = widget.client!['city'].toString();
      emailController.text = widget.client!['email'].toString();
      fullPhoneNumber = widget.client!['phone'];
      // Convert comma-separated string to Set for unique values
      if (widget.client != null && widget.client!['machines'] != null) {
        final machines = widget.client!['machines'] as String?;
        if (machines != null && machines.isNotEmpty) {
          assignedMachines = machines
              .split(",")
              .map((machine) => machine.trim())
              .where((machine) => machine.isNotEmpty)
              .toSet();
        }
      }
      String? phone = widget.client?['phone']; // Access phone property safely
      List<String> phNumber = phone?.split(" ") ?? [];
      phoneController.text = phNumber.length > 1 ? phNumber[1] : '';

      try {
        // Try to parse the address as JSON
        List<dynamic> addresses = json.decode(widget.client!['address'].toString());
        addressControllers.clear();
        for (var address in addresses) {
          addressControllers.add(TextEditingController(text: address.toString()));
        }
      } catch (e) {
        // If parsing fails, use the address as a single string
        addressControllers.first.text = widget.client!['address'].toString();
      }

      contactPersonController.text = widget.client!['contactPerson'] ?? '';
      activeChecked = widget.client!['isActive'] == "1";
    }
  }

  Future<List<Map<String, dynamic>>> getMachineList(String? filter) async {
    try {
      List<Map<String, dynamic>> machines = await ApiService().getAllMachines(search: null, filter: filter.toString());
      print('Fetched machines: $machines');
      return machines;
    } catch (e) {
      print('Error fetching machines: $e');
      return [];
    }
  }

  void _handlePhoneNumberChanged(String phoneNumber) {
    setState(() {
      fullPhoneNumber = phoneNumber;
    });
  }

  void _addAddressField() {
    // Check if the last address field is not empty
    if (addressControllers.last.text.isNotEmpty) {
      setState(() {
        addressControllers.add(TextEditingController());
      });
    } else {
      showSnackBar(context, "Please fill the current address field before adding a new one.");
    }
  }

  void _removeAddressField(int index) {
    if (addressControllers.length > 1) {
      setState(() {
        addressControllers.removeAt(index);
      });
    }
  }

  void _addMachine(Map<String, dynamic> machine) {
    if (machine != null && machine.containsKey('serial_no')) {
      String serialNo = machine['serial_no'];

      // Check if the serial number is not empty and not already in the set
      if (serialNo.isNotEmpty && !assignedMachines.contains(serialNo)) {
        setState(() {
          assignedMachines.add(serialNo);
        });
        print('Added machine: $serialNo');
      } else if (assignedMachines.contains(serialNo)) {
        showSnackBar(context, "This machine is already assigned.");
      }
    }
  }

  void _removeMachine(String serialNo) {
    setState(() {
      assignedMachines.remove(serialNo);
      if(widget.client != null){
        // here i want to add tech me how to do it with existing code or may be if we need modificatoin then plesse let me knoe


      }
    });
    print('Removed machine: $serialNo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/ic_trako.png",
          width: 120,
          height: 40,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),


            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
          SizedBox(width: 7),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.client != null ? "Edit Client :" : "Add New :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: colorMixGrad,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buildFieldTitle("Name"),
                SizedBox(height: 5),
                CustomTextField(
                  controller: nameController,
                  hintText: 'Name',
                  fieldType: TextFieldType.name,
                ),

                SizedBox(height: 20),
                buildFieldTitle("Email"),
                SizedBox(height: 5),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  fieldType: TextFieldType.email,
                ),
                const SizedBox(height: 20),
                buildFieldTitle("Phone"),
                SizedBox(height: 5),
                CustomTextField(
                  controller: phoneController,
                  hintText: 'Phone number',
                  fieldType: TextFieldType.intlPhone,
                  // Optional custom validator for phone numbers
                  phoneValidator: (phoneNumber) {
                    if (phoneNumber == null || phoneNumber.number.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (phoneNumber.number.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onChanged: _handlePhoneNumberChanged,
                ),
                SizedBox(height: 20),
                buildFieldTitle("Assign Machines"),
                SizedBox(height: 5),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: machineFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 40, // Adjust height to match the spinner
                        width: double.infinity, // Match the spinner width
                        child: Center(
                          child: SizedBox(
                            height: 24, // Smaller loader size
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No machines available');
                    } else {
                      return MasterSpinner(
                        dataFuture: machineFuture,
                        displayKey: 'serial_no',
                        onChanged: (selectedItem) {
                          setState(() {
                            selectedMachine = selectedItem;
                            if (selectedItem != null) {
                              _addMachine(selectedItem);
                            }
                          });
                        },
                        searchHint: 'Search serial number...',
                        borderColor: colorMixGrad,
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                buildFieldTitle("Assigned Machines"),
                SizedBox(height: 5),
                assignedMachines.isEmpty
                    ? Text("No machines assigned yet", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                    : Column(
                  children: assignedMachines.map((machine) => ListTile(
                    title: Text(machine),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        _removeMachine(machine);
                      },
                    ),
                  )).toList(),
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildFieldTitle("Full Address (Warehouse)"),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: colorMixGrad),
                      onPressed: _addAddressField,
                      tooltip: "Add another address",
                    ),
                  ],
                ),
                SizedBox(height: 5),
                ...List.generate(addressControllers.length, (index) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: addressControllers[index],
                              hintText: 'Address ${index + 1}',
                              fieldType: TextFieldType.address,
                              maxLines: 3,
                            ),
                          ),
                          if (addressControllers.length > 1)
                            IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () => _removeAddressField(index),
                            ),
                        ],
                      ),
                    ),
                ),
                SizedBox(height: 20),
                buildFieldTitle("Contact Name"),
                SizedBox(height: 5),
                CustomTextField(
                  controller: contactPersonController,
                  hintText: 'Contact Name',
                  fieldType: TextFieldType.name,
                  isOptional: true,
                ),
                SizedBox(height: 20),
                CheckBoxRow(
                  activeChecked: activeChecked,
                  onActiveChanged: (bool? value) {
                    setState(() {
                      activeChecked = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 50),
                  child: GradientButton(
                    gradientColors: [colorFirstGrad, colorSecondGrad],
                    height: 45.0,
                    width: double.infinity,
                    radius: 25.0,
                    buttonText: "Submit",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        validate();
                      }
                    },
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFieldTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  bool isValidPhoneNumber(String phone) {
    final phoneRegExp = RegExp(r'^[0-9]{7,15}$');
    return phoneRegExp.hasMatch(phone);
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  void validate() {
    if (assignedMachines.isEmpty) {
      showSnackBar(context, "Add some machines to Client.");
      return;
    }

    // Check if all address fields are filled
    bool allAddressesFilled = addressControllers.every((controller) => controller.text.isNotEmpty);
    if (!allAddressesFilled) {
      showSnackBar(context, "Please fill all address fields or remove empty ones.");
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmSubmitDialog(
          onConfirm: validateAndCreateClient,
        );
      },
    );
  }

  Future<void> validateAndCreateClient() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      final ApiService apiService = ApiService();

      // Prepare the address as a JSON string
      List<String> addresses = addressControllers.map((controller) => controller.text).toList();
      String addressJson = json.encode(addresses);

      // Convert Set to List and join with commas
      String machinesList = assignedMachines.join(',');

      if (widget.client != null) {
        // Update existing client
        final updateClientResponse = await apiService.updateClient(
            id: widget.client!['id'].toString(),
            name: nameController.text,
            email: emailController.text,
            phone: fullPhoneNumber.toString(),
            address: addressJson,
            isActive: activeChecked ? '1' : '0',
            contactPerson: contactPersonController.text,
            machines: machinesList
        );

        Navigator.of(context).pop();

        if (updateClientResponse.containsKey('error') && updateClientResponse.containsKey('status')) {
          if (!updateClientResponse['error'] && updateClientResponse['status'] == 200) {
            if (updateClientResponse['message'] == 'Success') {
              Navigator.pop(context, true);
            } else {
              showSnackBar(context, updateClientResponse['message']);
            }
          } else {
            showSnackBar(context, "Failed to update client: ${updateClientResponse['message']}");
          }
        } else {
          showSnackBar(context, "Unexpected response from server. Please try again later.");
        }
      } else {
        // Create new client
        final addClientResponse = await apiService.addClient(
            name: nameController.text,
            city: cityController.text,
            email: emailController.text,
            phone: fullPhoneNumber.toString(),
            address: addressJson,
            isActive: activeChecked ? '1' : '0',
            contactPerson: contactPersonController.text,
            machines: machinesList
        );

        Navigator.of(context).pop();

        if (addClientResponse.containsKey('error') && addClientResponse.containsKey('status')) {
          if (!addClientResponse['error'] && addClientResponse['status'] == 200) {
            if (addClientResponse['message'] == 'Success') {
              nameController.clear();
              cityController.clear();
              emailController.clear();
              phoneController.clear();
              addressControllers.forEach((controller) => controller.clear());
              contactPersonController.clear();
              Navigator.pop(context, true);
            } else {
              showSnackBar(context, addClientResponse['message']);
            }
          } else {
            showSnackBar(context, "Failed to create client: ${addClientResponse['message']}");
          }
        } else {
          showSnackBar(context, "Unexpected response from server. Please try again later.");
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      showSnackBar(context, "An error occurred. Please try again later.");
    }
  }

  @override
  void dispose() {
    // Clean up the controllers
    nameController.dispose();
    cityController.dispose();
    emailController.dispose();
    phoneController.dispose();
    for (var controller in addressControllers) {
      controller.dispose();
    }
    contactPersonController.dispose();
    super.dispose();
  }
}