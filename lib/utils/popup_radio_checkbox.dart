import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Trako/color/colors.dart';

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


class TonerStatusRadioButton extends StatefulWidget {
  final ValueChanged<TonerStatus?> onChanged;

  const TonerStatusRadioButton({Key? key, required this.onChanged})
      : super(key: key);

  @override
  _TonerStatusRadioButtonState createState() => _TonerStatusRadioButtonState();
}

enum TonerStatus {
  emptyToner,
  goodReturnedToner,
  badReturnedToner,
}

class _TonerStatusRadioButtonState extends State<TonerStatusRadioButton> {
  TonerStatus? _selectedStatus = TonerStatus.emptyToner;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Toner Status:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          children: [
            RadioListTile<TonerStatus>(
              title: const Text('Empty Toner'),
              value: TonerStatus.emptyToner,
              groupValue: _selectedStatus,
              activeColor: colorMixGrad,
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              onChanged: (TonerStatus? value) {
                setState(() {
                  _selectedStatus = value;
                });
                widget.onChanged(value);
              },
            ),
            RadioListTile<TonerStatus>(
              title: const Text('Good Returned Toner'),
              value: TonerStatus.goodReturnedToner,
              groupValue: _selectedStatus,
              activeColor: colorMixGrad,
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              onChanged: (TonerStatus? value) {
                setState(() {
                  _selectedStatus = value;
                });
                widget.onChanged(value);
              },
            ),
            RadioListTile<TonerStatus>(
              title: const Text('Bad Returned Toner'),
              value: TonerStatus.badReturnedToner,
              groupValue: _selectedStatus,
              activeColor: colorMixGrad,
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              onChanged: (TonerStatus? value) {
                setState(() {
                  _selectedStatus = value;
                });
                widget.onChanged(value);
              },
            ),
          ],
        ),
      ],
    );
  }
}
