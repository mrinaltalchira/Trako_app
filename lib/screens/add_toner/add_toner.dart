import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:intl/intl.dart';
import 'package:Trako/model/supply_fields_data.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/supply_chian/supplychain.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  List<String> modelNos = [];
  List<String> clientCities = [];
  List<String> clientNames = [];
  List<SupplyClient> clients = [];
  String? selectedClientName;
  String? selectedCityName;
  String? selectedTonerName;

  TextEditingController manualTonerCode = TextEditingController();
  TextEditingController controllerCityName = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  DateTime? _selectedDateTime = DateTime.now();
  bool _isLoading = false;
  String? selectedClientId;

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
        modelNos = spinnerResponse.data.modelNo;
        clients = spinnerResponse.data.clients;
        clientNames = spinnerResponse.data.clientName;
        clientCities = spinnerResponse.data.clientCity;
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
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _selectedDispatchReceive == DispatchReceive.dispatch
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
    if (!scannedCodes.contains(result)) {
      setState(() {
        scannedCodes.add(result);
      });
    } else {
      showSnackBar(context, "Duplicate values are not allowed.");
    }
  }

  void validate() {
    if (_selectedDispatchReceive == DispatchReceive.dispatch) {
      if (selectedClientName == null) {
        showSnackBar(context, "Please select client name");
        return;
      }

      if (selectedCityName == null) {
        showSnackBar(context, "Please select client city");
        return;
      }

      if (selectedTonerName == null) {
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

      addUserResponse = await apiService.addSupply(
          dispatch_receive:
              _selectedDispatchReceive == DispatchReceive.dispatch ? '0' : '1',
          client_name: selectedClientName.toString(),
          client_city: selectedCityName.toString(),
          client_id: selectedClientId.toString(),
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
              _selectedDispatchReceive == DispatchReceive.dispatch
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const Text(
                            "Serial no.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          SerialNoSpinner(
                            selectedValue: selectedTonerName,
                            onChanged: (newValue) {
                              setState(() {
                                selectedTonerName = newValue;
                              });
                            },
                            modelList:
                            modelNos, // List<String> containing serial numbers
                          ),
                        const SizedBox(height: 5),
                        Text(
                          'Client Name: clientNames, City: clientCity',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                          const SizedBox(height: 15),

                        ])
                  :
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

class DualQRScannerTracesci extends StatefulWidget {
  const DualQRScannerTracesci({Key? key}) : super(key: key);

  @override
  _DualQRScannerTracesciState createState() => _DualQRScannerTracesciState();
}

class _DualQRScannerTracesciState extends State<DualQRScannerTracesci> {
  Barcode? firstResult;
  Barcode? secondResult;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool flashOn = false;
  bool isScanningSecondQR = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 50),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/ic_trako.png',
                  fit: BoxFit.contain,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context)),
              if (firstResult != null && !isScanningSecondQR)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'First QR code scanned successfully!',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isScanningSecondQR = true;
                          });
                        },
                        child: Text('Scan Second QR Code',style: TextStyle(color: colorMixGrad ),),
                      ),
                    ],
                  ),
                ),
              if (firstResult != null && secondResult != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _returnScannedData();
                    },
                    child: Text('Finish Scanning'),
                  ),
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {
                    flashOn = !flashOn;
                  });
                },
                child: Icon(flashOn ? Icons.flash_on : Icons.flash_off),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = _calculateScanArea(context);
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 200,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  EdgeInsets _calculateScanArea(BuildContext context) {
    double scanAreaSize = MediaQuery.of(context).size.shortestSide * 0.75;
    return EdgeInsets.all(
        (MediaQuery.of(context).size.shortestSide - scanAreaSize) / 2);
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (firstResult == null && !isScanningSecondQR) {
        setState(() {
          firstResult = scanData;
        });
      } else if (secondResult == null && isScanningSecondQR) {
        setState(() {
          secondResult = scanData;
        });
        _returnScannedData();
      }
    });
  }

  void _returnScannedData() {
    if (firstResult != null && secondResult != null) {
      String combinedResult =
          '${firstResult!.code}~${secondResult!.code}';
      Navigator.pop(context, combinedResult);
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No camera permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
