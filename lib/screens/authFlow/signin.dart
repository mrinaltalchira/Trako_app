import 'package:flutter/material.dart';
import 'package:Trako/model/login_model.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/pref_manager.dart';
import 'package:Trako/screens/authFlow/utils.dart';
import '../../color/colors.dart';
import '../../globals.dart';
import '../../utils/global_textfields.dart';
import '../home/home.dart';

class AuthProcess extends StatefulWidget {
  const AuthProcess({Key? key}) : super(key: key);

  @override
  _AuthProcessState createState() => _AuthProcessState();
}

class _AuthProcessState extends State<AuthProcess> {

  bool isPhoneInput = true; // Flag to track whether to show phone input or email input
  final ApiService apiService = ApiService();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? fullPhoneNumber;

  void _handlePhoneNumberChanged(String phoneNumber) {
    setState(() {
      fullPhoneNumber = phoneNumber;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Method to toggle between phone input and email input
  void toggleInputType() {
    setState(() {
      isPhoneInput = !isPhoneInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            // Removed const from padding
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 70),
                // Removed const from SizedBox
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/ic_trako.png',
                    fit: BoxFit.contain,
                    height: 200, // Adjust height as needed
                  ),
                ),
                // Removed const from SizedBox
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10), // Removed const from SizedBox
                    Text(
                      "Welcome to the app",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 70), // Removed const from SizedBox
                    Text(
                      isPhoneInput ? "Phone number" : "Email",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5), // Removed const from SizedBox
                  ],
                ),
                isPhoneInput
                    ? CustomTextField(
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
                )
                    :  CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  fieldType: TextFieldType.email,
                ),
                // Dynamic widget, removed const
                SizedBox(height: 10),
                // Removed const from SizedBox
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/forgot_pass');
                          },
                          child: Text(
                            "Forgot password",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: colorMixGrad),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5), // Removed const from SizedBox
                  ],
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  fieldType: TextFieldType.password,
                ),
                SizedBox(height: 60),
                // Removed const from SizedBox
                GestureDetector(
                  onTap: () {
                    showSnackBar(context, "Clicked on login");
                  },
                  child: SizedBox(
                    child: GradientButton(
                      gradientColors: [colorFirstGrad, colorSecondGrad],
                      // Removed const from gradientColors
                      height: 45.0,
                      width: 10.0,
                      radius: 25.0,
                      buttonText: "Sign in",
                      // Dynamic text, removed const
                      onPressed: () {
                        validateAndSignIn();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Removed const from SizedBox
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        // Removed const from margin
                        child: Divider(
                          color: Colors.grey,
                          height: 36,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "or sign in with",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        // Removed const from margin
                        child: Divider(
                          color: Colors.grey,
                          height: 36,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Removed const from SizedBox
                SizedBox(
                  child: GradientButton(
                      gradientColors: [colorFirstGrad, colorSecondGrad],
                      // Removed const from gradientColors
                      height: 45.0,
                      width: 10.0,
                      radius: 25.0,
                      buttonText: isPhoneInput ? "Email" : "Phone number",
                      // Dynamic text, removed const
                      onPressed: () {
                        toggleInputType(); // Toggle between phone and email input
                      }),
                ),
                SizedBox(height: 30,),
                Text(
                  'Powered by Tracesci.in',
                  style: TextStyle(
                    fontSize: 14.0, // Adjust the font size as needed
                    color: Colors.grey, // Adjust the color to match your app's theme
                    fontStyle: FontStyle.italic, // Optionally italicize the text
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

 /* Future<void> validateAndSignIn() async {
    // Validate phone number or email
    if (isPhoneInput) {
      if (phoneController.text.isEmpty) {
        showSnackBar(context, "Phone number is required.");
        return;
      }
      if (phoneController.text.length < 7) {
        showSnackBar(context, "Phone number is invalid.");
        return;
      }
    } else {
      if (emailController.text.isEmpty) {
        showSnackBar(context, "Email is required.");
        return;
      }
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      showSnackBar(context, "Password is required.");
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      final ApiService apiService = ApiService();
      late final Map<String, dynamic> loginResponse;

      // Determine whether to use phone or email for login
      if (isPhoneInput) {
        loginResponse = await apiService.login(
            null, fullPhoneNumber.toString(), passwordController.text);
      } else {
        loginResponse = await apiService.login(
            emailController.text, null, passwordController.text);
      }
print("sdfdffdsdxdd   $loginResponse");
      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Check response structure
      if (loginResponse.containsKey('success') &&
          loginResponse.containsKey('status')) {

        if (loginResponse['success'] ) {
          if (loginResponse['status'] == 200) {
            try {
              // Extract and handle user data
              User user = User.fromJson(loginResponse['data']['user']);

              String token = user.token;
              if (token.isNotEmpty) {
                // Save user details to preferences
                await PrefManager().setToken(token);
                await PrefManager().setUserName(user.name);
                await PrefManager().setUserEmail(user.email);
                await PrefManager().setUserPhone(user.phone);
                await PrefManager().setUserRole(user.userRole);
                await PrefManager().setUserStatus(user.isActive.toString());
                await PrefManager().setUserModule(user.userModule.toString());
                await PrefManager().setClientModule(user.clientModule.toString());
                await PrefManager().setMachineModule(user.machineModule.toString());
                await PrefManager().setAcknowledgeModuleModule(user.acknowledgeModule.toString());
                await PrefManager().setTonerRequestModule(user.tonerRequestModule.toString());
                await PrefManager().setDispatchModule(user.dispatchModule.toString());
                await PrefManager().setReceiveModule(user.receiveModule.toString());
                await PrefManager().setIsLoggedIn(true);

                // Navigate to home screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              } else {
                showSnackBar(context, "Token not found in response.");
              }

            } catch (e) {
              showSnackBar(context, "Error parsing user data.");
              print("User Parsing Error: $e");
            }

          } else {
            showSnackBar(context, loginResponse['message']);
          }
        } else {
          showSnackBar(context, "Login failed. Please check your credentials.");
        }
      } else {
        showSnackBar(context, "Unexpected response from server. Please try again later.");
      }
    } catch (e) {
      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Handle API errors
      showSnackBar(context, "Failed to connect to the server. Please try again later.");
      print("Login API Error: $e");
    }
  }*/
  Future<void> validateAndSignIn() async {
    // Validate phone number or email
    if (isPhoneInput) {
      if (phoneController.text.isEmpty) {
        showSnackBar(context, "Phone number is required.");
        return;
      }
      if (phoneController.text.length < 7) {
        showSnackBar(context, "Phone number is invalid.");
        return;
      }
    } else {
      if (emailController.text.isEmpty) {
        showSnackBar(context, "Email is required.");
        return;
      }
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
        showSnackBar(context, "Please enter a valid email address.");
        return;
      }
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      showSnackBar(context, "Password is required.");
      return;
    }

    // Show loading indicator with improved UI
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text(
                  "Signing in...",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final ApiService apiService = ApiService();
      Map<String, dynamic> loginResponse;

      // Determine whether to use phone or email for login
      if (isPhoneInput) {
        loginResponse = await apiService.login(
            null,
            fullPhoneNumber.toString(),
            passwordController.text
        );
      } else {
        loginResponse = await apiService.login(
            emailController.text,
            null,
            passwordController.text
        );
      }

      // Log response for debugging
      print("Login response: $loginResponse");

      // Dismiss loading indicator
      Navigator.of(context, rootNavigator: true).pop();

      // Handle response based on success flag
      if (loginResponse.containsKey('success')) {
        if (loginResponse['success'] == true) {
          // Show success message
          if (loginResponse.containsKey('message')) {
            // Optional: Show success message briefly
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loginResponse['message']),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }

          // Process user data and login
          if (loginResponse.containsKey('data') &&
              loginResponse['data'] is Map<String, dynamic> &&
              loginResponse['data'].containsKey('user')) {
            try {
              final userData = loginResponse['data']['user'];
              final userType = loginResponse['data']['user_type'] ?? '';
              final token = loginResponse['data']['token'] ?? '';

              // Ensure token exists in user data
              if (!userData.containsKey('token') || userData['token'] == null) {
                userData['token'] = token;
              }

              // Add user_type to user data
              userData['user_type'] = userType;

              // Parse user data
              User user = User.fromJson(userData);

              // Verify token exists
              if (user.token.isNotEmpty) {
                // Save user data to preferences
                await saveUserData(user);

                // Navigate to home screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              } else {
                showSnackBar(context, "Authentication error: Token not found.");
              }
            } catch (e) {
              showSnackBar(context, "Error processing user data: ${e.toString()}");
              print("User parsing error: $e");
            }
          } else {
            showSnackBar(context, "Invalid response format from server.");
          }
        } else {
          // Show error message from server
          String errorMessage = loginResponse['message'] ?? "Login failed. Please check your credentials.";
          showSnackBar(context, errorMessage);
        }
      } else {
        showSnackBar(context, "Unexpected response from server. Please try again.");
      }
    } catch (e) {
      // Dismiss loading indicator if still showing
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Handle general errors
      showSnackBar(context, "Connection error. Please check your internet and try again.");
      print("Login process error: $e");
    }
  }

// Helper function to save user data to preferences
  Future<void> saveUserData(User user) async {
    await PrefManager().setToken(user.token);
    await PrefManager().setUserName(user.name);
    await PrefManager().setUserEmail(user.email);
    await PrefManager().setUserPhone(user.phone);
    await PrefManager().setUserRole(user.userRole);
    await PrefManager().setUserStatus(user.isActive.toString());
    await PrefManager().setUserModule(user.userModule.toString());
    await PrefManager().setClientModule(user.clientModule.toString());
    await PrefManager().setMachineModule(user.machineModule.toString());
    await PrefManager().setAcknowledgeModuleModule(user.acknowledgeModule.toString());
    await PrefManager().setTonerRequestModule(user.tonerRequestModule.toString());
    await PrefManager().setDispatchModule(user.dispatchModule.toString());
    await PrefManager().setReceiveModule(user.receiveModule.toString());

    await PrefManager().setIsLoggedIn(true);
  }

  }

