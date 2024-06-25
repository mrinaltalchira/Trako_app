import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/screens/client/client.dart';
import 'package:tonner_app/screens/home/home.dart';

class AddMachine extends StatelessWidget {
  const AddMachine({super.key});

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
              padding: EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        "Add New Machine:",
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
                      height: 30,
                    ),
                    Text(
                      "Model Name",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    const MachineNameInputTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Model Code",
                      // Dynamic text, removed const
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    const MachineCodeInputTextField(),
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




class MachineNameInputTextField extends StatefulWidget {
  const MachineNameInputTextField({Key? key}) : super(key: key);

  @override
  _MachineNameInputTextFieldState createState() => _MachineNameInputTextFieldState();
}

class _MachineNameInputTextFieldState extends State<MachineNameInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,

      decoration: InputDecoration(
        hintText: 'Model Name',

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


class MachineCodeInputTextField extends StatefulWidget {
  const MachineCodeInputTextField({Key? key}) : super(key: key);

  @override
  _MachineCodeInputTextFieldState createState() => _MachineCodeInputTextFieldState();
}

class _MachineCodeInputTextFieldState extends State<MachineCodeInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,

      decoration: InputDecoration(
        hintText: 'Model Code',

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