
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/screens/add_toner/add_toner.dart';
import 'package:tonner_app/screens/dasboard/dashboard.dart';




class SupplyChain extends StatelessWidget{
  final List<Map<String, dynamic>> items = [
    {
      'productName': 'Maple jet',
      'scannedOn': 'gdf4g86fgv1cx3'

    },
    {
      'productName': 'Canon PIXMA E4570',
      'scannedOn': 'gdf4g86fgv1cx3'

    },
    {
      'productName': 'Epson EcoTank L3250',
      'scannedOn': 'gdf4g86fgv1cx3'

    },
    {
      'productName': 'HP Smart Tank 529',
      'scannedOn': '2024-03-15 11:45:20'
    },
  ];


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Supply Chain Module",
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
                        SupplyChainList(items: items),
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
                            Navigator.pushNamed(context, '/rq_view_tracesci');
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

class SupplyChainList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const SupplyChainList({Key? key, required this.items}) : super(key: key);

  @override
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
          color: Color.fromRGBO(245, 246, 250, 1),
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
                            'Machine Name:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          Text(items[index]['productName']),
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
                SizedBox(height: 8.0),
                Text(
                  'Machine Code:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(items[index]['scannedOn']),
                SizedBox(height: 8.0),


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
          content: Text('Edit details of ${item['productName']}'),
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


class QRViewTracesci extends StatefulWidget {
  const QRViewTracesci({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewTracesciState();
}

class _QRViewTracesciState extends State<QRViewTracesci> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool flashOn = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

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
                  'assets/images/app_name_logo.png',
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
              Expanded(flex: 4, child: _buildQrView(context)),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () async {
                  await controller?.toggleFlash();
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

  Widget _buildQrView(BuildContext context) {
    var scanArea = _calculateScanArea(context);
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 200,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  EdgeInsets _calculateScanArea(BuildContext context) {
    double scanAreaSize = MediaQuery.of(context).size.shortestSide * 0.75;
    return EdgeInsets.all((MediaQuery.of(context).size.shortestSide - scanAreaSize) / 2);
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (result == null) {
        setState(() {
          result = scanData;
        });
        _navigateToAddToner();
      }
    });
  }

  void _navigateToAddToner() {
    if (result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddToner(qrData:'${result!.code}'),
        ),
      ).then((_) {
        // Reset result after navigating to prevent multiple openings
        setState(() {
          result = null;
        });
      });
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No camera permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
