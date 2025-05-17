import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../color/colors.dart';
import '../../globals.dart';
import '../../model/all_user.dart';
import '../../network/ApiService.dart';
import '../../utils/global_textfields.dart';
import '../../utils/popup_radio_checkbox.dart';

class AddUser extends StatefulWidget {
  final User? user;

  const AddUser({super.key, this.user});

  @override
  State<StatefulWidget> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // State variables
  String? selectedUserRole;
  bool activeChecked = true;
  String? fullPhoneNumber;
  bool isEditing = false;
  bool isLoading = false;

  // Module access map
  final Map<String, bool> moduleStatus = {
    'Machine': false,
    'Client': false,
    'UserPrivilege': false,
    'TonerRequest': false,
    'Acknowledgement': false,
    'Dispatch': false,
    'Receive': false,
  };

  // Role configurations
  final Map<String, Map<String, bool>> roleConfigurations = {
    'Admin': {
      'Machine': true,
      'Client': true,
      'UserPrivilege': true,
      'TonerRequest': true,
      'Acknowledgement': true,
      'Dispatch': true,
      'Receive': true,
    },
    'User (Custom permissions)': {
      'Machine': false,
      'Client': false,
      'UserPrivilege': false,
      'TonerRequest': false,
      'Acknowledgement': false,
      'Dispatch': false,
      'Receive': true,
    },
    'Logistics': {
      'Machine': false,
      'Client': false,
      'UserPrivilege': false,
      'TonerRequest': false,
      'Acknowledgement': false,
      'Dispatch': true,
      'Receive': true,
    },
    'Engineer/Technician': {
      'Machine': false,
      'Client': false,
      'UserPrivilege': false,
      'TonerRequest': false,
      'Acknowledgement': false,
      'Dispatch': false,
      'Receive': true,
    },
  };

  @override
  void initState() {
    super.initState();
    isEditing = widget.user != null;

    if (isEditing) {
      _initializeForEditing();
    } else {
      // Set default user role for new users
      selectedUserRole = 'User (Custom permissions)';
      _updateModuleVisibility(selectedUserRole);
    }
  }

  void _initializeForEditing() {
    // Set form field values
    nameController.text = widget.user!.name;
    emailController.text = widget.user!.email;

    // Phone handling
    fullPhoneNumber = widget.user!.phone;
    if (widget.user?.phone != null) {
      List<String> phNumber = widget.user!.phone.split(" ");
      if (phNumber.length > 1) {
        phoneController.text = phNumber[1];
      } else {
        phoneController.text = widget.user!.phone;
      }
    }

    // Set role
    selectedUserRole = widget.user!.userRole;

    // Set active status
    activeChecked = widget.user!.isActive == '1';

    // Set module access
    moduleStatus['Machine'] = widget.user!.machineModule == '1';
    moduleStatus['Client'] = widget.user!.clientModule == '1';
    moduleStatus['UserPrivilege'] = widget.user!.userModule == '1';
    moduleStatus['TonerRequest'] = widget.user!.tonerRequestModule == '1';
    moduleStatus['Acknowledgement'] = widget.user!.acknowledgeModule == '1';
    moduleStatus['Dispatch'] = widget.user!.dispatchModule == '1';
    moduleStatus['Receive'] = widget.user!.receiveModule == '1';

    // Update module visibility and apply role configurations
    _updateModuleVisibility(selectedUserRole);
  }

  void _updateModuleVisibility(String? role) {
    if (role != null && roleConfigurations.containsKey(role)) {
      final config = roleConfigurations[role]!;

      setState(() {
        if (!isEditing || role != widget.user?.userRole) {
          moduleStatus.forEach((key, _) {
            if (config.containsKey(key)) {
              moduleStatus[key] = config[key] ?? false;
            }
          });
        }
      });
    }
  }

  bool isValidPassword(String password) {
    final passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    final phoneRegExp = RegExp(r'^[0-9]{7,15}$');
    return phoneRegExp.hasMatch(phone);
  }

