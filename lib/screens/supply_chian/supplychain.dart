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

class _SupplyChainListState extends State<SupplyChainList> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late List<Supply> _items;
  bool _isLoading = false;
  int _currentPage = 2;
  bool _hasMoreData = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_onScroll);
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreSupplies();
    }
  }

  Future<void> _loadMoreSupplies() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService().getAllSupply(
        search: widget.search,
        filter: widget.filter,
        page: _currentPage,
        perPage: 20,
      );

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
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        color: Theme.of(context).primaryColor,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_isLoading &&
                  scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                _loadMoreSupplies();
                return true;
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _items.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return _buildLoaderIndicator();
                }
                return _buildSupplyCard(_items[index], index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupplyCard(Supply item, int index) {
    final CardStatus status = _getCardStatus(item);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    // Custom height for the colored bar
                    Container(
                      width: 4, // Width of the border
                      height: 50, // Set desired height for the border
                      color: status.color,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.qrCode.toString(),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _buildStatusChip(status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Date: ${item.dateTime}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildStatusChip(CardStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoaderIndicator() {
    if (!_isLoading) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  CardStatus _getCardStatus(Supply item) {
    if (item.dispatchReceive == "0") {
      if (item.isAcknowledged == "1") {
        return CardStatus(
          label: 'Acknowledged',
          color: Colors.orange[400] ?? Colors.orange,
        );
      }
      return CardStatus(
        label: 'Dispatched',
        color: Colors.red,
      );
    }
    return CardStatus(
      label: 'Received',
      color: Colors.green[400] ?? Colors.green,
    );
  }

  void _showEditDialog(BuildContext context, Supply item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Edit Supply Item'),
          content: Text('Edit details of ${item.qrCode}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Edit'),
              onPressed: () {
                _editItem(item.id.toString());
                Navigator.of(context).pop();
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

class CardStatus {
  final String label;
  final Color color;

  CardStatus({
    required this.label,
    required this.color,
  });
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
