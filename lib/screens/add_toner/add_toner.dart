import 'dart:io';

import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/supply_chian/supplychain.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../model/all_clients.dart';
import '../../model/machines_by_client_id.dart';
import '../../pref_manager.dart';
import '../../utils/popup_radio_checkbox.dart';
import '../../utils/scanner.dart';
import '../../utils/spnners.dart';
import 'utils.dart';

/*

 *************
-  Manage API calls on spinner value with loading.
-  Don't forget to capture the location of user.


*/

class AddSupply extends StatefulWidget {
  final String qrData;

  const AddSupply({super.key, this.qrData = ''});

  @override
  State<StatefulWidget> createState() => _AddSupplyState();
}

class _AddSupplyState extends State<AddSupply> {
  final ApiService _apiService = ApiService();
  DispatchReceive? _selectedDispatchReceive = DispatchReceive.dispatch;
  List<String> scannedCodes = [];
  String? selectedCityName;
  String? selectedTonerName;
  int receive_type = 0 ;
  String? selectedSerialNoId;
  String? selectedClientId;
  String? selectedSerialNo;
  String? selectedClientCity;
  late Future<List<Map<String, dynamic>>> clientsFuture;
  Map<String, dynamic>? _selectedClient;

  TextEditingController manualTonerCode = TextEditingController();
  TextEditingController controllerCityName = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  DateTime? _selectedDateTime = DateTime.now();
  bool hideDispatchFields = false;
  bool hideReceiveFields = false;

   late Future<List<Map<String, dynamic>>> machineFuture = Future.value([]) ;


  void _initializeHideDispatchFields() async {
    String? dispatchModuleValue = await PrefManager().getDispatchModule();
    String? receiveModuleValue = await PrefManager().getReceiveModule();
    setState(() {
      hideDispatchFields = dispatchModuleValue == "0";
      hideReceiveFields = receiveModuleValue == "0";
      if(hideDispatchFields){
        _selectedDispatchReceive = DispatchReceive.receive;
      }else{
        _selectedDispatchReceive = DispatchReceive.dispatch;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeHideDispatchFields();
    clientsFuture = getClientsList("only_active");
    scannedCodes = widget.qrData.isNotEmpty ? [widget.qrData] : [];
  }

  Future<List<Map<String, dynamic>>> getClientsList(String? filter) async {
    try {
      List<Map<String, dynamic>> clients = await _apiService.getAllClients(search:null,filter: 'only_active');
      // Debug print to check the fetched clients
      print('Fetched clients: $clients');
      return clients;
    } catch (e) {
      // Handle error
      print('Error fetching clients: $e');
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> getMachineList(String? clientId) async {
    try {
      List<Map<String, dynamic>> machines = await _apiService.getMachineByClientIdList(clientId.toString());
      // Debug print to check the fetched machines
      print('Fetched machines: $machines');
      return machines;
    } catch (e) {
      // Handle error
      print('Error fetching machines: $e');
      return [];
    }
  }





  Future<void> _scanQrCode() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _selectedDispatchReceive == DispatchReceive.dispatch
                ? const DualQRScannerTracesci()
                : const QRViewTracesci(),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        if (!scannedCodes.contains(result)) {
          scannedCodes.add(result);
        } else {
          showSnackBar(context, "Duplicate values are not allowed.");
        }
      });
    }
  }

  void addCodeManually(String result) {
    bool isValidFormat(String input) {
      final parts = input.split('-');
      return parts.length == 2 &&
          parts.every((part) => part.isNotEmpty) &&
          !input.startsWith('-') &&
          !input.endsWith('-') &&
          !input.contains('--');
    }

    if(_selectedDispatchReceive == DispatchReceive.dispatch){
      if(isValidFormat(result)){
        if (!scannedCodes.contains(result)) {
          setState(() {
            scannedCodes.add(result);
          });
        } else {
          showSnackBar(context, "Duplicate values are not allowed.");
        }
      }else{
        showSnackBar(context, "Please add QuarterID-TonerID both together.");
      }
    }else{
      if (!scannedCodes.contains(result)) {
        setState(() {
          scannedCodes.add(result);
        });
      } else {
        showSnackBar(context, "Duplicate values are not allowed.");
      }
    }

  }



  void validate() {
    if (_selectedDispatchReceive == DispatchReceive.dispatch) {

      if (selectedClientId == null) {
        showSnackBar(context, "Please select Serial no.");
        return;
      }

      if (selectedSerialNo == null) {
        showSnackBar(context, "Please select Serial no.");
        return;
      }
    }

    if (scannedCodes.isEmpty) {
      showSnackBar(context, "Please add Toner code");
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmSubmitDialog(
          onConfirm: () {
            submitToner(); // Call your submit function here
          },
        );
      },
    );
  }

