import 'package:Trako/screens/toner_request/add_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/model/all_machine.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/home/home.dart';
import 'package:flutter/services.dart';
import '../../model/supply_fields_data.dart';
import '../../utils/popup_radio_checkbox.dart';
import '../../utils/spnners.dart';
import '../add_toner/utils.dart';



class AddMachine extends StatefulWidget {
  final Map<String, dynamic>? machine;
  const AddMachine({super.key, this.machine});

  @override
  State<AddMachine> createState() => _AddMachineState();
}

class _AddMachineState extends State<AddMachine> {
  final TextEditingController machine_name_Controller = TextEditingController();
  final TextEditingController machine_code_Controller = TextEditingController();
  late Future<List<Map<String, dynamic>>> machineFuture;
  final ApiService _apiService = ApiService();
  List<SupplyClient> clients = [];
  bool activeChecked = true;
  Map<String, dynamic>? selectedMachine;

  Future<List<Map<String, dynamic>>> getMachineList({String? search,String? filter}) async {
    try {
      Map<String, dynamic> response = await _apiService.getAllModels(
        search: search,
        filter: filter,
        page: 1,
        perPage: 20,
      );

      print('Full API Response: $response');

      if (response['error'] == false &&
          response['data'] != null &&
          response['data']['machines'] != null) {
        List<dynamic> machinesJson = response['data']['machines'];
        print('Extracted machines: $machinesJson');
        if (machinesJson.isEmpty) {
          print('Warning: No machines returned from API');
        }
        return List<Map<String, dynamic>>.from(machinesJson);
      } else {
        print('No machines found in response');
        return [];
      }
    } catch (e) {
      print('Error fetching machines: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    machineFuture = getMachineList(filter: "only_active");
    if (widget.machine != null) {
      machine_name_Controller.text = widget.machine!['model_no'] ?? '';
      machine_code_Controller.text = widget.machine!['serial_no'] ?? '';
      activeChecked = widget.machine!['isActive']  == "1";
    }
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
                  widget.machine != null ? "Update Machine:" : "Add New Machine:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorMixGrad,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 5),
              const SizedBox(height: 35),
              MasterSpinner(
                dataFuture: machineFuture,
                displayKey: 'model_no',
                onChanged: (selectedItem) {
                  setState(() {
                    selectedMachine = selectedItem;
                    if (selectedItem != null) {
                      machine_name_Controller.text = selectedItem['model_no'] ?? '';
                    }
                  });
                  print('Selected machine: $selectedItem');
                },
                searchHint: 'Search model number...',
                borderColor: colorMixGrad,
              ),
              const SizedBox(height: 15),
              Text(
                "Model Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: machineFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'No active machine models available',
                          style: TextStyle(
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    }
                  }
                  return SizedBox.shrink();
                },
              ),
              const SizedBox(height: 10),
              // Changed from CustomTextField to a non-editable display field
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Text(
                  machine_name_Controller.text.isEmpty ? 'Selected Model no.' : machine_name_Controller.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: machine_name_Controller.text.isEmpty ? Colors.grey[600] : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Serial no.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              CustomTextField(
                controller: machine_code_Controller,
                hintText: 'Serial no.',
              ),
              const SizedBox(height: 20),
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
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 50),
                  child: GradientButton(
                    gradientColors: const [colorFirstGrad, colorSecondGrad],
                    height: 45.0,
                    width: 10.0,
                    radius: 25.0,
                    buttonText: "Submit",
                    onPressed: validateAndSignIn,
                  ),
                ),
              ),
              const SizedBox(height: 100),
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

    if (widget.machine != null) {
      try {
        final addMachineResponse = await _apiService.updateMachine(
          id: widget.machine!['id'].toString(),
          model_name: machine_name_Controller.text,
          serial_no: machine_code_Controller.text,
          isActive: activeChecked ? '1' : '0',
        );

        Navigator.of(context).pop(); // Dismiss loading indicator

        if (addMachineResponse.containsKey('error') &&
            addMachineResponse.containsKey('status')) {
          if (!addMachineResponse['error'] &&
              addMachineResponse['status'] == 200) {
            if (addMachineResponse['message'] == 'Machine updated successfully') {
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
        print("Update Machine API Error: $e");
      }
    } else {
      try {
        final addMachineResponse = await _apiService.addMachine(
          model_name: selectedMachine!['id'].toString() ,
          serial_no: machine_code_Controller.text,
          isActive: activeChecked ? '1' : '0',
        );

        Navigator.of(context).pop(); // Dismiss loading indicator

        if (addMachineResponse.containsKey('error') &&
            addMachineResponse.containsKey('status')) {
          if (!addMachineResponse['error'] &&
              addMachineResponse['status'] == 200) {
            if (addMachineResponse['message'] == 'Success') {
              machine_name_Controller.clear();
              machine_code_Controller.clear();
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
}