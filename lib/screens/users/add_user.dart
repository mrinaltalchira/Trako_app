import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/screens/client/client.dart';
import 'package:tonner_app/screens/home/home.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<StatefulWidget> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String? selectedClientName;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController privilegeController = TextEditingController();
  TextEditingController statusController = TextEditingController();

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
                        "Add New ",
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
                      "User Roles ",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    UserRolesSpinner(
                      selectedValue: selectedClientName,
                      onChanged: (newValue) {
                        setState(() {
                          selectedClientName = newValue;
                        });
                      },
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
                    const NameInputTextField(),
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
                    const EmailInputTextField(),
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
                    const PhoneInputTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Password",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    PasswordInputTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Confirm Password",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    ConfirmPasswordInputTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Authority",
                            // Dynamic text, removed const
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          CheckBoxRow(),

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
                        onPressed: () {
                          /*Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QRViewTracesci(),
                      ));*/
                          showSnackBar(context, "Submited");
                        },
                      ),
                    )),
                    SizedBox(
                      height: 100,
                    )
                  ]))),
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
      hint: const Text('Select an option'),
      items: ['Super Admin', 'Admin', 'Client', 'User'].map((String value) {
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

class NameInputTextField extends StatefulWidget {
  const NameInputTextField({Key? key}) : super(key: key);

  @override
  _NameInputTextFieldState createState() => _NameInputTextFieldState();
}

class _NameInputTextFieldState extends State<NameInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Name',

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
  const EmailInputTextField({Key? key}) : super(key: key);

  @override
  _EmailInputTextFieldState createState() => _EmailInputTextFieldState();
}

class _EmailInputTextFieldState extends State<EmailInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',

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
  const PhoneInputTextField({Key? key}) : super(key: key);

  @override
  _PhoneInputTextFieldState createState() => _PhoneInputTextFieldState();
}

class _PhoneInputTextFieldState extends State<PhoneInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Phone',

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
  const PasswordInputTextField({Key? key}) : super(key: key);

  @override
  _PasswordInputTextFieldState createState() => _PasswordInputTextFieldState();
}

class _PasswordInputTextFieldState extends State<PasswordInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Password',

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
  const ConfirmPasswordInputTextField({Key? key}) : super(key: key);

  @override
  _ConfirmPasswordTextFieldState createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState
    extends State<ConfirmPasswordInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Confirm Password',

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
  const AddressInputTextField({Key? key}) : super(key: key);

  @override
  _AddressInputTextFieldState createState() => _AddressInputTextFieldState();
}

class _AddressInputTextFieldState extends State<AddressInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null, // Allows unlimited lines of text input

      decoration: InputDecoration(
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
  const ContactPersonInputTextField({Key? key}) : super(key: key);

  @override
  _ContactPersonInputTextFieldState createState() =>
      _ContactPersonInputTextFieldState();
}

class _ContactPersonInputTextFieldState
    extends State<ContactPersonInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Contact name',

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


class CheckBoxRow extends StatefulWidget {
  @override
  _CheckBoxRowState createState() => _CheckBoxRowState();
}

class _CheckBoxRowState extends State<CheckBoxRow> {
  bool machineModuleChecked = false;
  bool clientModuleChecked = false;
  bool userPrivilegeChecked = false;
  bool activeChecked = true; // Assuming Active is initially checked

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomCheckbox(
              value: machineModuleChecked,
              onChanged: (bool? value) {
                setState(() {
                  machineModuleChecked = value ?? false;
                });
              },
              activeColor: colorMixGrad, // Change the color of the checkbox
            ),
            const Text('Machine Module'),
            const SizedBox(width: 20),
            CustomCheckbox(
              value: clientModuleChecked,
              onChanged: (bool? value) {
                setState(() {
                  clientModuleChecked = value ?? false;
                });
              },
              activeColor: colorMixGrad, // Change the color of the checkbox
            ),
            const Text('Client Module'),
          ],
        ),
        const SizedBox(height: 10), // Adjust as needed for spacing
        Row(
          children: [
            CustomCheckbox(
              value: userPrivilegeChecked,
              onChanged: (bool? value) {
                setState(() {
                  userPrivilegeChecked = value ?? false;
                });
              },
              activeColor: colorMixGrad, // Change the color of the checkbox
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
                  onChanged: (bool? value) {
                    setState(() {
                      activeChecked = value ?? false;
                    });
                  },
                  activeColor: colorMixGrad, // Change the color of the radio
                ),
                Text('Active'),
                SizedBox(width: 20),
                CustomRadio(
                  value: false,
                  groupValue: activeChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      activeChecked = value ?? false;
                    });
                  },
                  activeColor: colorMixGrad, // Change the color of the radio
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

// Custom Checkbox widget to change its color
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

// Custom Radio widget to change its color
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