  Future<void> submitToner() async {
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
      late final Map<String, dynamic> addUserResponse;

      // Determine whether to use phone or email for login
      String commaSeparatedString = scannedCodes.join(',');
      String supplyTypeValue; // Renamed variable to match the new column name

      // Map DispatchReceive enum to ENUM string values
      switch (_selectedDispatchReceive) {
        case DispatchReceive.dispatch:
          supplyTypeValue = '0';
          break;
        case DispatchReceive.receive:
          supplyTypeValue = '1';
          break;
        default:
          supplyTypeValue = '0'; // Fallback, though this shouldn't happen
      }
      addUserResponse = await apiService.addSupply(
          supply_type: supplyTypeValue,
          receive_type:receive_type,
          client_id: selectedClientId.toString(),
          serial_no: selectedSerialNo.toString(),
          date_time: _selectedDateTime.toString(),
          qr_code: commaSeparatedString,
          reference: referenceController.text);

      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Check if the login was successful based on the response structure
      if (addUserResponse.containsKey('error') &&
          addUserResponse.containsKey('status')) {
        if (!addUserResponse['error'] && addUserResponse['status'] == 200) {
          if (addUserResponse['message'] == 'Success') {
            if (addUserResponse['data']['message'] ==
                    'Supply created successfully.' ||
                addUserResponse['data']['message'] ==
                    'Supply updated successfully.') {
              Navigator.pop(context, true);
            } else {
              showSnackBar(context, addUserResponse['message']);
            }
          } else {
            showSnackBar(context, addUserResponse['message']);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Supply Chain",
          style: TextStyle(
            fontSize: 24.0,
            color: colorMixGrad,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Add Toner",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorMixGrad,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Hide the DispatchReceiveRadioButton if dispatchModule is "1"
              if (!hideDispatchFields && !hideReceiveFields)
                DispatchReceiveRadioButton(
                  onChanged: (DispatchReceive? value) {
                    setState(() {
                      _selectedDispatchReceive = value;
                      scannedCodes.clear();
                    });
                  },
                ),
              const SizedBox(height: 15),
              // Hide the entire Column if dispatchModule is "1"
              if (!hideDispatchFields && _selectedDispatchReceive == DispatchReceive.dispatch)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Client name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    MasterSpinner(
                      dataFuture: clientsFuture,
                      displayKey: 'name',
                      onChanged: (selectedItem) {
                        if (selectedItem != null) {
                          setState(() {
                            _selectedClient = selectedItem;
                            selectedClientId = selectedItem['id'].toString();
                            machineFuture = getMachineList(selectedClientId);
                          });
                        }
                        print('Selected client name: $selectedItem');
                      },
                      searchHint: 'Search client name...',
                      borderColor: colorMixGrad,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Serial no.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: machineFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          selectedSerialNo = null;
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          selectedSerialNo = null;
                          return Text('Error: ${snapshot.error}');
                        } else
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          selectedSerialNo = null;
                          return Text('No machines available');
                        } else {
                          return
                          MasterSpinner(
                            dataFuture: machineFuture,
                            displayKey: 'serial_no',
                            onChanged: (selectedItem) {
                              if (selectedItem != null) {
                                setState(() {
                                  selectedSerialNo = selectedItem['serial_no'].toString();
                                  print("Selected Serial No: $selectedSerialNo");
                                });
                              }
                              print('Selected Serial No:: $selectedSerialNo');
                            },
                            searchHint: 'Search Serial No:...',
                            borderColor: colorMixGrad,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              const SizedBox(height: 5),
              const Text(
                "Select DateTime",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              DateTimeInputField(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (dateTime) {
                  _selectedDateTime = dateTime;
                },
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: GradientButton(
                  gradientColors: const [colorFirstGrad, colorSecondGrad],
                  height: 45.0,
                  width: double.infinity,
                  radius: 25.0,
                  buttonText: "Scan code",
                  onPressed: _scanQrCode,
                ),
              ),
              const SizedBox(height: 15),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "or add code manually",
                      style: TextStyle(
                        fontSize: 16,
                        color: colorMixGrad,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ManualCodeField(
                controller: manualTonerCode,
                onAddPressed: addCodeManually,
              ),
              const SizedBox(height: 5),
              Text(
                _selectedDispatchReceive == DispatchReceive.dispatch
                    ? "Ex: QuarterID-TonerID"
                    : "Ex: TonerID",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Scanned QR Codes:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              ListView.builder(
                shrinkWrap: true,
                itemCount: scannedCodes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(scannedCodes[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      onPressed: () =>
                          setState(() {
                            scannedCodes.removeAt(index);
                          }),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Reference",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              ReferenceInputTextField(
                controller: referenceController,
              ),
              if(_selectedDispatchReceive == DispatchReceive.receive) const SizedBox(height: 15),
             if(_selectedDispatchReceive == DispatchReceive.receive) TonerStatusRadioButton(
                onChanged: (value) {
                  print('Selected index: ${value?.index}');
                  // 0 for emptyToner
                  // 1 for goodReturnedToner
                  // 2 for badReturnedToner

                  receive_type = value!.index;

                },
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 20),
                child: GradientButton(
                  gradientColors: const [colorFirstGrad, colorSecondGrad],
                  height: 45.0,
                  width: double.infinity,
                  radius: 25.0,
                  buttonText: "Submit",
                  onPressed: () {
                   validate();
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

}

