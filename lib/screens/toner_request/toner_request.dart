import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../color/colors.dart';
import '../../globals.dart';
import '../../model/all_toner_request.dart';
import '../../network/ApiService.dart';
import '../add_toner/add_toner.dart';
import '../home/client/client.dart';
import 'add_request.dart';

class TonerRequest extends StatefulWidget {
  const TonerRequest({Key? key}) : super(key: key);

  @override
  _TonerRequestState createState() => _TonerRequestState();
}

class _TonerRequestState extends State<TonerRequest> {
  late Future<List<AllTonerRequest>> tonersFuture;
  final ApiService _apiService = ApiService(); // Initialize your ApiService

  @override
  void initState() {
    super.initState();
      tonersFuture = getTonersList(search: null);
  }

  Future<List<AllTonerRequest>> getTonersList({String? search, int page = 1, int perPage = 20}) async {
    try {
      // Fetch paginated toner requests from the API
      List<AllTonerRequest> toners = await _apiService.getAllTonerRequests(
        search: search,
        page: page,
        perPage: perPage,
      );

      // Debug print to check the fetched toners
      print('Fetched toners: $toners');
      return toners;
    } catch (e) {
      // Handle error
      print('Error fetching toners: $e');
      return [];
    }
  }


  Future<void> refreshTonersList() async {
    setState(() {
      tonersFuture = getTonersList(search: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshTonersList,
        child: LayoutBuilder( // Added LayoutBuilder for safe sizing
          builder: (context, constraints) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Toner Requests",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: colorMixGrad, // Replace with your colorSecondGrad
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Make sure to acknowledge the toner after receiving it.",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey, // Replace with your colorSecondGrad
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomSearchField(
                          onSearchChanged: (searchQuery) {
                            setState(() {
                              tonersFuture = getTonersList(search: searchQuery);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20.0), // Spacer between search and add button
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [colorFirstGrad, colorMixGrad], // Adjust gradient colors
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestToner(),
                              ),
                            );
                            refreshTonersList();
                          },
                          icon: const Icon(
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
                  child: SizedBox(
                    height: constraints.maxHeight - 150, // Adjust height as needed
                    child: FutureBuilder<List<AllTonerRequest>>(
                      future: tonersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<AllTonerRequest> toners = snapshot.data ?? [];
                          if (toners.isEmpty) {
                            return NoDataFoundWidget(
                              onRefresh: refreshTonersList,
                            );
                          } else {
                            return TonerRequestList(
                              initialItems: toners,
                              onRefresh: refreshTonersList,
                            );
                          }
                        }
                      },
                    ),
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

class TonerRequestList extends StatefulWidget {
  final List<AllTonerRequest> initialItems;
  final Future<void> Function() onRefresh;
  final String? search;

  const TonerRequestList({
    Key? key,
    required this.initialItems,
    required this.onRefresh,
    this.search,
  }) : super(key: key);

  @override
  _TonerRequestListState createState() => _TonerRequestListState();
}

class _TonerRequestListState extends State<TonerRequestList> {
  final ScrollController _scrollController = ScrollController();
  late List<AllTonerRequest> _items;
  bool _isLoading = false;
  int _currentPage = 2;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMoreData && !_isLoading) {
      _loadMoreToners();
    }
  }

  Future<void> _loadMoreToners() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch more toner requests from API
      List<AllTonerRequest> newToners = await ApiService().getAllTonerRequests(
        search: widget.search,
        page: _currentPage,
        perPage: 20,
      );

      setState(() {
        _items.addAll(newToners);
        _currentPage++;
        _isLoading = false;
        _hasMoreData = newToners.isNotEmpty;
      });
    } catch (e) {
      print('Error loading more toners: $e');
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
          _loadMoreToners();
          return true;
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _items.length + (_hasMoreData ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _items.length) {
              return _buildLoaderIndicator(); // Show loader at the end of the list
            }
            return _buildTonerCard(_items[index]); // Build each toner card
          },
        ),
      ),
    );
  }

  Widget _buildTonerCard(AllTonerRequest item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${item.color[0].toUpperCase()}${item.color.substring(1)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: colorMixGrad,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Qty: ${item.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorMixGrad,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            _buildInfoRow('Serial No', item.serialNo ?? 'N/A'),
            _buildInfoRow('Last Counter', item.lastCounter.toString()),
            _buildInfoRow('Created At', _formatDate(item.createdAt)),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy HH:mm').format(date.toLocal());
  }
}

