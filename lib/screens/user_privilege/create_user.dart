import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../color/colors.dart';

class CreateUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreateUserPageStatus();
  }
}

class CreateUserPageStatus extends StatefulWidget {
  @override
  _CreateUserPageStatusState createState() => _CreateUserPageStatusState();
}

class _CreateUserPageStatusState extends State<CreateUserPageStatus> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController privilegeController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    privilegeController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25.0,
                            right: 25.0,
                            top: 25.0,
                          ),
                          child: Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildTextField('Name', 'Full Name', nameController),
                        _buildTextField('Email', 'Email', emailController),
                        _buildTextField(
                            'Mobile', 'Mobile Number', mobileController),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0,right: 18),
                                child: CheckBoxRow(),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Image.asset(
        "assets/images/app_name_logo.png",
        width: 120,
        height: 40,
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: colorMixGrad),
              ),
              hintText: hint,
            ),
          ),
        ],
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

