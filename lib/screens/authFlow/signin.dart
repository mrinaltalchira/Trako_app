import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tonner_app/screens/home/home.dart';
import '../../color/colors.dart';
import '../../globals.dart';



class AuthProcess extends StatefulWidget {
  const AuthProcess({Key? key}) : super(key: key);

  @override
  _AuthProcessState createState() => _AuthProcessState();
}

class _AuthProcessState extends State<AuthProcess> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
          height: 50,
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/app_name_logo.png',
            fit: BoxFit.contain,
            height: 40, // Adjust height as needed
          ),
        ),
      ),*/
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - kToolbarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30,),
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/ic_tracesci.png',
                    fit: BoxFit.contain,
                    height: 70, // Adjust height as needed
                  ),
                ),

                const SizedBox(height: 70,),

                Container(
                  width: 400, // Adjust width as needed
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Phone No.',
                            style: TextStyle(fontSize: 16), // Adjust the font size here
                          ),
                        ),

                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Email',
                            style: TextStyle(fontSize: 16), // Adjust the font size here
                          ),
                        ),
                      ),


                    ],
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: colorFirstGrad, // Example indicator color
                    ),
                    labelColor: Colors.white, // Example label text color
                    unselectedLabelColor: Colors.black, // Example unselected label text color
                  ),
                ),
                const SizedBox(height: 40),
                // Conditional display based on selected tab
                if (_tabController.index == 0) // Phone no. tab selected
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: const Column(
                      children: [
                        MobileInputTextField(),
                        PasswordInputTextField(),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: const Column(
                      children: [
                        EmailInputTextField(),
                        PasswordInputTextField(),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    showSnackBar(context,"Clicked on login");
                  },
                  
                  child: SizedBox(
                    width: 200,
                    child: GradientButton(
                      gradientColors: const [colorFirstGrad, colorSecondGrad],
                      height: 45.0,
                      width: 10.0,
                      radius: 25.0,
                      buttonText: "Sign in",
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                        showSnackBar(context, "Welcome Onboard.");
                      },
                    ),
                  )
                ),
                const SizedBox(height: 10),
                 RichText(
                  text: TextSpan(

                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Forgot password? ',
                        style: TextStyle(color: Colors.black,fontSize: 13),
                      ),
                      TextSpan(
                        text: 'Click here',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 13
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to forgot password screen or handle click event
                            showSnackBar(context,"Forget password to be implemented");
                          },
                      ),
                    ],
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

class MobileInputTextField extends StatelessWidget {
  const MobileInputTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50,
                  height: 22,
                  child: Transform.translate(
                    offset: const Offset(5, 12),
                    child: const IntlPhoneField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: false,
                      ),
                      initialCountryCode: 'IN',
                      showCountryFlag: false,
                      showDropdownIcon: false,
                      showCursor: false,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      dropdownTextStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const SizedBox(
                  width: 40,
                  child: const LinearGradientDivider(
                    height: 1,
                    gradient: LinearGradient(
                      colors: [colorFirstGrad, colorSecondGrad],
                      // Example gradient colors
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(5, 10),
                    child: Container(
                      width: 200,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Mobile No.',
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 180,
                    child: const LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                        // Example gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailInputTextField extends StatelessWidget {
  const EmailInputTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(5, 10),
                    child: Container(
                      width: 200,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Enter Email',
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.emailAddress,

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 180,
                    child: const LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                        // Example gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                ],
              ),
            ),
          ],
        ),
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
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(5, 10),
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Password',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),
                        ],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 180,
                    child: const LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinearGradientDivider extends StatelessWidget {
  const LinearGradientDivider({
    Key? key,
    required this.height,
    required this.gradient,
  }) : super(key: key);

  final double height;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
    );
  }
}
