import 'package:flutter/material.dart';

import '../../color/colors.dart';
import '../../globals.dart';
import '../home/client/add_client.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showEmailInput = true;
  bool showOtpInput = false;
  bool showPasswordInput = false;

  void showOtpInputField() {
    setState(() {
      showEmailInput = false;
      showOtpInput = true;
    });
  }

  void showPasswordInputFields() {
    setState(() {
      showOtpInput = false;
      showPasswordInput = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/ic_tracesci.png',
                    fit: BoxFit.contain,
                    height: 70,
                  ),
                ),
                SizedBox(height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Enter your email to receive OTP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 70),
                    if (showEmailInput)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          EmailInputTextField(controller: emailController),
                          SizedBox(height: 20),
                          SizedBox(
                            child: GradientButton(
                              gradientColors: [colorFirstGrad, colorSecondGrad],
                              // Removed const from gradientColors
                              height: 45.0,
                              width: 10.0,
                              radius: 25.0,
                              buttonText: "Get OTP",
                              // Dynamic text, removed const
                              onPressed: () {
                                showOtpInputField();
                              },
                            ),
                          ),
                        ],
                      ),
                    if (showOtpInput)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Enter OTP received on your email",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: otpController,
                            decoration: InputDecoration(
                              labelText: 'OTP',
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            child: GradientButton(
                              gradientColors: [colorFirstGrad, colorSecondGrad],
                              // Removed const from gradientColors
                              height: 45.0,
                              width: 10.0,
                              radius: 25.0,
                              buttonText: "Submit OTP",
                              // Dynamic text, removed const
                              onPressed: () {
                                showPasswordInputFields();
                              },
                            ),
                          ),
                        ],
                      ),
                    if (showPasswordInput)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Enter new password",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: newPasswordController,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm New Password',
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                            SizedBox(
                              child: GradientButton(
                                gradientColors: [colorFirstGrad, colorSecondGrad],
                                // Removed const from gradientColors
                                height: 45.0,
                                width: 10.0,
                                radius: 25.0,
                                buttonText: "Submit Password",
                                // Dynamic text, removed const
                                onPressed:(){

                                  // Validate new password and confirm password
                                  if (newPasswordController.text !=
                                      confirmPasswordController.text) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Password mismatch"),
                                          content: Text(
                                              "New password and confirm password do not match."),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }
                                  // Passwords match, proceed with your logic to update the password
                                  // For demo purposes, just navigate back to previous screen
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),

                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
