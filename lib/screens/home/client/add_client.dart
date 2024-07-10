import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/network/ApiService.dart';
import 'package:tonner_app/screens/home/home.dart';

class AddClient extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/app_name_logo.png",
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        "Add New :",
                        textAlign: TextAlign.center,
                        // Align text center horizontally
                        style: TextStyle(
                          fontSize: 24.0,
                          color: colorMixGrad,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Name",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5), // Removed const from SizedBox
                    NameInputTextField(
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "City",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    CityInputTextField(controller: cityController),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Email",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    EmailInputTextField(controller: emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Phone",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    PhoneInputTextField(controller: phoneController),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Address",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    AddressInputTextField(controller: addressController),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Contact name",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    ContactPersonInputTextField(
                        controller: contactPersonController),
                    const SizedBox(
                      height: 20,
                    ),
                    CheckBoxRow(
                      activeChecked: activeChecked,
                      onActiveChanged: (bool? value) {
                        setState(() {
                          activeChecked = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(left: 50, right: 50, top: 50),
                      child: GradientButton(
                        gradientColors: const [colorFirstGrad, colorSecondGrad],
                        height: 45.0,
                        width: 10.0,
                        radius: 25.0,
                        buttonText: "Submit",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmSubmitDialog(
                                onConfirm: () {
                                  validateAndCreateClient();
                                },
                              );
                            },
                          );
                        },
                      ),
                    )),
                    SizedBox(
                      height: 100,
                    )
                  ]))),
    );
  }


  Future<void> validateAndCreateClient() async {
    // Validate phone nu

    if (nameController.text.isEmpty) {
      showSnackBar(context, "Full name is required.");
      return;
    }

    if (cityController.text.isEmpty) {
      showSnackBar(context, "City is required.");
      return;
    }

    if (emailController.text.isEmpty) {
      showSnackBar(context, "Email is required & must be unique.");
      return;
    }

    if (phoneController.text.isEmpty) {
      showSnackBar(context, "Phone is required & must be unique.");
      return;
    }

    if (addressController.text.isEmpty) {
      showSnackBar(context, "Address is required.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Call the login API
    try {
      final ApiService apiService = ApiService();
      late final Map<String, dynamic> addClientResponse;

      // Determine whether to use phone or email for login

      addClientResponse = await apiService.addClient(
          name: nameController.text,
          city: cityController.text,
          email: emailController.text,
          phone: phoneController.text,
          address: addressController.text,
          isActive: activeChecked ? '0' : '1',
          contactPerson: contactPersonController.text);

      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Check if the login was successful based on the response structure
      if (addClientResponse.containsKey('error') &&
          addClientResponse.containsKey('status')) {
        if (!addClientResponse['error'] && addClientResponse['status'] == 200) {
          if (addClientResponse['message'] == 'Success') {
            nameController.clear();
            cityController.clear();
            emailController.clear();
            phoneController.clear();
            addressController.clear();
            contactPersonController.clear();
            showSnackBar(context, "Client created successfully.");
            Navigator.of(context).pop(true);
          } else {
            showSnackBar(context, addClientResponse['message']);
          }
        } else {
          // Login failed
          showSnackBar(context, "Login failed. Please check your credentials.");
        }
      } else {
        // Unexpected response structure
        showSnackBar(context,
            "Unexpected response from server. Please try again later.");
      }
    } catch (e) {
      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Handle API errors
      showSnackBar(
          context, "Failed to connect to the server. Please try again later.");
      print("Login API Error: $e");
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

class PhoneInputTextField extends StatefulWidget {
  final TextEditingController controller;

  const PhoneInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _PhoneInputTextFieldState createState() => _PhoneInputTextFieldState();
}

class _PhoneInputTextFieldState extends State<PhoneInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      maxLength: 15,
      decoration: InputDecoration(
        hintText: 'Phone',
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