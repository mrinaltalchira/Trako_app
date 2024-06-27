import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';

class ClientModule extends StatefulWidget {
  const ClientModule({super.key});

  @override
  _ClientModuleState createState() => _ClientModuleState();
}

class _ClientModuleState extends State<ClientModule> {
  final List<Map<String, dynamic>> items = [
    {
      'client_name': 'Jams Karter',
      'created_at': 'Gurugram',
      'is_active': true,
    },
    {
      'client_name': 'Peter Parker',
      'created_at': 'Mumbai',
      'is_active': false,
    },
    {
      'client_name': 'Ken Tino',
      'created_at': 'Jaipur',
      'is_active': false,
    },
    {
      'client_name': 'Will Smith',
      'created_at': 'Delhi',
      'is_active': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Client",
          style: TextStyle(
            fontSize: 24.0,
            color: colorMixGrad,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                  child: CustomSearchField(),
                ),
                const SizedBox(width: 20.0),
                GradientIconButton(
                  icon: Icons.add,
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_client');
                  },
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }
}

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [colorFirstGrad, colorSecondGrad],
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const GradientIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [colorFirstGrad, colorSecondGrad],
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        iconSize: 30.0,
      ),
    );
  }
}

class CustomInputTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;

  const CustomInputTextField({
    required this.hintText,
    required this.keyboardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
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
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: hintText,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: keyboardType,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 190,
                    child: LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
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

  const ScannedHistoryList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        Color? cardColor = items[index]['is_active'] ? Colors.red[10] : Colors.grey[300];

        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(items[index]['client_name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, items[index]);
                      },
                    ),
                  ],
                ),
                Text(items[index]['created_at'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4.0),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Text('Edit details of ${item['client_name']}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                _editItem(item);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editItem(Map<String, dynamic> item) {
    print('Editing item: ${item['client_name']}');
  }
}

class LinearGradientDivider extends StatelessWidget {
  final double height;
  final Gradient gradient;

  const LinearGradientDivider({
    required this.height,
    required this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
    );
  }
}
