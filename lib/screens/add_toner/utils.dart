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

class ManualCodeField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onAddPressed;

  const ManualCodeField(
      {super.key, required this.controller, required this.onAddPressed});

  @override
  _ManualCodeFieldState createState() => _ManualCodeFieldState();
}

class _ManualCodeFieldState extends State<ManualCodeField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            keyboardType: TextInputType.text,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: 'Enter code manually',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: colorMixGrad),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 16.0),
        SizedBox(
          width: 80,
          child: GradientButton(
              gradientColors: const [colorFirstGrad, colorSecondGrad],
              height: 45.0,
              width: double.infinity,
              radius: 25.0,
              buttonText: "Add",
              onPressed: () {
                String enteredCode = widget.controller.text.trim();
                if (enteredCode.isNotEmpty) {
                  widget.controller.clear(); // Clear the text field
                  widget.onAddPressed(enteredCode); // Call parent callback
                }
              }),
        ),
      ],
    );
  }
}

class ReferenceInputTextField extends StatefulWidget {
  final TextEditingController controller;

  ReferenceInputTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _ReferenceInputTextField createState() => _ReferenceInputTextField();
}

class _ReferenceInputTextField extends State<ReferenceInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Reference (optional)',

        // Changed hintText to 'Email'
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              const BorderSide(color: colorMixGrad), // Border color when focused
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

class DispatchReceiveRadioButton extends StatefulWidget {
  final ValueChanged<DispatchReceive?> onChanged;

  const DispatchReceiveRadioButton({Key? key, required this.onChanged})
      : super(key: key);

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
                  widget.onChanged(value);
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
                  widget.onChanged(value);
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
  final List<String> clientNames;

  const ClientNameSpinner({
    required this.selectedValue,
    required this.onChanged,
    required this.clientNames,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: const Text('Select an option'),
      items: clientNames.map((String value) {
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
  final List<String> clientCity;

  const CityNameSpinner({
    required this.selectedValue,
    required this.onChanged,
    required this.clientCity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: const Text('Select an option'),
      items: clientCity.map((String value) {
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class ModelNoSpinner extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final List<String> modelLsit;

  const ModelNoSpinner({
    required this.selectedValue,
    required this.onChanged,
    Key? key,
    required this.modelLsit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: const Text('Select an option'),
      items: modelLsit.map((String value) {
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
          borderSide:
              const BorderSide(color: colorMixGrad), // Adjust color as needed
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
          borderSide:
              const BorderSide(color: colorMixGrad), // Change color as needed
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class ConfirmSubmitDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmSubmitDialog({Key? key, required this.onConfirm})
      : super(key: key);

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
                color: colorMixGrad, // Use colorMixGrad as the primary color
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
          SizedBox(height: 14.0),
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
                  // Use colorMixGrad as the primary color
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
