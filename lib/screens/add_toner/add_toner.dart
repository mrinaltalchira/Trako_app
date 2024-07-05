import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:intl/intl.dart';
import 'package:tonner_app/model/supply_fields_data.dart';
import 'package:tonner_app/network/ApiService.dart';
import 'package:tonner_app/screens/supply_chian/supplychain.dart';

import 'utils.dart';

/*

 *************
-  Manage API calls on spinner value with loading.
-  Don't forget to capture the location of user.


*/

class AddToner extends StatefulWidget {
  final String qrData;

  const AddToner({super.key, this.qrData = ''});

  @override
  State<StatefulWidget> createState() => _AddTonerState();
}

class _AddTonerState extends State<AddToner> {
  final ApiService _apiService = ApiService();
  DispatchReceive? _selectedDispatchReceive = DispatchReceive.dispatch;
  List<String> scannedCodes = [];
  List<String> clientNames = [];
  List<String> clientCities = [];
  List<String> modelNos = [];
  String? selectedClientName;
  String? selectedCityName;
  String? selectedTonerName;
  TextEditingController manualTonerCode = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  DateTime? _selectedDateTime = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSpinnerData();
    scannedCodes = widget.qrData.isNotEmpty ? [widget.qrData] : [];
  }

  Future<void> fetchSpinnerData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      SupplySpinnerResponse spinnerResponse =
          await _apiService.getSpinnerDetails();
      setState(() {
        clientNames = spinnerResponse.data.clientNames;
        clientCities = spinnerResponse.data.clientCities;
        modelNos = spinnerResponse.data.modelNos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching supply spinner details: $e');
      setState(() {
        _isLoading = false;
      });
      // Handle error as needed
    }
  }

  Future<void> _scanQrCode() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const QRViewTracesci(),
    ));

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
    if (!scannedCodes.contains(result)) {
      setState(() {
        scannedCodes.add(result);
      });
    } else {
      showSnackBar(context, "Duplicate values are not allowed.");
    }
  }
  Future<void> submitToner() async {
    if (selectedClientName == null) {
      showSnackBar(context, "Please select client name");
      return;
    }

    if (selectedCityName == null) {
      showSnackBar(context, "Please select client city");
      return;
    }

    if (selectedTonerName == null) {
      showSnackBar(context, "Please select Model no.");
      return;
    }

    if (scannedCodes.isEmpty) {
      showSnackBar(context, "Please add Toner code");
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
      late final Map<String, dynamic> addUserResponse;

      // Determine whether to use phone or email for login
      String commaSeparatedString = scannedCodes.join(', ');

      addUserResponse = await apiService.addSupply(
          dispatch_receive:
              _selectedDispatchReceive == DispatchReceive.dispatch ? '0' : '1',
          client_name: selectedClientName.toString(),
          client_city: selectedCityName.toString(),
          model_no: selectedTonerName.toString(),
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
            showSnackBar(context, addUserResponse['data']['message']);
            if (addUserResponse['data']['message'] ==
                    'Supply created successfully' ||
                addUserResponse['data']['message'] ==
                    'Supply updated successfully') {
              Navigator.pop(context);
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

  void _removeScannedCode(String code) {
    setState(() {
      scannedCodes.remove(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Supply chian",
          style: TextStyle(
            fontSize: 24.0,
            color: colorMixGrad, // Replace with your colorSecondGrad
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
              DispatchReceiveRadioButton(
                onChanged: (DispatchReceive? value) {
                  setState(() {
                    _selectedDispatchReceive = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text(
                "Client Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              ClientNameSpinner(
                selectedValue: selectedClientName,
                onChanged: (newValue) {
                  setState(() {
                    selectedClientName = newValue;
                  });
                },
                clientNames: clientNames, // Pass the fetched client names
              ),
              const SizedBox(height: 15),
              const Text(
                "City Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              CityNameSpinner(
                selectedValue: selectedCityName,
                onChanged: (newValue) {
                  setState(() {
                    selectedCityName = newValue;
                  });
                },
                clientCity: clientCities,
              ),
              const SizedBox(height: 15),
              const Text(
                "Model no.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              ModelNoSpinner(
                selectedValue: selectedTonerName,
                onChanged: (newValue) {
                  setState(() {
                    selectedTonerName = newValue;
                  });
                },
                modelLsit: modelNos,
              ),
              const SizedBox(height: 15),
              const Text(
                "Selected DateTime",
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
                    onPressed: _scanQrCode),
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
                      onPressed: () => _removeScannedCode(scannedCodes[index]),
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
              const SizedBox(height: 15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: GradientButton(
                  gradientColors: const [colorFirstGrad, colorSecondGrad],
                  height: 45.0,
                  width: double.infinity,
                  radius: 25.0,
                  buttonText: "Submit",
                  onPressed: () {
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
