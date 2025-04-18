import 'package:flutter/material.dart';

import '../../color/colors.dart';
import '../../globals.dart';
import '../../model/supply_fields_data.dart';
import '../../network/ApiService.dart';
import '../../utils/popup_radio_checkbox.dart';
import '../../utils/scanner.dart';
import '../add_toner/utils.dart';
import '../supply_chian/supplychain.dart';

class AddAcknowledgement extends StatefulWidget {
  final String qrData;

  const AddAcknowledgement({super.key, this.qrData = ''});

  @override
  State<StatefulWidget> createState() => _AddAcknowledgementState();
}

class _AddAcknowledgementState extends State<AddAcknowledgement> {
  final ApiService _apiService = ApiService();
  List<String> scannedCodes = [];
  String? selectedClientName;
  String? selectedCityName;
  String? selectedTonerName;

  TextEditingController manualTonerCode = TextEditingController();
  TextEditingController controllerCityName = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  DateTime? _selectedDateTime = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching supply spinner details: $e');
      setState(() {
        _isLoading = false;
      });
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

  void validate() {
    if (scannedCodes.isEmpty) {
      showSnackBar(context, "Please add Toner code");
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmSubmitDialog(
          onConfirm: () {
            submitAcknowledgement(); // Call your submit function here
          },
        );
      },
    );
  }

  Future<void> submitAcknowledgement() async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final ApiService apiService = ApiService();
      late final Map<String, dynamic> addAckResponse;

      // Convert the scanned codes list into a comma-separated string
      String commaSeparatedString = scannedCodes.join(',');

      // Call the API to add the acknowledgment.dart
      addAckResponse = await apiService.addAcknowledgement(
        date_time: _selectedDateTime.toString(),
        qr_code: commaSeparatedString,
        reference: referenceController.text.isNotEmpty ? referenceController.text : "",

      );


      // Check if the response contains the required keys
      if (addAckResponse.containsKey('error') && addAckResponse.containsKey('status')) {
        if (!addAckResponse['error'] && addAckResponse['status'] == 200) {

          if (addAckResponse['message'] == 'Success') {
            // Check if the acknowledgment.dart was added successfully
            if (addAckResponse['data']['message'] == 'Acknowledgement added successfully.') {
              // Close the loading dialog and navigate back with a success result
              Navigator.pop(context, true);

            } else {
              // Show the specific message from the API response if not successful
              showSnackBar(context, addAckResponse['data']['message']);
            }
          } else {
            // If the message is not "Success", stay on the page and show the message
            showSnackBar(context, addAckResponse['data']['message']);
          }
        } else {
          // Handle cases where the API returns a different status
          showSnackBar(context, addAckResponse['data']['message'] ?? "Submission failed. Please try again.");
        }
      } else {
        // Handle unexpected responses
        showSnackBar(context, "Unexpected response from server. Please try again later.");
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      showSnackBar(context, "Failed to connect to the server. Please try again later.");
      print("API Error: $e");
    } finally {
      // Close the loading dialog if it's still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
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
          "Acknowledgement",
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
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Add Acceptance",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorMixGrad,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
