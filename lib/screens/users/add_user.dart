import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/network/ApiService.dart';
import 'package:tonner_app/screens/client/client.dart';
import 'package:tonner_app/screens/home/home.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<StatefulWidget> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String? selectedUserRole;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController authorityController = TextEditingController();
  TextEditingController activeStatusController = TextEditingController();

  bool machineModuleChecked = false;
  bool clientModuleChecked = false;
  bool userPrivilegeChecked = false;
  bool activeChecked = true; // Assuming Active is initially checked


  Future<void> submitUser() async {
    // Validate phone nu

    if (selectedUserRole == null) {
      showSnackBar(context, "Please select User Role.");
      return;
    }

    if (nameController.text.isEmpty) {
      showSnackBar(context, "Full Name is required.");
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

    if (passwordController.text.isEmpty) {
      showSnackBar(context, "Password is required.");
      return;
    }

  if (confirmPasswordController.text.isEmpty) {
      showSnackBar(context, "Confirm Password is required.");
      return;
    }

  if (confirmPasswordController.text != passwordController.text) {
      showSnackBar(context, "Password not matched! Please check.");
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
      late final Map<String, dynamic> addUserResponse;

      // Determine whether to use phone or email for login

      addUserResponse = await apiService.addUser(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        isActive: activeChecked ? '0' : '1',
        userRole: selectedUserRole ?? 'user', // Default to 'user' if not selected
        password: passwordController.text,
        machineModule: machineModuleChecked ? '0' : '1',
        clientModule: clientModuleChecked ? '0' : '1',
        userModule: userPrivilegeChecked ? '0' : '1');

      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Check if the login was successful based on the response structure
      if (addUserResponse.containsKey('error') &&
          addUserResponse.containsKey('status')) {
        if (!addUserResponse['error'] && addUserResponse['status'] == 200) {
          if (addUserResponse['message'] == 'Success') {
            nameController.text = "";
            emailController.text = "";
            phoneController.text = "";
            passwordController.text = "";
            confirmPasswordController.text = "";
            showSnackBar(context, "Client created successfully.");
          } else {
            showSnackBar(context, addUserResponse['message']);
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

  void _handleSubmit() {
    submitUser();
  }

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
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Add New ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorMixGrad,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "User Roles ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              UserRolesSpinner(
                selectedValue: selectedUserRole,
                onChanged: (newValue) {
                  setState(() {
                    selectedUserRole = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              NameInputTextField(controller: nameController),
              const SizedBox(height: 20),
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              EmailInputTextField(controller: emailController),
              const SizedBox(height: 20),
              Text(
                "Phone",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              PhoneInputTextField(controller: phoneController),
              const SizedBox(height: 20),
              Text(
                "Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              PasswordInputTextField(controller: passwordController),
              const SizedBox(height: 20),
              Text(
                "Confirm Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              ConfirmPasswordInputTextField(
                  controller: confirmPasswordController),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Authority",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    CheckBoxRow(
                      machineModuleChecked: machineModuleChecked,
                      clientModuleChecked: clientModuleChecked,
                      userPrivilegeChecked: userPrivilegeChecked,
                      activeChecked: activeChecked,
                      onMachineModuleChanged: (bool? value) {
                        setState(() {
                          machineModuleChecked = value ?? false;
                        });
                      },
                      onClientModuleChanged: (bool? value) {
                        setState(() {
                          clientModuleChecked = value ?? false;
                        });
                      },
                      onUserPrivilegeChanged: (bool? value) {
                        setState(() {
                          userPrivilegeChecked = value ?? false;
                        });
                      },
                      onActiveChanged: (bool? value) {
                        setState(() {
                          activeChecked = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 50),
                  child: GradientButton(
                    gradientColors: const [colorFirstGrad, colorSecondGrad],
                    height: 45.0,
                    width: 10.0,
                    radius: 25.0,
                    buttonText: "Submit",
                    onPressed: _handleSubmit,
                  ),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class UserRolesSpinner extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const UserRolesSpinner({
    required this.selectedValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: const Text('Select Role'),
      items: ['Admin', 'Client', 'Logistic', 'User'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: colorMixGrad),
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

class NameInputTextField extends StatelessWidget {

  final TextEditingController controller;

  NameInputTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 30,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
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

class EmailInputTextField extends StatelessWidget {
  final TextEditingController controller;

  const EmailInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 50,
      keyboardType: TextInputType.text,
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

class PhoneInputTextField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 15,
      controller: controller,
      keyboardType: TextInputType.number,
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

class PasswordInputTextField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _PasswordInputTextFieldState createState() => _PasswordInputTextFieldState();
}

class _PasswordInputTextFieldState extends State<PasswordInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLength: 30,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Password',
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

class ConfirmPasswordInputTextField extends StatefulWidget {
  final TextEditingController controller;

  const ConfirmPasswordInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _ConfirmPasswordTextFieldState createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState
    extends State<ConfirmPasswordInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLength: 30,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
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
  final bool machineModuleChecked;
  final bool clientModuleChecked;
  final bool userPrivilegeChecked;
  final bool activeChecked;
  final ValueChanged<bool?> onMachineModuleChanged;
  final ValueChanged<bool?> onClientModuleChanged;
  final ValueChanged<bool?> onUserPrivilegeChanged;
  final ValueChanged<bool?> onActiveChanged;

  const CheckBoxRow({
    required this.machineModuleChecked,
    required this.clientModuleChecked,
    required this.userPrivilegeChecked,
    required this.activeChecked,
    required this.onMachineModuleChanged,
    required this.onClientModuleChanged,
    required this.onUserPrivilegeChanged,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomCheckbox(
              value: machineModuleChecked,
              onChanged: onMachineModuleChanged,
              activeColor: colorMixGrad,
            ),
            const Text('Machine Module'),
            const SizedBox(width: 20),
            CustomCheckbox(
              value: clientModuleChecked,
              onChanged: onClientModuleChanged,
              activeColor: colorMixGrad,
            ),
            const Text('Client Module'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CustomCheckbox(
              value: userPrivilegeChecked,
              onChanged: onUserPrivilegeChanged,
              activeColor: colorMixGrad,
            ),
            const Text('User Privilege'),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Text('Active Status:'),
            SizedBox(width: 20),
            Row(
              children: [
                CustomRadio(
                  value: true,
                  groupValue: activeChecked,
                  onChanged: onActiveChanged,
                  activeColor: colorMixGrad,
                ),
                Text('Active'),
                SizedBox(width: 20),
                CustomRadio(
                  value: false,
                  groupValue: activeChecked,
                  onChanged: onActiveChanged,
                  activeColor: colorMixGrad,
                ),
                Text('Inactive'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color activeColor;

  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    );
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
