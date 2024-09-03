import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/model/all_clients.dart';
import 'package:Trako/network/ApiService.dart';

import '../../../model/all_machine.dart';
import '../../add_toner/utils.dart';
import '../../authFlow/utils.dart';

class AddClient extends StatefulWidget {
  final Client? client;

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
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  late  List<String> assignedMachines = []; // List to store assigned machine IDs
  String? fullPhoneNumber;
  late Future<List<Machine>> machineFuture;

  @override
  void initState() {
    super.initState();
    machineFuture = getMachineList("only_active");
    if (widget.client != null) {
      nameController.text = widget.client!.name;
      cityController.text = widget.client!.city;
      emailController.text = widget.client!.email;
      fullPhoneNumber = widget.client!.phone;
      assignedMachines = widget.client!.machines.split(",");
      String? phone = widget.client?.phone; // Access phone property safely
      List<String> phNumber = phone?.split(" ") ?? [];
      phoneController.text = phNumber[1];
      addressController.text = widget.client!.address;
      contactPersonController.text = widget.client!.contactPerson ?? '';
      activeChecked = widget.client!.isActive == "0";
      // assignedMachines.addAll(widget.client!.machines); // Assuming `machines` is a list of machine IDs
    }
    // Fetch available machines for dropdown
  }

  Future<List<Machine>> getMachineList(String? filter) async {
    try {
      List<Machine> machines = await ApiService().getAllMachines(search: null,filter :filter.toString());
      // Debug print to check the fetched machines
      print('Fetched machines: $machines');
      return machines;
    } catch (e) {
      // Handle error
      print('Error fetching machines: $e');
      return [];
    }
  }

