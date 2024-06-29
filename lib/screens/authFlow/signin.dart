import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../color/colors.dart';
import '../../globals.dart';
import '../client/client.dart';
import '../home/home.dart';

class AuthProcess extends StatefulWidget {
  const AuthProcess({Key? key}) : super(key: key);

  @override
  _AuthProcessState createState() => _AuthProcessState();
}

class _AuthProcessState extends State<AuthProcess> {
  bool isPhoneInput = true; // Flag to track whether to show phone input or email input

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
                SizedBox(height: 30), // Removed const from SizedBox
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/ic_tracesci.png',
                    fit: BoxFit.contain,
                    height: 70, // Adjust height as needed
                  ),
                ),
                SizedBox(height: 50), // Removed const from SizedBox
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
                    ? IntlPhoneInputTextField()
                    : EmailInputTextField(), // Dynamic widget, removed const
                SizedBox(height: 10), // Removed const from SizedBox
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
                            // Implement forgot password functionality
                          },
                          child: Text(
                            "Forgot password",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5), // Removed const from SizedBox
                  ],
                ),
                PasswordInputTextField(),
                SizedBox(height: 60), // Removed const from SizedBox
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
                        // Validate inputs if needed
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                        showSnackBar(context, "Welcome Onboard.");
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15), // Removed const from SizedBox
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
                    Text(
                      "or sign in with", // Removed const from text
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
                SizedBox(height: 15), // Removed const from SizedBox
                SizedBox(
                  child: GradientButton(
                    gradientColors: [colorMixGrad, colorMixGrad],
                    // Removed const from gradientColors
                    height: 45.0,
                    width: 10.0,
                    radius: 25.0,
                    buttonText: isPhoneInput ? "Email" : "Phone number",
                    // Dynamic text, removed const
                    onPressed:
                        toggleInputType, // Toggle between phone and email input
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IntlPhoneInputTextField extends StatelessWidget {
  const IntlPhoneInputTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorMixGrad, // Example focused border color
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: '|  Phone number',
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 20.0), // Removed const from EdgeInsets
      ),
      initialCountryCode: 'IN',
      // Example initial country code
      onChanged: (phone) {
        print(phone.completeNumber); // Handle country code and number
      },
      showCountryFlag: true,
      showDropdownIcon: false,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      dropdownTextStyle: TextStyle(
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
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 16.0), // Removed const from EdgeInsets
      ),
      obscureText: _obscureText,
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