  bool _validateForm() {
    if (selectedUserRole == null) {
      showSnackBar(context, "Please select User Role.");
      return false;
    }

    if (nameController.text.isEmpty) {
      showSnackBar(context, "Full Name is required.");
      return false;
    }

    if (emailController.text.isEmpty) {
      showSnackBar(context, "Email is required & must be unique.");
      return false;
    }

    if (!isValidEmail(emailController.text)) {
      showSnackBar(context, "Please enter a valid email address.");
      return false;
    }

    if (phoneController.text.isEmpty) {
      showSnackBar(context, "Phone is required & must be unique.");
      return false;
    }

    if (!isValidPhoneNumber(phoneController.text)) {
      showSnackBar(context, "Please enter a valid phone number.");
      return false;
    }

    // Password validation only for new users or when password is provided
    if (!isEditing || passwordController.text.isNotEmpty) {
      if (passwordController.text.isEmpty && !isEditing) {
        showSnackBar(context, "Password is required for new users.");
        return false;
      }

      if (passwordController.text.isNotEmpty && !isValidPassword(passwordController.text)) {
        showSnackBar(context,
            "Password must be at least 8 characters long and include uppercase, lowercase, digit, and special character.");
        return false;
      }

      if (passwordController.text.isNotEmpty && confirmPasswordController.text.isEmpty) {
        showSnackBar(context, "Confirm Password is required.");
        return false;
      }

      if (passwordController.text.isNotEmpty && confirmPasswordController.text != passwordController.text) {
        showSnackBar(context, "Confirm password not matched! Please check.");
        return false;
      }
    }

    return true;
  }