  void _handlePhoneNumberChanged(String phoneNumber) {
    setState(() {
      fullPhoneNumber = phoneNumber;
    });
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
      body: SingleChildScrollView(
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
              NameInputTextField(controller: nameController),
              SizedBox(height: 20),
              buildFieldTitle("City"),
              SizedBox(height: 5),
              CityInputTextField(controller: cityController),
              SizedBox(height: 20),
              buildFieldTitle("Email"),
              SizedBox(height: 5),
              EmailInputTextField(controller: emailController),
              SizedBox(height: 20),
              buildFieldTitle("Phone"),
              SizedBox(height: 5),
              IntlPhoneInputTextField(
                controller: phoneController,
                onPhoneNumberChanged: _handlePhoneNumberChanged,
              ),
              SizedBox(height: 20),
              SizedBox(height: 5),
              buildFieldTitle("Assign Machines"),
              SizedBox(height: 5),
              SerialNoSpinner(
                onChanged: (String? newSerialNo) {
                  setState(() {
                    if (newSerialNo != null && !assignedMachines.contains(newSerialNo)) {
                      List<String> parts = newSerialNo.split(" - ");
                      assignedMachines.add(parts[0]);
                    }
                  });
                },
                machines: machineFuture, // Pass the future of the machines list
              ),
              SizedBox(height: 20),
              buildFieldTitle("Assigned Machines"),
              SizedBox(height: 5),
              ...assignedMachines.map((machine) => ListTile(
                title: Text(machine),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    setState(() {
                      assignedMachines.remove(machine);
                    });
                  },
                ),
              )),
              SizedBox(height: 20),
              buildFieldTitle("Address"),
              SizedBox(height: 5),
              AddressInputTextField(controller: addressController),
              SizedBox(height: 20),
              buildFieldTitle("Contact Name"),
              SizedBox(height: 5),
              ContactPersonInputTextField(controller: contactPersonController),

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
                    validate();
                  },
                ),
              ),
              SizedBox(height: 100),
            ],
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
    final phoneRegExp = RegExp(r'^[0-9]{7,15}$'); // Example: valid phone numbers with 7 to 15 digits
    return phoneRegExp.hasMatch(phone);
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  bool isValidPhone(String phone) {
    final phoneRegExp = RegExp(
      r'^\d{10}$',
    );
    return phoneRegExp.hasMatch(phone);
  }

  void validate(){
    if (nameController.text.isEmpty) {
      showSnackBar(context, "Full name is required.");
      return;
    }

    if (cityController.text.isEmpty) {
      showSnackBar(context, "City is required.");
      return;
    }

    if (emailController.text.isEmpty) {
      showSnackBar(context, "Email is required.");
      return;
    }

    if (!isValidEmail(emailController.text)) {
      showSnackBar(context, "Please enter a valid email address.");
      return;
    }

    if (phoneController.text.isEmpty) {
      showSnackBar(context, "Phone is required.");
      return;
    }

    if (!isValidPhoneNumber(phoneController.text)) {
      showSnackBar(context, "Please enter a valid phone number.");
      return;
    }

    if (addressController.text.isEmpty) {
      showSnackBar(context, "Address is required.");
      return;
    }
    if (assignedMachines.isEmpty) {
      showSnackBar(context, "Add some machines to Client.");
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

      if (widget.client != null) {
        // Update existing client
        final updateClientResponse = await apiService.updateClient(
          id: widget.client!.id,
          name: nameController.text,
          city: cityController.text,
          email: emailController.text,
          phone: fullPhoneNumber.toString(),
          address: addressController.text,
          isActive: activeChecked ? '0' : '1',
          contactPerson: contactPersonController.text,
            machines: assignedMachines.join(', ')
        );

        Navigator.of(context).pop();

        if (updateClientResponse.containsKey('error') && updateClientResponse.containsKey('status')) {
          if (!updateClientResponse['error'] && updateClientResponse['status'] == 200) {
            if (updateClientResponse['message'] == 'Success') {
              Navigator.pop(context,true);
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
          address: addressController.text,
          isActive: activeChecked ? '0' : '1',
          contactPerson: contactPersonController.text,
            machines: assignedMachines.join(', ')
        );

        Navigator.of(context).pop();

        if (addClientResponse.containsKey('error') && addClientResponse.containsKey('status')) {
          if (!addClientResponse['error'] && addClientResponse['status'] == 200) {
            if (addClientResponse['message'] == 'Success') {
              nameController.clear();
              cityController.clear();
              emailController.clear();
              phoneController.clear();
              addressController.clear();
              contactPersonController.clear();
              Navigator.pop(context,true);
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

}

class ConfirmSubmitDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmSubmitDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Confirm Submit',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colorMixGrad,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 0.5,
          ),
          const SizedBox(height: 8.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Are you sure you want to submit?',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  onConfirm(); // Call the callback to submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorMixGrad,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class NameInputTextField extends StatefulWidget {
  final TextEditingController controller;

  const NameInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _NameInputTextFieldState createState() => _NameInputTextFieldState();
}

class _NameInputTextFieldState extends State<NameInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 30,
      keyboardType: TextInputType.text,
      controller: widget.controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')), // Allow only letters
      ],
      decoration: InputDecoration(
        hintText: 'Name',
        counterText: '',
        // Changed hintText to 'Email'
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class CityInputTextField extends StatefulWidget {
  final TextEditingController controller;

  const CityInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _CityInputTextFieldState createState() => _CityInputTextFieldState();
}

class _CityInputTextFieldState extends State<CityInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      maxLength: 25,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')), // Allow only letters
      ],
      decoration: InputDecoration(
        hintText: 'City',
        counterText: '',

        // Changed hintText to 'Email'
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class EmailInputTextField extends StatefulWidget {
  final TextEditingController controller;

  const EmailInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _EmailInputTextFieldState createState() => _EmailInputTextFieldState();
}

class _EmailInputTextFieldState extends State<EmailInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLength: 50,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')), // Allow only email characters
      ],
      decoration: InputDecoration(
        hintText: 'Email',
        counterText: '',
        // Changed hintText to 'Email'
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}



class AddressInputTextField extends StatefulWidget {
  final TextEditingController controller;

  const AddressInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _AddressInputTextFieldState createState() => _AddressInputTextFieldState();
}

class _AddressInputTextFieldState extends State<AddressInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      maxLength: 100,
      // Allows unlimited lines of text input

      decoration: InputDecoration(
        counterText: '',
        hintText: 'Address',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class ContactPersonInputTextField extends StatefulWidget {
  final TextEditingController controller;

  const ContactPersonInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _ContactPersonInputTextFieldState createState() =>
      _ContactPersonInputTextFieldState();
}

class _ContactPersonInputTextFieldState
    extends State<ContactPersonInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLength: 45,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Contact name (optional)',
        counterText: '',
        // Changed hintText to 'Email'
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class CheckBoxRow extends StatelessWidget {
  final bool activeChecked;
  final ValueChanged<bool?> onActiveChanged;

  const CheckBoxRow({
    required this.activeChecked,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Active Status:',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomRadio(
                value: true,
                groupValue: activeChecked,
                onChanged: onActiveChanged,
                activeColor: colorMixGrad,
              ),
              const Text('Active'),
              SizedBox(width: 20),
              CustomRadio(
                value: false,
                groupValue: activeChecked,
                onChanged: onActiveChanged,
                activeColor: colorMixGrad,
              ),
              const Text('Inactive'),
            ],
          ),
        ],
      ),

    ]);
  }
}
class CustomRadio extends StatelessWidget {
  final bool value;
  final bool? groupValue;
  final ValueChanged<bool?>? onChanged;
  final Color activeColor;

  const CustomRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }
}
