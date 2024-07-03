import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/network/ApiService.dart';
import 'package:tonner_app/screens/client/client.dart';
import 'package:tonner_app/screens/home/home.dart';

class AddMachine extends StatefulWidget {
   AddMachine({super.key});

  @override
  State<AddMachine> createState() => _AddMachineState();
}


class _AddMachineState extends State<AddMachine> {
   final TextEditingController machine_name_Controller = TextEditingController();

   final TextEditingController machine_code_Controller = TextEditingController();

  @override
  Widget build(BuildContext context){
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
                     MachineNameInputTextField(controller: machine_name_Controller,),
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
                     MachineCodeInputTextField(controller: machine_code_Controller,),
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
                      ));*/  validateAndSignIn();

                            },
                          ),
                        )),
                    const SizedBox(
                      height: 100,
                    )
                  ])
          )
      ),
    );
  }

   Future<void> validateAndSignIn() async {

     if (machine_name_Controller.text.isEmpty) {
        showSnackBar(context, "Model Name is required.");
        return;
     }

     if (machine_code_Controller.text.isEmpty) {
        showSnackBar(context, "Model Code is required.");
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
       late final Map<String, dynamic> addMachineResponse;


       addMachineResponse = await apiService.addMachine(
           model_name: machine_name_Controller.text,
           model_code: machine_code_Controller.text
       );

       Navigator.of(context).pop();

       // Check if the login was successful based on the response structure
       if (addMachineResponse.containsKey('error') &&
           addMachineResponse.containsKey('status')) {
         if (!addMachineResponse['error'] && addMachineResponse['status'] == 200) {
           if (addMachineResponse['message'] == 'Success') {
             machine_name_Controller.text = "";
             machine_code_Controller.text = "";
             showSnackBar(context, "Client created successfully.");
           } else {
             showSnackBar(context, addMachineResponse['message']);
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

}

class MachineNameInputTextField extends StatefulWidget {
  final TextEditingController controller;
   MachineNameInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _MachineNameInputTextFieldState createState() => _MachineNameInputTextFieldState();
}

class _MachineNameInputTextFieldState extends State<MachineNameInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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
          borderSide: const BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black
      ),
    );
  }
}

class MachineCodeInputTextField extends StatefulWidget {
  final TextEditingController controller;
   MachineCodeInputTextField({Key? key, required this.controller}) : super(key: key);

  @override
  _MachineCodeInputTextFieldState createState() => _MachineCodeInputTextFieldState();
}

class _MachineCodeInputTextFieldState extends State<MachineCodeInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(

      controller: widget.controller,
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