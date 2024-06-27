import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/screens/add_toner/add_toner.dart';


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
          "Supply Chain",
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

            Padding(
              padding: const EdgeInsets.only(left: 25.0,right: 25.0, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
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
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
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
                    ),
                  ),
                  const SizedBox(width: 20.0), // Spacer between search and add button
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Navigate to add client screen
                        Navigator.pushNamed(context, '/add_toner');
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      iconSize: 30.0,
                    ),
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
                      SupplyChainList(items: items),
                    ],
                  ),
                ),
              ),
            ),
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
          color: Colors.red[10],
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0,bottom: 12.0,right: 12.0),
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

                          Text(
                            items[index]['productName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),

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
                      ],
                    ),
                  ],
                ),
                Text(items[index]['scannedOn'],style: TextStyle(fontWeight: FontWeight.bold)),
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
      Navigator.pop(context, result!.code);
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