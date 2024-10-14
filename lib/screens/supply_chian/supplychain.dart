import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    supplyFuture = getSupplyList(search: _searchQuery);

  }

  Future<List<Supply>> getSupplyList({String? search, int page = 1, int perPage = 20}) async {
    try {
      // Fetch paginated supply data from the API
      SupplyResponse response = await _apiService.getAllSupply(search: search, page: page, perPage: perPage);
      List<Supply> supplies = response.data.supply;

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
      supplyFuture = getSupplyList(search: _searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshSupplyList,
        child: LayoutBuilder( // Added LayoutBuilder for safe sizing
          builder: (context, constraints) {
            return ListView(
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
                              _searchQuery = searchQuery;
                              supplyFuture = getSupplyList(search: searchQuery);
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
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddToner(),
                              ),
                            );
                            refreshSupplyList();
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
                        if (supplies.isEmpty) {
                          return NoDataFoundWidget(
                            onRefresh: refreshSupplyList,
                          );
                        } else {
                          return Container( // Wrap the SupplyChainList with Container
                            height: constraints.maxHeight, // Ensure valid height
                            child: SupplyChainList(
                              search: _searchQuery,
                              onRefresh: refreshSupplyList,
                              initialItems: supplies,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}

class SupplyChainList extends StatefulWidget {
  final List<Supply> initialItems;
  final Future<void> Function() onRefresh;
  final String? search;
  final String? filter;

  const SupplyChainList({
    Key? key,
    required this.initialItems,
    required this.onRefresh,
    this.search,
    this.filter,
  }) : super(key: key);

  @override
  _SupplyChainListState createState() => _SupplyChainListState();
}

class _SupplyChainListState extends State<SupplyChainList> {
  final ScrollController _scrollController = ScrollController();
  late List<Supply> _items;
  bool _isLoading = false;
  int _currentPage = 2; // Start from page 2
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
  }

  @override
  void didUpdateWidget(SupplyChainList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialItems != oldWidget.initialItems) {
      setState(() {
        _items = List.from(widget.initialItems);
        _currentPage = 2;
        _hasMoreData = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreSupplies() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the SupplyResponse from the API service
      final response = await ApiService().getAllSupply(
        search: widget.search,
        filter: widget.filter,
        page: _currentPage,
        perPage: 20, // Fetching 2 items per page
      );

      // Extract the list of supplies from the response
      final newSupplies = response.data.supply;

      setState(() {
        _items.addAll(newSupplies);
        _currentPage++;
        _isLoading = false;
        _hasMoreData = newSupplies.isNotEmpty;
      });
    } catch (e) {
      print('Error loading more supplies: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            _hasMoreData) {
          _loadMoreSupplies(); // Load more data when scrolling to the bottom
          return true;
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: widget.onRefresh, // Pull-to-refresh functionality
        child: LayoutBuilder( // Using LayoutBuilder to handle widget sizing
          builder: (context, constraints) {
            return Container( // Added a Container to ensure proper layout sizing
              height: constraints.maxHeight, // Ensure the Stack has a valid height
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _items.length + (_hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _items.length) {
                          return _buildLoaderIndicator(); // Loader at the end of the list
                        }
                        return _buildSupplyCard(_items[index]); // Build each supply card
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }



  Widget _buildSupplyCard(Supply item) {
    Color? cardColor =  Colors.red[10];
    String status = '';
    Color? statusColor = Colors.grey[300];


    if (item.dispatchReceive == "0") {
      status = 'Dispatched';
      statusColor = Colors.red;
      if (item.isAcknowledged == "1") {
        status = 'Acknowledged';
        statusColor = Colors.orange[400];
      }
    } else if (item.dispatchReceive == "1") {
      status = 'Received';
      statusColor = Colors.green[300];
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'QR: ${item.qrCode}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
               Opacity(opacity: 1,
               child:  Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Text(status,style: TextStyle(color: statusColor,fontSize: 12),),
               ),)
              ],
            ),
            Text(
              'Date: ${item.dateTime}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaderIndicator() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container();
  }

  void _showEditDialog(BuildContext context, Supply item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Supply Item'),
          content: Text('Edit details of ${item.qrCode}'),
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
                _editItem(item.id.toString());
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _editItem(String id) {
    print('Editing supply item: $id');
    // Implement your edit logic here
  }
}

class QRViewTracesci extends StatefulWidget {
  const QRViewTracesci({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewTracesciState();
}

class _QRViewTracesciState extends State<QRViewTracesci> {
  String? result;
  bool flashOn = false;
  MobileScannerController cameraController = MobileScannerController();

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
              Expanded(
                flex: 4,
                child: MobileScanner(
                  controller: cameraController,
                  onDetect: (BarcodeCapture barcodeCapture) {
                    final List<Barcode> barcodes = barcodeCapture.barcodes;
                    if (barcodes.isNotEmpty) {
                      if (result == null) {
                        setState(() {
                          result = barcodes.first.rawValue;
                        });
                        _navigateToAddToner();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () async {
                  await cameraController.toggleTorch();
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

  void _navigateToAddToner() {
    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}


class CustomSearchField extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;

  const CustomSearchField({Key? key, required this.onSearchChanged})
      : super(key: key);

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
          colors: [
            Colors.blue,
            Colors.green
          ], // Replace with your gradient colors
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
