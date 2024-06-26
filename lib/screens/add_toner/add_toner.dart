import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:intl/intl.dart';
import 'package:tonner_app/screens/supply_chian/supplychain.dart';






// Don't forget to capture the location of user.







class AddToner extends StatefulWidget {
  final String qrData;

  const AddToner({super.key, this.qrData = ''});

  @override
  State<StatefulWidget> createState() => _AddTonerState();
}

class _AddTonerState extends State<AddToner> {
  List<String> scannedQrCodes= [];
  String? selectedClientName;
  String? selectedCityName;
  String? selectedTonerName;

  @override
  void initState() {
    super.initState();
    scannedQrCodes = widget.qrData.isNotEmpty ? [widget.qrData] : [];

  }
  Future<void> _scanQrCode() async {

    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const QRViewTracesci(),
    ));

    if (result != null && result is String) {
      setState(() {
        scannedQrCodes.add(result);
      });
    }
  }

  void _removeScannedCode(String code) {
    setState(() {
      scannedQrCodes.remove(code);
    });
  }

  @override
  Widget build(BuildContext context){
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
              const DispatchReceiveRadioButton(),
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
              TonerNameSpinner(
                selectedValue: selectedTonerName,
                onChanged: (newValue) {
                  setState(() {
                    selectedTonerName = newValue;
                  });
                },
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
                  print('Selected DateTime: $dateTime');
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _scanQrCode,
                child: const Text("Add Toner"),
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
                itemCount: scannedQrCodes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(scannedQrCodes[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      onPressed: () => _removeScannedCode(scannedQrCodes[index]),
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
              ReferenceInputTextField(),

              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: GradientButton(
                  gradientColors: const [colorFirstGrad, colorSecondGrad],
                  height: 45.0,
                  width: double.infinity,
                  radius: 25.0,
                  buttonText: "Submit",
                  onPressed: () {
                    showSnackBar(context, "Submitted");
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


class ReferenceInputTextField extends StatefulWidget {
  const ReferenceInputTextField({Key? key}) : super(key: key);

  @override
  _ReferenceInputTextField createState() => _ReferenceInputTextField();
}

class _ReferenceInputTextField extends State<ReferenceInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,

      decoration: InputDecoration(
        hintText: 'Reference (optional)',

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

class DispatchReceiveRadioButton extends StatefulWidget {
  const DispatchReceiveRadioButton({Key? key}) : super(key: key);

  @override
  _DispatchReceiveRadioButtonState createState() =>
      _DispatchReceiveRadioButtonState();
}

enum DispatchReceive { dispatch, receive }

class _DispatchReceiveRadioButtonState
    extends State<DispatchReceiveRadioButton> {
  DispatchReceive? _selectedOption = DispatchReceive.dispatch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select an option:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<DispatchReceive>(
                title: const Text('Dispatch'),
                value: DispatchReceive.dispatch,
                groupValue: _selectedOption,
                activeColor: colorMixGrad,
                onChanged: (DispatchReceive? value) {
                  setState(() {
                    _selectedOption = value;

                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<DispatchReceive>(
                title: const Text('Receive'),
                value: DispatchReceive.receive,
                groupValue: _selectedOption,
                activeColor: colorMixGrad,
                onChanged: (DispatchReceive? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ClientNameSpinner extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const ClientNameSpinner({
    required this.selectedValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: const Text('Select an option'),
      items: ['Jams Karter', 'Peter Parker', 'Ken Tino', 'Will Smith']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: colorMixGrad),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class CityNameSpinner extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CityNameSpinner({
    required this.selectedValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: const Text('Select an option'),
      items: ['Gurugram', 'Mumbai', 'Jaipur', 'Delhi'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: colorMixGrad),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class TonerNameSpinner extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const TonerNameSpinner({
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tonerNames = ['fvbdk9df6dxc46cxv', 'fvbdak9df6xdc46cxv', 'fvbdk9cdf6dxc46cxv', 'fvbdk9df6xc546cxv'];

    // Log the toner names for debugging


    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: const Text('Select an option'),
      items: tonerNames.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: colorMixGrad), // Adjust color as needed
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class DateTimeInputField extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  const DateTimeInputField({
    required this.initialDateTime,
    required this.onDateTimeChanged,
    Key? key,
  }) : super(key: key);

  @override
  _DateTimeInputFieldState createState() => _DateTimeInputFieldState();
}

class _DateTimeInputFieldState extends State<DateTimeInputField> {
  late DateTime selectedDateTime;
  late TextEditingController _controller;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd | HH:mm');

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
    _controller = TextEditingController(
      text: _dateFormat.format(selectedDateTime),
    );
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _controller.text = _dateFormat.format(selectedDateTime);
          widget.onDateTimeChanged(selectedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      onTap: _pickDateTime,
      decoration: InputDecoration(
        hintText: 'Select Date and Time',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue), // Change color as needed
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}
