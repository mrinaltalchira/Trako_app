import 'package:Trako/model/toner_colors.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../color/colors.dart';
import '../../globals.dart';
import '../../model/all_machine.dart';
import '../add_toner/utils.dart'; // Adjust the import as needed

class RequestToner extends StatefulWidget {
  const RequestToner({super.key});

  @override
  State<RequestToner> createState() => _RequestTonerState();
}

class _RequestTonerState extends State<RequestToner> {
  int quantity = 1;
  final TextEditingController _counterController = TextEditingController();
  String? _selectedColor;
  late Future<List<Machine>> machineFuture;
  List<TonerRequestModel> _cart = [];
  String? selected_serial_no;
  bool _isLoading = false;
  late Future<TonerColors?> tonerColorFuture = getTonerColor("");
  Future<List<Machine>> getMachineList(String? filter) async {
    try {
      List<Machine> machines = await ApiService().getAllMachines(search: null,filter :filter.toString());
      // Debug print to check the fetched machines
      print('Fetched machines: $machines');
      return machines;
    } catch (e) {
      // Handle error
      print('Error fetching machines: $e');
      return [];
    }
  }

  Future<TonerColors?> getTonerColor(String serialNo) async {
    try {
      TonerColors? tonerColors = await ApiService().getTonerColors(serialNo);
      print('Fetched TonerColors: $tonerColors');
      return tonerColors;
    } catch (e) {
      print('Error fetching tonerColors: $e');
      return TonerColors(serialNo: 'Unknown', color: 'Unknown');
    }
  }


  @override
  void initState() {
    super.initState();
    machineFuture = getMachineList("only_active");
  }


  Future<void> submitRequest() async {
    try {
      // Show the loader before starting the request
      setState(() {
        _isLoading = true; // Show loader
      });

      // Assuming `_cart` is a list of TonerRequestModel instances
      if (_cart.isEmpty) {
        print('No toner requests to submit.');
        return;
      }

      // Call the function to send toner requests to the backend
      final response = await ApiService().sendTonerRequests(_cart);

      if (response['success']) {
        showSnackBar(context,"Order placed successfully");
        Navigator.pop(context, true);
        // You can clear the cart or perform any other action after successful submission
        _cart.clear();
      } else {
        showSnackBar1(context,'Failed to submit toner requests: ${response['message']}',isSuccess: false);

      }
    } catch (e) {
      showSnackBar1(context,'Failed to submit toner requests: ${e}',isSuccess: false);

    } finally {
      // Hide the loader after the request completes
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }



  void _addToCart() {

    if (selected_serial_no != null && _counterController.text.isNotEmpty && _selectedColor != null) {
      final tonerRequest = TonerRequestModel(
        serial_no: selected_serial_no!,
        color: _selectedColor!,
        quantity: quantity ,
        lastCounter: _counterController.text,
      );

      setState(() {
        _cart.add(tonerRequest);
        quantity = 1;
        _selectedColor = _selectedColor;
        _counterController.text = "";

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
                                    '${request.serial_no} - ${request.color}',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    'Quantity: ${request.quantity}\nCounter : ${request.lastCounter}',
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
                  submitRequest(); // Clear the cart after placing the order
                });
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();

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
              _buildSectionTitle('Select Serial no.'),
          SerialNoSpinner(
            onChanged: (String? newSerialNo) {
              setState(() {
                if (newSerialNo != null ) {
                  List<String> parts = newSerialNo.split(" - ");
                  selected_serial_no = parts[0];
                  tonerColorFuture = getTonerColor(selected_serial_no.toString());
                }
              });
            },
            machines: machineFuture, // Pass the future of the machines list
          ),
              SizedBox(height: 24.0),

              _buildSectionTitle('Current / Total Counter'),

              CustomTextField(
                controller: _counterController,
                hintText: 'Add counter',
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 10.0),
              // Color Selection
              _buildSectionTitle('Select Color'),
              FutureBuilder<TonerColors?>(
                future: tonerColorFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    _selectedColor = null;
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    _selectedColor = null;
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data?.color.isEmpty == true) {
                    _selectedColor = null;
                    return Center(child: Text('No colors available'));
                  } else {
                    // Process the data from the snapshot
                    final tonerColors = snapshot.data!;
                    final List<String> colors = tonerColors.color.split(",");

                    // Update the color list and selected color

                    return ColorSpinner(
                      selectedValue: _selectedColor,
                      onChanged: (String? newColor) {
                        setState(() {
                          _selectedColor = newColor;
                          print("sfsdfdsf ${_selectedColor}" );
                        });
                      },
                      colorList: colors,
                    );
                  }
                },
              ),SizedBox(height: 24.0),
              // Toner Quantity
              _buildSectionTitle('Toner Quantity'),
          QuantitySelector(
            initialValue: quantity,
            onChanged: (newQuantity) {
              setState(() {
                quantity = newQuantity;
              });
            },
          ),
              SizedBox(height: 24.0),

              SizedBox(height: 32.0),

              // Add to Cart Button
              _buildAddToCartButton(),


              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),

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

class TonerRequestModel {
  final String serial_no;
  final String color;
  final int quantity;
  final String lastCounter;

  TonerRequestModel({
    required this.serial_no,
    required this.color,
    required this.quantity,
    required this.lastCounter,
  });

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'serial_no': serial_no,
      'color': color,
      'quantity': quantity,
      'last_counter': lastCounter,
    };
  }
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
      maxLength: 10,
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


class QuantitySelector extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  QuantitySelector({Key? key, this.initialValue = 1, required this.onChanged}) : super(key: key);

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _increment() {
    if (_currentValue < 5) {
      setState(() {
        _currentValue++;
      });
      widget.onChanged(_currentValue);
    }
  }

  void _decrement() {
    if (_currentValue > 1) {
      setState(() {
        _currentValue--;
      });
      widget.onChanged(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: colorMixGrad), // Replace with colorMixGrad if needed
          onPressed: _decrement,
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: colorMixGrad), // Replace with colorMixGrad if needed
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            '$_currentValue',
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add, color: colorMixGrad), // Replace with colorMixGrad if needed
          onPressed: _increment,
        ),
      ],
    );
  }
}