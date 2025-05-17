import 'dart:convert';

import 'package:Trako/screens/toner_request/add_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:flutter/services.dart';
import '../../model/supply_fields_data.dart';
import '../../utils/popup_radio_checkbox.dart';

class AddModel extends StatefulWidget {
  final Map<String, dynamic>? machineData;
  const AddModel({super.key, this.machineData});

  @override
  State<AddModel> createState() => _AddModelState();
}

class _AddModelState extends State<AddModel> {
  final TextEditingController machine_name_Controller = TextEditingController();
  final List<TextEditingController> colorControllers = [TextEditingController()];

  List<SupplyClient> clients = [];
  bool activeChecked = true;

  // In _AddModelState class, update the initState method:

  @override
  void initState() {
    super.initState();

    if (widget.machineData != null) {
      machine_name_Controller.text = widget.machineData!['model_no'] ?? '';

      // Initialize colors if the machine has them
      if (widget.machineData!['color_name'] != null) {
        // Clear the initial controller
        colorControllers.clear();

        // Parse colors safely
        List<String> colorsList = [];
        dynamic colorNamesInput = widget.machineData!['color_name'];

        try {
          // If it's already a List (from JSON)
          if (colorNamesInput is List) {
            colorsList = colorNamesInput.map((item) => item.toString()).toList();
          }
          // If it's a String (JSON string)
          else if (colorNamesInput is String && colorNamesInput.isNotEmpty) {
            List<dynamic> parsed = jsonDecode(colorNamesInput);
            colorsList = parsed.map((item) => item.toString()).toList();
          }
        } catch (e) {
          print('Error parsing color names in initState: $e');
        }

        // Add controllers for each color
        if (colorsList.isNotEmpty) {
          for (var color in colorsList) {
            colorControllers.add(TextEditingController(text: color.trim()));
          }
        } else {
          // Keep at least one empty controller
          colorControllers.add(TextEditingController());
        }
      }

      // Convert isActive to boolean if it's not already
      if (widget.machineData!['isActive'] is int) {
        activeChecked = widget.machineData!['isActive'] == 1;
      } else if (widget.machineData!['isActive'] is bool) {
        activeChecked = !widget.machineData!['isActive'];
      }
    }
  }

  @override
  void dispose() {
    machine_name_Controller.dispose();
    for (var controller in colorControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Method to add a new color field
  void addColorField() {
    // Check if the last color field is not empty
    if (colorControllers.last.text.isNotEmpty) {
      setState(() {
        colorControllers.add(TextEditingController());
      });
    } else {
      showSnackBar(context, "Please fill the current color field before adding a new one.");
    }
  }

  // Method to remove a color field
  void removeColorField(int index) {
    if (colorControllers.length > 1) {
      setState(() {
        TextEditingController controller = colorControllers.removeAt(index);
        controller.dispose();
      });
    }
  }

  // Get all colors as a list of strings
  List<String> getColorsList() {
    return colorControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => controller.text.trim())
        .toList();
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
              const SizedBox(height: 20),
              Center(
                child: Text(
                  widget.machineData != null ? "Update Model:" : "Add New Model:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorMixGrad,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Text(
                "Model Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              CustomTextField(controller: machine_name_Controller, hintText: 'Model No.',),
              const SizedBox(height: 20),
              Text(
                "Colors",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),

              // Dynamic list of color fields
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: colorControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: colorControllers[index],
                            hintText: 'Enter color',
                          ),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeColorField(index),
                          ),
                      ],
                    ),
                  );
                },
              ),

              // Add new color button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: Icon(Icons.add, color: colorMixGrad),
                  label: Text(
                    "Add Color",
                    style: TextStyle(color: colorMixGrad),
                  ),
                  onPressed: addColorField,
                ),
              ),

              SizedBox(height: 10),

              // Active/Inactive toggle
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

              // Submit button
              SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 50),
                    child: GradientButton(
                      gradientColors: const [colorFirstGrad, colorSecondGrad],
                      height: 45.0,
                      width: 10.0,
                      radius: 25.0,
                      buttonText: "Submit",
                      onPressed: validateAndSignIn,
                    ),
                  )
              ),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> validateAndSignIn() async {
    if (machine_name_Controller.text.isEmpty) {
      showSnackBar(context, "Model Name is required.");
      return;
    }

    // Check if at least one color is entered
    bool hasValidColor = false;
    for (var controller in colorControllers) {
      if (controller.text.isNotEmpty) {
        hasValidColor = true;
        break;
      }
    }

    if (!hasValidColor) {
      showSnackBar(context, "At least one color is required.");
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

    // Get the list of colors
    List<String> colorsList = getColorsList();

    try {
      final ApiService apiService = ApiService();

      final addMachineResponse = await apiService.addMachineModel(
        id:widget.machineData != null ? widget.machineData!['id'].toString(): null,
        model_no: machine_name_Controller.text,
        colors: colorsList,
        isActive: activeChecked, // Invert value to match backend expectation (activeChecked means inactive in UI)
      );

      Navigator.of(context).pop(); // Dismiss loading indicator

      if (addMachineResponse.containsKey('error') &&
          addMachineResponse.containsKey('status')) {
        if (!addMachineResponse['error'] &&
            addMachineResponse['status'] == 200) {
          if (addMachineResponse['message'] == 'Success') {
            machine_name_Controller.clear();
            for (var controller in colorControllers) {
              controller.clear();
            }
            // Keep only one empty color controller
            while (colorControllers.length > 1) {
              TextEditingController controller = colorControllers.removeLast();
              controller.dispose();
            }
            Navigator.pop(context, true);
          } else {
            showSnackBar(context, addMachineResponse['message']);
          }
        } else {
          showSnackBar(context, addMachineResponse['message']);
        }
      } else {
        showSnackBar(context, "Unexpected response from server. Please try again later.");
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss loading indicator
      showSnackBar(context, "Failed to connect to the server. Please try again later.");
      print("Add Machine API Error: $e");
    }
  }
}