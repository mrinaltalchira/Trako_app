import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';

class ClientModule extends StatefulWidget {
  @override
  _ClientModuleState createState() => _ClientModuleState();
}

class _ClientModuleState extends State<ClientModule> {
  final List<Map<String, dynamic>> items = [
    {
      'client_name': 'Jams Karter',
      'created_at': '2024-03-14 10:23:36',
      'is_active': true,
    },
    {
      'client_name': 'Peter Parker',
      'created_at': '2024-03-15 11:45:20',
      'is_active': false,
    },
    {
      'client_name': 'Ken Tino',
      'created_at': '2024-03-15 11:45:20',
      'is_active': false,
    },
    {
      'client_name': 'Will Smith',
      'created_at': '2024-03-15 11:45:20',
      'is_active': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Client Module",
          style: TextStyle(
            fontSize: 24.0,
            color: colorMixGrad, // Replace with your colorSecondGrad
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ScannedHistoryList(items: items),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0,right: 25.0, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [colorFirstGrad,colorSecondGrad],
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle search button press
                          // Implement search functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          'Search',
                          style: TextStyle(color: Colors.white,fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0), // Spacer between buttons
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [colorFirstGrad, colorSecondGrad],
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to add client screen
                          Navigator.pushNamed(context, '/add_client');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white,fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48)
          ],
        ),
      ),
    );
  }
}

class NameInputTextField extends StatelessWidget {
  const NameInputTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(5, 10),
                    child: Container(
                      width: 200,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Enter Name',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 190,
                    child: const LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                        // Example gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailInputTextField extends StatelessWidget {
  const EmailInputTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(5, 10),
                    child: Container(
                      width: 200,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Enter Email',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 190,
                    child: const LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                        // Example gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneInputTextField extends StatelessWidget {
  const PhoneInputTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(5, 10),
                    child: Container(
                      width: 200,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Phone No.',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 190,
                    child: const LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                        // Example gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressInputTextField extends StatelessWidget {
  const AddressInputTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(5, 10),
                    child: Container(
                      width: 200,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Enter Address',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 190,
                    child: const LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                        // Example gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),

                  const SizedBox(height: 21),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ContactPersonInputTextField extends StatelessWidget {
  const ContactPersonInputTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(5, 10),
                    child: Container(
                      width: 200,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Contact Person Name',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 190,
                    child: const LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                        // Example gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ScannedHistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ScannedHistoryList({Key? key, required this.items}) : super(key: key);

  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {


        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Color.fromRGBO(245, 246, 250, 1), // Set the color based on is_active status
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Client name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Client Name:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          Text(items[index]['client_name']),
                        ],
                      ),
                    ),
                    // Edit and delete buttons
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Handle edit action
                            _showEditDialog(context, items[index]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Show delete confirmation dialog
                            _showDeleteDialog(context, index);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Text(
                  'Created at:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(items[index]['created_at']),
                SizedBox(height: 8.0),
                Text(
                  'Is Active:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    items[index]['is_active']
                        ? Row(
                      children: [
                        Text('Yes'),
                        SizedBox(width: 4.0),
                        Icon(Icons.check, color: Colors.green),
                      ],
                    )
                        : Row(
                      children: [
                        Text('No'),
                        SizedBox(width: 4.0),
                        Icon(Icons.close, color: Colors.red),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }




  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Perform delete action
                _deleteItem(index);
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    // Implement your delete logic here, such as deleting item from a list or database
    print('Deleting item at index $index');
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Text('Edit details of ${item['client_name']}'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                // Perform edit action
                _editItem(item);
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _editItem(Map<String, dynamic> item) {
    // Implement your edit logic here, such as updating item details
    print('Editing item: ${item['productName']}');
  }
}
