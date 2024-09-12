import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/model/all_machine.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/home/home.dart';
import 'package:flutter/services.dart';

import '../../model/supply_fields_data.dart';
import '../add_toner/utils.dart';

class AddMachine extends StatefulWidget {
  final Machine? machine;
   const AddMachine({super.key, this.machine});

  @override
  State<AddMachine> createState() => _AddMachineState();
}


class _AddMachineState extends State<AddMachine> {

   final TextEditingController machine_name_Controller = TextEditingController();
   final TextEditingController machine_code_Controller = TextEditingController();


   List<SupplyClient> clients = [];
   bool activeChecked = true;
   final ApiService _apiService = ApiService();

   @override
   void initState() {
     super.initState();

     if (widget.machine != null) {
       machine_name_Controller.text = widget.machine!.modelName!;
       machine_code_Controller.text = widget.machine!.serialNo!;
       activeChecked = widget.machine!.isActive == "0";
     }
   }




   @override
  Widget build(BuildContext context){
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
                     Center(
                      child:  Text(
                        widget.machine != null ? "Update Machine:" : "Add New Machine:",
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
                      "Serial no.",
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

                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CheckBoxRow(
                          activeChecked: activeChecked,
                          onActiveChanged: (bool? value) {
                            setState(() {
                              activeChecked = value ?? false;
                            });
                          },
                        )
                      ],
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
                            onPressed: validateAndSignIn,
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
       showSnackBar(context, "Serial no is required.");
       return;
     }



     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return ConfirmSubmitDialog(
           onConfirm: () => addMachine(),
         );
       },
     );
   }

   Future<void> addMachine() async {
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return Center(child: CircularProgressIndicator());
       },
     );

     if(widget.machine != null){
       try {
         final ApiService apiService = ApiService();

         final addMachineResponse = await apiService.updateMachine(
           id:widget.machine!.id.toString(),
           model_name: machine_name_Controller.text,
           serial_no: machine_code_Controller.text,
           isActive: activeChecked ? '0' : '1',
         );

         Navigator.of(context).pop(); // Dismiss loading indicator

         if (addMachineResponse.containsKey('error') &&
             addMachineResponse.containsKey('status')) {
           if (!addMachineResponse['error'] &&
               addMachineResponse['status'] == 200) {
             if (addMachineResponse['message'] == 'Machine updated successfully') {
               Navigator.pop(context,true);
               // showSnackBar(context, addMachineResponse['message']);
             } else {
               showSnackBar(context, addMachineResponse['message']);
             }
           } else {
             showSnackBar( context, addMachineResponse['message']);
           }
         } else {
           showSnackBar(context,"Unexpected response from server. Please try again later.");
         }
       } catch (e) {
         Navigator.of(context).pop(); // Dismiss loading indicator
         showSnackBar(context, "Failed to connect to the server. Please try again later.");
         print("Add Machine API Error: $e");
       }
     }else{
       try {
         final ApiService apiService = ApiService();

         final addMachineResponse = await apiService.addMachine(
           model_name: machine_name_Controller.text,
           serial_no: machine_code_Controller.text,
           isActive: activeChecked ? '0' : '1',
         );

         Navigator.of(context).pop(); // Dismiss loading indicator

         if (addMachineResponse.containsKey('error') &&
             addMachineResponse.containsKey('status')) {
           if (!addMachineResponse['error'] &&
               addMachineResponse['status'] == 200) {
             if (addMachineResponse['message'] == 'Success') {
               machine_name_Controller.clear();
               machine_code_Controller.clear();
               // showSnackBar(context, addMachineResponse['message']);
               Navigator.pop(context,true);
             } else {
               showSnackBar(context, addMachineResponse['message']);
             }
           } else {
             showSnackBar(
                 context, addMachineResponse['message']);
           }
         } else {
           showSnackBar(context,
               "Unexpected response from server. Please try again later.");
         }
       } catch (e) {
         Navigator.of(context).pop(); // Dismiss loading indicator
         showSnackBar(context, "Failed to connect to the server. Please try again later.");
         print("Add Machine API Error: $e");
       }
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
        hintText: 'Serial no.',

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




class ConfirmSubmitDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmSubmitDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Confirm Submit',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colorMixGrad,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 0.5,
          ),
          const SizedBox(height: 8.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Are you sure you want to submit?',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  onConfirm(); // Call the callback to submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorMixGrad,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class CheckBoxRow extends StatelessWidget {
  final bool activeChecked;
  final ValueChanged<bool?> onActiveChanged;

  const CheckBoxRow({
    required this.activeChecked,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Active Status:',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomRadio(
                value: true,
                groupValue: activeChecked,
                onChanged: onActiveChanged,
                activeColor: colorMixGrad,
              ),
              const Text('Active'),
              SizedBox(width: 20),
              CustomRadio(
                value: false,
                groupValue: activeChecked,
                onChanged: onActiveChanged,
                activeColor: colorMixGrad,
              ),
              const Text('Inactive'),
            ],
          ),
        ],
      ),

    ]);
  }
}
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

class TimePeriodDropdown extends StatelessWidget {
  final List<String> timePeriods = [
    '7 days',
    '15 days',
    '1 month',
    '3 months',
    '6 months',
    '1 year',
  ];

  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  TimePeriodDropdown({Key? key, required this.selectedValue, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      hint: Text('e.g. 15 days or 1 month'),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),


        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorMixGrad),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),

      ),
      items: timePeriods.map((String timePeriod) {
        return DropdownMenuItem<String>(
          value: timePeriod,
          child: Text(timePeriod),
        );
      }).toList(),
    );
  }
}