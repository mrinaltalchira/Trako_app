import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/screens/client/client.dart';
import 'package:tonner_app/screens/home/home.dart';

class AddClient extends StatelessWidget {
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
                    const NameInputTextField(),
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
                    const CityInputTextField(),
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
                      "Address",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    const AddressInputTextField(),
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
                    const ContactPersonInputTextField(),
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

class CityInputTextField extends StatefulWidget {
  const CityInputTextField({Key? key}) : super(key: key);

  @override
  _CityInputTextFieldState createState() => _CityInputTextFieldState();
}

class _CityInputTextFieldState extends State<CityInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,

      decoration: InputDecoration(
        hintText: 'City',

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
          borderSide: BorderSide(color: colorMixGrad), // Border color when focused
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
  _ContactPersonInputTextFieldState createState() => _ContactPersonInputTextFieldState();
}

class _ContactPersonInputTextFieldState extends State<ContactPersonInputTextField> {
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
