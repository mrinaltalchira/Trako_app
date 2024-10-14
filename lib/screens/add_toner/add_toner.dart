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
  String? selectedCityName;
  String? selectedTonerName;

  String? selectedSerialNoId;
  String? selectedClientId;
  String? selectedSerialNo;
  String? selectedClientCity;
  late Future<List<Client>> clientsFuture;
  Client? _selectedClient;

  TextEditingController manualTonerCode = TextEditingController();
  TextEditingController controllerCityName = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  DateTime? _selectedDateTime = DateTime.now();
  bool hideDispatchFields = false;

   late Future<List<MachineByClientId>> machineFuture = Future.value([]) ;


  void _initializeHideDispatchFields() async {
    String? dispatchModuleValue = await PrefManager().getDispatchModule();
    setState(() {
      hideDispatchFields = dispatchModuleValue == "1";
      if(hideDispatchFields){
        _selectedDispatchReceive = DispatchReceive.receive;
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

  Future<List<Client>> getClientsList(String? filter) async {
    try {
      List<Client> clients = await _apiService.getAllClients(search:null,filter: 'only_active');
      // Debug print to check the fetched clients
      print('Fetched clients: $clients');
      return clients;
    } catch (e) {
      // Handle error
      print('Error fetching clients: $e');
      return [];
    }
  }


  Future<List<MachineByClientId>> getMachineList(String clientId) async {
    try {
      List<MachineByClientId> machines = await _apiService.getMachineByClientIdList(clientId);
      // Debug print to check the fetched machines
      print('Fetched machines: $machines');
      return machines;
    } catch (e) {
      // Handle error
      print('Error fetching machines: $e');
      return [];
    }
  }


  void _onClientChanged(Client? client) {
    if (client != null) {
      setState(() {
        _selectedClient = client;
        selectedClientId = client.id.toString();
        machineFuture = getMachineList(client.id.toString());
      });
    }
  }


/*  Future<List<Machine>> getMachineList(String? search) async {
    try {
      List<Machine> machines = await _apiService.getAllMachines(search);
      // Debug print to check the fetched machines
      print('Fetched machines: $machines');
      return machines;
    } catch (e) {
      // Handle error
      print('Error fetching machines: $e');
      return [];
    }
  }*/

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

      addUserResponse = await apiService.addSupply(
          dispatch_receive: _selectedDispatchReceive == DispatchReceive.dispatch ? '0' : '1',
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
              if (!hideDispatchFields)
                DispatchReceiveRadioButton(
                  onChanged: (DispatchReceive? value) {
                    setState(() {
                      _selectedDispatchReceive = value;
                    });
                  },
                ),
              const SizedBox(height: 15),
              // Hide the entire Column if dispatchModule is "1"
              if (!hideDispatchFields &&
                  _selectedDispatchReceive == DispatchReceive.dispatch)
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
                    ClientNameSpinner(
                      fetchClients: getClientsList,
                      onChanged: _onClientChanged,
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
                    FutureBuilder<List<MachineByClientId>>(
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
                          return MachineByClientIdSpinner(
                            onChanged: (String? newSerialNo) {
                              setState(() {
                                selectedSerialNo = newSerialNo.toString();
                                print("Selected Serial No: $newSerialNo");
                              });
                            },
                            machinesFuture: Future.value(snapshot.data!),
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
/*
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
                          "Client name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                          ClientNameSpinner(
                            fetchClients: getClientsList,
                            onChanged: _onClientChanged,
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
                        FutureBuilder<List<MachineByClientId>>(
                          future: machineFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              selectedSerialNo = null;
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              selectedSerialNo = null;
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              selectedSerialNo = null;
                              return Text('No machines available');
                            } else {
                              return MachineByClientIdSpinner(
                                onChanged: (String? newSerialNo) {
                                  setState(() {
                                    selectedSerialNo = newSerialNo.toString();
                                    print("Selected Serial No: $newSerialNo");
                                  });
                                },
                                machinesFuture: Future.value(snapshot.data!), // Pass the list of machines as a Future
                              );
                            }
                          },
                        ),
                          const SizedBox(height: 15),
                        ])
                  : const SizedBox(height: 5),
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
  }*/
}



class DualQRScannerTracesci extends StatefulWidget {
  const DualQRScannerTracesci({Key? key}) : super(key: key);

  @override
  _DualQRScannerTracesciState createState() => _DualQRScannerTracesciState();
}

class _DualQRScannerTracesciState extends State<DualQRScannerTracesci> {
  String? firstResult;
  String? secondResult;
  bool flashOn = false;
  bool isScanningSecondQR = false;
  MobileScannerController cameraController = MobileScannerController();

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
              Expanded(
                flex: 4,
                child: MobileScanner(
                  controller: cameraController,
                  onDetect: (BarcodeCapture barcodeCapture) {
                    final List<Barcode> barcodes = barcodeCapture.barcodes;
                    if (barcodes.isNotEmpty) {
                      if (firstResult == null && !isScanningSecondQR) {
                        setState(() {
                          firstResult = barcodes.first.rawValue;
                        });
                      } else if (secondResult == null && isScanningSecondQR) {
                        setState(() {
                          secondResult = barcodes.first.rawValue;
                        });
                        _returnScannedData();
                      }
                    }
                  },
                ),
              ),
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
                        child: Text(
                          'Scan Second QR Code',
                          style: TextStyle(color: Colors.blue), // Replace with your color
                        ),
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
                  await cameraController.toggleTorch();
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

  void _returnScannedData() {
    if (firstResult != null && secondResult != null) {
      String combinedResult = '$firstResult-$secondResult';
      Navigator.pop(context, combinedResult);
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
