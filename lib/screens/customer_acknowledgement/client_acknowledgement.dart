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

class _AcknowledgementListState extends State<AcknowledgementList> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late List<AcknowledgementModel> _acknowledgements;
  bool _isLoading = false;
  int _currentPage = 2;
  bool _hasMoreData = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _acknowledgements = List.from(widget.initialAcknowledgements);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_onScroll);
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreAcknowledgements();
    }
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
        perPage: 20,
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
                  scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                  _hasMoreData) {
                _loadMoreAcknowledgements();
                return true;
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _acknowledgements.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _acknowledgements.length) {
                  return _buildLoaderIndicator();
                }
                return _buildAcknowledgementCard(_acknowledgements[index], index);
              },
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildAcknowledgementCard(AcknowledgementModel acknowledgement, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Card(
              child: Row(
                children: [
                  // Custom height for the colored bar
                  Container(
                    width: 4, // Width of the border
                    height: 50, // Set desired height for the border
                    color: Theme.of(context).primaryColor,
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
                                  'QR - ${acknowledgement.qrCode.toUpperCase()}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Date: ${acknowledgement.dateTime}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
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
        );
      },
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

  void _showEditDialog(BuildContext context, AcknowledgementModel acknowledgement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit Acknowledgement',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Edit details of ${acknowledgement.qrCode}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                // Implement navigation to edit page
              },
            ),
          ],
        );
      },
    );
  }
}