  void _submitForm() {
    if (_validateForm()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmSubmitDialog(
            onConfirm: () {
              submitUser();
            },
          );
        },
      );
    }
  }

  Future<void> submitUser() async {
    setState(() {
      isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final ApiService apiService = ApiService();
      late final Map<String, dynamic> response;

      final Map<String, String> userData = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': fullPhoneNumber ?? phoneController.text,
        'isActive': activeChecked ? '1' : '0',
        'userRole': selectedUserRole ?? 'User',
        'machineModule': moduleStatus['Machine']! ? '1' : '0',
        'clientModule': moduleStatus['Client']! ? '1' : '0',
        'userModule': moduleStatus['UserPrivilege']! ? '1' : '0',
        'acknowledgeModule': moduleStatus['Acknowledgement']! ? '1' : '0',
        'tonerRequestModule': moduleStatus['TonerRequest']! ? '1' : '0',
        'dispatchModule': moduleStatus['Dispatch']! ? '1' : '0',
        'receiveModule': moduleStatus['Receive']! ? '1' : '0',
      };

      if (passwordController.text.isNotEmpty) {
        userData['password'] = passwordController.text;
      }

      if (isEditing) {
        userData['user_id'] = widget.user!.id.toString();
        response = await apiService.updateUser(userData);
      } else {
        response = await apiService.addUser(userData);
      }

      _handleApiResponse(response);
    } catch (e) {
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Failed to connect to the server. Please try again later.");
      debugPrint("API Error: $e");
    }
  }

  void _handleApiResponse(Map<String, dynamic> response) {
    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });

    if (response.containsKey('error') && response.containsKey('status')) {
      if (!response['error'] && response['status'] == 200) {
        if (response['message'] == 'Success') {
          if (!isEditing) {
            _clearFormFields();
          }
          Navigator.pop(context, true);
        } else {
          showSnackBar(context, response['message']);
        }
      } else {
        showSnackBar(context, response['message']);
      }
    } else {
      showSnackBar(context, "Unexpected response from server. Please try again later.");
    }
  }

  void _clearFormFields() {
    nameController.text = "";
    emailController.text = "";
    phoneController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    selectedUserRole = null;
    moduleStatus.updateAll((_, __) => false);
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
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
          const SizedBox(width: 7),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  UserFormHeader(
                    user: widget.user,
                    tooltipMessage:
                    "Roles have Access:\nAdmin: All Modules\nClient: Toner Request, Acknowledgement\nUser: Custom modules\nLogistics: SupplyChain -> Dispatch, Receive\nEngineer: SupplyChain -> Receive",
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader("User Roles"),
                  UserRolesSpinner(
                    selectedValue: selectedUserRole,
                    onChanged: (newValue) {
                      setState(() {
                        selectedUserRole = newValue;
                        _updateModuleVisibility(newValue);
                      });
                    },
                  ),
                  _buildFormField(
                    "Name",
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Name',
                    ),
                  ),
                  _buildFormField(
                    "Email",
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      fieldType: TextFieldType.email,
                    ),
                  ),
                  _buildFormField(
                    "Phone",
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Phone number',
                      fieldType: TextFieldType.intlPhone,
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
                  ),
                  _buildFormField(
                    "Password ${isEditing ? '(Optional for update)' : ''}",
                    CustomTextField(
                      controller: passwordController,
                      hintText: isEditing ? 'Enter to change password' : 'Password',
                      fieldType: TextFieldType.password,
                    ),
                  ),
                  _buildFormField(
                    "Confirm Password ${isEditing ? '(Optional for update)' : ''}",
                    CustomTextField(
                      controller: confirmPasswordController,
                      hintText: isEditing ? 'Confirm new password' : 'Confirm Password',
                      fieldType: TextFieldType.password,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _buildSectionHeader("Modules Access"),
                        ImprovedCheckBoxRow(
                          moduleStatus: moduleStatus,
                          onModuleChanged: (key, value) {
                            setState(() {
                              moduleStatus[key] = value;
                            });
                          },
                          activeChecked: activeChecked,
                          onActiveChanged: (value) {
                            setState(() {
                              activeChecked = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 100),
                    child: GradientButton(
                      gradientColors: const [colorFirstGrad, colorSecondGrad],
                      height: 45.0,
                      width: 10.0,
                      radius: 25.0,
                      buttonText: isLoading ? "Processing..." : "Submit",
                      onPressed: _submitForm,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFormField(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(label),
          field,
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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

  static const List<String> _roles = [
    'Admin',
    'User (Custom permissions)',
    'Logistics',
    'Engineer/Technician'
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: const Text('Select Role'),
      items: _roles.map((String value) {
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
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class ImprovedCheckBoxRow extends StatelessWidget {
  final Map<String, bool> moduleStatus;
  final Function(String, bool) onModuleChanged;
  final bool activeChecked;
  final ValueChanged<bool> onActiveChanged;

  const ImprovedCheckBoxRow({
    required this.moduleStatus,
    required this.onModuleChanged,
    required this.activeChecked,
    required this.onActiveChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildModuleRow('Machine', 'Client'),
            const SizedBox(height: 10),
            _buildModuleRow('TonerRequest', 'Acknowledgement'),
            const SizedBox(height: 10),
            _buildModuleRow('Dispatch', 'Receive'),
            const SizedBox(height: 10),
            _buildModuleRow('UserPrivilege',null),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text('Active Status:', style: TextStyle(fontWeight: FontWeight.w500)),

            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: activeChecked,
                  onChanged: (value) => onActiveChanged(value ?? true),
                  activeColor: colorMixGrad,
                ),
                const Text('Active'),
                const SizedBox(width: 15),
                Radio<bool>(
                  value: false,
                  groupValue: activeChecked,
                  onChanged: (value) => onActiveChanged(value ?? false),
                  activeColor: colorMixGrad,
                ),
                const Text('Inactive'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModuleRow(String firstModule, String? secondModule) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: moduleStatus[firstModule] ?? false,
                onChanged: (value) => onModuleChanged(firstModule, value ?? false),
                activeColor: colorMixGrad,
              ),
              Flexible(
                child: Text(
                  _formatModuleName(firstModule),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        if (secondModule != null)
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: moduleStatus[secondModule] ?? false,
                  onChanged: (value) => onModuleChanged(secondModule, value ?? false),
                  activeColor: colorMixGrad,
                ),
                Flexible(
                  child: Text(
                    _formatModuleName(secondModule),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatModuleName(String moduleName) {
    if (moduleName == 'UserPrivilege') return 'User Privilege';
    if (moduleName == 'TonerRequest') return 'Toner Request';
    if (moduleName == 'SupplyChain') return 'Supply Chain';
    return moduleName;
  }
}

class UserFormHeader extends StatelessWidget {
  final User? user;
  final String tooltipMessage;

  const UserFormHeader({
    required this.user,
    required this.tooltipMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              user != null ? "Update User:" : "Add New:",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24.0,
                color: colorMixGrad,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Tooltip(
          message: tooltipMessage,
          preferBelow: true,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(color: Colors.white),
          child: IconButton(
            icon: const Icon(Icons.info_outline, color: colorMixGrad),
            onPressed: () => _showDetailedTooltip(context),
          ),
        ),
      ],
    );
  }

  void _showDetailedTooltip(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: tooltipMessage.split("\n").map((line) {
                final parts = line.split(":");
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        if (parts.isNotEmpty)
                          TextSpan(
                            text: "${parts[0]}:",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        if (parts.length > 1) TextSpan(text: parts[1]),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}