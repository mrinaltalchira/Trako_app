import 'package:flutter/material.dart';

import '../../color/colors.dart';
import '../../globals.dart';
import '../../model/acknowledgment.dart';
import '../../network/ApiService.dart';
import '../home/client/client.dart';
import 'add_acknowledgement.dart';

class Acknowledgement extends StatefulWidget {
  const Acknowledgement({Key? key}) : super(key: key);

  @override
  _AcknowledgementState createState() => _AcknowledgementState();
}

class AcknowledgementItem {
  final String id;
  final String name;
  final String description;
  final String date;
  final bool isAcknowledged;

  AcknowledgementItem({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.isAcknowledged,
  });
}

class _AcknowledgementState extends State<Acknowledgement> {

  late Future<List<AcknowledgementModel>> acknowledgementsFuture;
  final ApiService _apiService = ApiService(); // Initialize your ApiService


  Future<List<AcknowledgementModel>> getAcknowledgementDataList({
    String? search,
  }) async {
    try {
      List<AcknowledgementModel> acknowledgements = await _apiService.getAllAcknowledgeList(
        search: search,
        page: 1,
        perPage: 20,
      );

      // Debug print to check the fetched acknowledgements
      print('Fetched acknowledgements: $acknowledgements');
      return acknowledgements;
    } catch (e) {
      // Handle error
      print('Error fetching acknowledgements: $e');
      return [];
    }
  }


  @override
  void initState() {
    super.initState();
    acknowledgementsFuture = getAcknowledgementDataList(search: null);

  }

  Future<void> refreshAcknowledgementsList() async {
    setState(() {
      acknowledgementsFuture = getAcknowledgementDataList(search: null);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshAcknowledgementsList,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Acknowledgements",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorMixGrad,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomSearchField(
                      onSearchChanged: (searchQuery) {
                        setState(() {
                          acknowledgementsFuture = getAcknowledgementDataList(search: searchQuery);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20.0), // Spacer between search and add button
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [colorFirstGrad, colorMixGrad],
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAcknowledgement(),
                          ),
                        );
                        refreshAcknowledgementsList();
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
            Expanded(
              child: FutureBuilder<List<AcknowledgementModel>>(
                future: acknowledgementsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<AcknowledgementModel> acknowledgements = snapshot.data ?? [];
                    if (acknowledgements.isEmpty) {
                      return NoDataFoundWidget(
                        onRefresh: refreshAcknowledgementsList,
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: AcknowledgementList(
                          initialAcknowledgements: acknowledgements, onRefresh:refreshAcknowledgementsList,
                        ),
                      );
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

class AcknowledgementList extends StatefulWidget {
  final List<AcknowledgementModel> initialAcknowledgements;
  final String? search;
  final Future<void> Function() onRefresh;

  const AcknowledgementList({
    Key? key,
    required this.initialAcknowledgements,
    this.search,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _AcknowledgementListState createState() => _AcknowledgementListState();
}

class _AcknowledgementListState extends State<AcknowledgementList> {
  final ScrollController _scrollController = ScrollController();
  late List<AcknowledgementModel> _acknowledgements;
  bool _isLoading = false;
  int _currentPage = 2;  // Start from page 2 as we already have the first page
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _acknowledgements = List.from(widget.initialAcknowledgements);

    // Listen to scroll changes
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!_isLoading && _hasMoreData) {
          _loadMoreAcknowledgements();
        }
      }
    });

    print('Reaching init state');
  }

  @override
  void didUpdateWidget(AcknowledgementList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialAcknowledgements != oldWidget.initialAcknowledgements) {
      setState(() {
        _acknowledgements = List.from(widget.initialAcknowledgements);
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

  Future<void> _loadMoreAcknowledgements() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newAcknowledgements = await ApiService().getAllAcknowledgeList(
        search: widget.search,
        page: _currentPage,
        perPage: 20,  // Fetching 20 items per page
      );

      setState(() {
        _acknowledgements.addAll(newAcknowledgements);
        _currentPage++;
        _isLoading = false;
        _hasMoreData = newAcknowledgements.isNotEmpty;
      });
    } catch (e) {
      print('Error loading more acknowledgements: $e');
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
          print('Reached the bottom of the list');
          _loadMoreAcknowledgements();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _acknowledgements.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _acknowledgements.length) {
            return _buildLoaderIndicator();
          }

          return _buildAcknowledgementCard(_acknowledgements[index]);
        },
      ),
    );
  }

  Widget _buildAcknowledgementCard(AcknowledgementModel acknowledgement) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'QR - ${acknowledgement.qrCode.toUpperCase()}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
             Opacity(opacity: 0,child:    IconButton(
               icon: const Icon(Icons.edit),
               onPressed: () {
                 _showEditDialog(context, acknowledgement);
               },
             ),)
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              'Date: ${acknowledgement.dateTime}',
              style: const TextStyle(color: Colors.black54),
            ),
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

  void _showEditDialog(BuildContext context, AcknowledgementModel acknowledgement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Acknowledgement'),
          content: Text('Edit details of ${acknowledgement.qrCode}'),
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
                Navigator.of(context).pop();  // Close the dialog
                // Implement the navigation to an edit page or functionality
              },
            ),
          ],
        );
      },
    );
  }
}

