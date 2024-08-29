import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../color/colors.dart'; // Adjust the import as needed

class RequestToner extends StatefulWidget {
  const RequestToner({super.key});

  @override
  State<RequestToner> createState() => _RequestTonerState();
}

class _RequestTonerState extends State<RequestToner> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String? _selectedMachineModel;
  String? _selectedColor;

  final List<String> _modelOptions = ['Model A', 'Model B', 'Model C']; // Update with your models
  final List<String> _colorOptions = ['Magenta', 'Black', 'Yellow', 'White', 'Clear'];

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Confirm Order', style: TextStyle(color: colorMixGrad, fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to place this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the action to mail the order here
                Navigator.of(context).pop();
              },
              child: Text('Mail My Order', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorMixGrad,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Toner',
          style: TextStyle(
            fontSize: 24.0,
            color: colorMixGrad,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructional Line and Text
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please fill out the form below to request a toner. Make sure all details are accurate before submitting.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Divider(
                      color: colorMixGrad,
                      thickness: 2.0,
                      height: 30.0,
                    ),
                  ],
                ),
              ),

              // Machine Model No
              _buildSectionTitle('Select Machine Model No'),
              ModelNoSpinner(
                selectedValue: _selectedMachineModel,
                onChanged: (value) => setState(() => _selectedMachineModel = value),
                modelLsit: _modelOptions,
              ),
              SizedBox(height: 24.0),

              // Color Selection
              _buildSectionTitle('Select Color'),
              ColorSpinner(
                selectedValue: _selectedColor,
                onChanged: (value) => setState(() => _selectedColor = value),
                colorList: _colorOptions,
              ),
              SizedBox(height: 24.0),

              // Toner Quantity
              _buildSectionTitle('Toner Quantity'),
              CustomTextField(
                controller: _quantityController,
                hintText: 'Enter quantity',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24.0),

              // Additional Details
              _buildSectionTitle('Additional Details'),
              CustomTextField(
                controller: _detailsController,
                hintText: 'Enter additional details',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              SizedBox(height: 32.0),

              // Place Order Button
              _buildOrderButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorMixGrad,
        ),
      ),
    );
  }

  Widget _buildOrderButton() {
    return ElevatedButton(

      onPressed: _showConfirmationDialog,
      child: Text(
        "Place Order",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: colorMixGrad,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 2,
      ),
    );
  }
}
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._ -]')), // Allow common characters
      ],
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(value),
          ),
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

class ColorSpinner extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final List<String> colorList;

  const ColorSpinner({
    required this.selectedValue,
    required this.onChanged,
    Key? key,
    required this.colorList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: const Text('Select a color'),
      items: colorList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(value),
          ),
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
