import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/model/all_supply.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/add_toner/add_toner.dart';




class SupplyChain extends StatefulWidget {
  @override
  State<SupplyChain> createState() => _SupplyChainState();
}

class _SupplyChainState extends State<SupplyChain> {
  late Future<List<Supply>> supplyFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Initialize the supplyFuture with the initial data load
    supplyFuture = getSupplyList(null);
  }

  Future<List<Supply>> getSupplyList(String? search) async {
    try {
      List<Supply> supplies = await _apiService.getAllSupply(search);
      // Debug print to check the fetched supplies
      print('Fetched supplies: $supplies');
      return supplies;
    } catch (e) {
      // Handle error
      print('Error fetching supplies: $e');
      return [];
    }
  }

  Future<void> refreshSupplyList() async {
    // Update the supplyFuture with refreshed data
    setState(() {
      supplyFuture = getSupplyList(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshSupplyList,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Supply Chain",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorMixGrad,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 10, 25.0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomSearchField(
                      onSearchChanged: (searchQuery) {
                        setState(() {
                          supplyFuture = getSupplyList(searchQuery);
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: IconButton(
                      onPressed: () {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<Supply>>(
                future: supplyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Supply> supplies = snapshot.data ?? [];
                    // Debug print to check the supplies before passing to the widget
                    print('Supplies to display: $supplies');

                    if (supplies.isEmpty) {
                      return NoDataFoundWidget(
                        onRefresh: refreshSupplyList,
                      );
                    } else {
                      return SupplyChainList(items: supplies);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class SupplyChainList extends StatelessWidget {
  final List<Supply> items;

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
                            '${items[index].qrCode}',
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
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: items[index].dispatchReceive == "0"
                              ? createTextWidget("Dispatched", Colors.red)
                              : createTextWidget("Received", Colors.green),
                        ),
/*
                        items[index].dispatchReceive == "0"
                            ? Icon(Icons.arrow_forward,color: Colors.red,)
                            : Icon(Icons.arrow_back,color: Colors.green,),
*/

                      ],
                    ),
                  ],
                ),
                Text(items[index].clientName,style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4.0),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget createTextWidget(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color,fontSize: 15,fontWeight: FontWeight.bold),
    );
  }

  void _showEditDialog(BuildContext context, Supply item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Text('Edit details of ${item.qrCode}'),
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
                _editItem(item.id);
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _editItem(String id) {
    // Implement your edit logic here, such as updating item details
    print('Editing item: ${id}');
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
                  'assets/images/ic_trako.png',
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

class CustomSearchField extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  const CustomSearchField({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  TextEditingController _searchController = TextEditingController();


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.green], // Replace with your gradient colors
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
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