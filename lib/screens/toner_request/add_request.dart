import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../color/colors.dart';
import '../../globals.dart'; // Adjust the import as needed

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

  final List<String> _modelOptions = ['Model A', 'Model B', 'Model C'];
  final List<String> _colorOptions = ['Magenta', 'Black', 'Yellow', 'White', 'Clear'];

  List<TonerRequest> _cart = [];

  void _addToCart() {
    if (_selectedMachineModel != null && _selectedColor != null && _quantityController.text.isNotEmpty) {
      final tonerRequest = TonerRequest(
        machineModel: _selectedMachineModel!,
        color: _selectedColor!,
        quantity: int.parse(_quantityController.text),
        details: _detailsController.text,
      );

      setState(() {
        _cart.add(tonerRequest);
        _quantityController.clear();
        _detailsController.clear();
        _selectedMachineModel = null;
        _selectedColor = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Toner added to cart')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  void _viewCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: colorMixGrad,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              'Your Cart',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _cart.isEmpty
                              ? Center(
                            child: Text(
                              'Your cart is empty',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          )
                              : ListView.separated(
                            controller: controller,
                            padding: EdgeInsets.all(16),
                            itemCount: _cart.length,
                            separatorBuilder: (context, index) => Divider(height: 1),
                            itemBuilder: (context, index) {
                              var request = _cart[index];
                              return Dismissible(
                                key: Key(request.hashCode.toString()),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) {
                                  setModalState(() {
                                    _cart.removeAt(index);
                                  });
                                  setState(() {});
                                  showSnackBar(context, 'Item removed from cart');
                                },
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  title: Text(
                                    '${request.machineModel} - ${request.color}',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    'Quantity: ${request.quantity}\nDetails: ${request.details}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${request.quantity} pcs',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: colorMixGrad,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.black38),
                                        onPressed: () {
                                          setModalState(() {
                                            _cart.removeAt(index);
                                          });
                                          setState(() {});

                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (_cart.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: ElevatedButton(
                              onPressed: () {
                                _showConfirmationDialog();
                              },
                              child: Text('Place Order'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: colorMixGrad,
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }






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
                setState(() {
                  Navigator.of(context).pop();
                  _cart.clear(); // Clear the cart after placing the order
                });
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
                showSnackBar(context,"Order placed successfully");
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

              // Add to Cart Button
              _buildAddToCartButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _viewCart,
        icon: Icon(Icons.shopping_cart,color: Colors.white,),
        label: Text('${_cart.length} Items',style: TextStyle(color: Colors.white),),
        backgroundColor: colorMixGrad,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return ElevatedButton(
      onPressed: _addToCart,
      child: Text(
        "Add to Cart",
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

class TonerRequest {
  final String machineModel;
  final String color;
  final int quantity;
  final String details;

  TonerRequest({
    required this.machineModel,
    required this.color,
    required this.quantity,
    required this.details,
  });
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: keyboardType == TextInputType.number ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600), // Adjust hint text color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorMixGrad),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: Colors.white,
      ),
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        )
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorMixGrad),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
       icon: Icon(Icons.arrow_drop_down, color: colorMixGrad),
    );
  }
}

class ColorSpinner extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;
  final List<String> colorList;

  const ColorSpinner({
    required this.selectedValue,
    required this.onChanged,
    required this.colorList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      hint: const Text('Select an option'),
      items: colorList.map((color) => DropdownMenuItem(value: color, child: Text(color))).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorMixGrad),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down, color: colorMixGrad), // Custom dropdown icon color
    );
  }
}
