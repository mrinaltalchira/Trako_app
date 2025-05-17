import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/model/all_clients.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/home/client/add_client.dart';
import 'package:flutter/material.dart';

import '../../../utils/buttons.dart';
import '../../../utils/custome_search_field.dart';
import '../../../utils/utils.dart';

class ClientModule extends StatefulWidget {
  const ClientModule({Key? key}) : super(key: key);

  @override
  _ClientModuleState createState() => _ClientModuleState();
}

class _ClientModuleState extends State<ClientModule> {
  late Future<List<Map<String, dynamic>>> clientsFuture;
  final ApiService _apiService = ApiService();
  String? _searchQuery;
  String? _selectedState;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    clientsFuture = getClientsList(null,null,null);
  }

  Future<List<Map<String, dynamic>>> getClientsList(String? search, String? selectedState, String? selectedCity) async {
    try {
      List<Map<String, dynamic>> clients = await _apiService.getAllClients(
        search: search,
        filter: null,
        city: selectedCity,
        state: selectedState,
        page: 1,  // Fetching the first page
        perPage: 20,  // Fetching only 2 items per page
      );
      print('Fetched clients: $clients');
      return clients;
    } catch (e) {
      print('Error fetching clients: $e');
      return [];
    }
  }

  Future<void> refreshClientsList() async {
    setState(() {
      clientsFuture = getClientsList(_searchQuery,_selectedState,_selectedCity);
    });
  }

  void softDeleteClient(String? clientId) async {
    try {
      _apiService.softDeleteClient(
          clientId: clientId.toString() // Fetching only 2 items per page
      );
      setState(() {
        clientsFuture = getClientsList(_searchQuery,_selectedState,_selectedCity);
      });

    } catch (e) {
      print('Error fetching clients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshClientsList,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Client",
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomSearchField(
                      onSearchChanged: (searchQuery) {
                        setState(() {
                          _searchQuery = searchQuery;
                          clientsFuture = getClientsList(searchQuery, _selectedState, _selectedCity);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  InkWell(
                    onTap: _showLocationSelectDialog,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedState != null || _selectedCity != null
                              ? colorFirstGrad
                              : Colors.grey[300]!,
                        ),
                        color: _selectedState != null || _selectedCity != null
                            ? colorFirstGrad.withOpacity(0.1)
                            : Colors.white,
                      ),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.filter_alt,
                            color: _selectedState != null || _selectedCity != null
                                ? colorFirstGrad
                                : Colors.grey[600],
                          ),
                          if (_selectedState != null || _selectedCity != null)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: colorFirstGrad,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '•',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  GradientIconButton(
                    icon: Icons.add,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddClient(),
                        ),
                      );
                      refreshClientsList();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: clientsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Map<String, dynamic>> initialClients = snapshot.data ?? [];
                      print('Clients to display: $initialClients');

                      if (initialClients.isEmpty) {
                        return NoDataFoundWidget(
                          onRefresh: refreshClientsList,
                        );
                      } else {
                        return ClientList(
                          initialClients: initialClients,
                          search: _searchQuery,
                          onRefresh: refreshClientsList,
                          onDelete: (String? clientId, int index) async {
                             softDeleteClient(clientId);
                            // Refresh the list after deletion
                            refreshClientsList();
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSelectDialog() async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: LocationSelectDialog(
              selectedState: _selectedState,
              selectedCity: _selectedCity,
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedState = result['state'];
        _selectedCity = result['phone'];
        clientsFuture = getClientsList(_searchQuery,_selectedState,_selectedCity);

      });
    }
  }

}

class ClientList extends StatefulWidget {
  final List<Map<String, dynamic>> initialClients;
  final String? search;
  final String? filter;
  final Future<void> Function() onRefresh;
  final Function(String?, int)? onDelete; // Added onDelete parameter

  const ClientList({
    Key? key,
    required this.initialClients,
    this.search,
    this.filter,
    required this.onRefresh,
    this.onDelete, // Added onDelete parameter
  }) : super(key: key);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late List<Map<String, dynamic>> _clients;
  bool _isLoading = false;
  int _currentPage = 2;
  bool _hasMoreData = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _clients = List.from(widget.initialClients);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ClientList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialClients != oldWidget.initialClients) {
      setState(() {
        _clients = List.from(widget.initialClients);
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
      _loadMoreClients();
    }
  }

  Future<void> _loadMoreClients() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newClients = await ApiService().getAllClients(
        search: widget.search,
        filter: widget.filter,
        page: _currentPage,
        perPage: 20,
      );

      setState(() {
        _clients.addAll(newClients);
        _currentPage++;
        _isLoading = false;
        _hasMoreData = newClients.isNotEmpty;
      });
    } catch (e) {
      print('Error loading more clients: $e');
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
                _loadMoreClients();
                return true;
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _clients.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _clients.length) {
                  return _buildLoaderIndicator();
                }
                return _buildClientCard(_clients[index], index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientCard(Map<String, dynamic> client, int index) {
    final bool isActive = client['isActive'] == "0";
    final Color statusColor = isActive ? Colors.red : Colors.green;

   /* return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Dismissible(
              key: Key(client['id'].toString() ?? 'client-$index'),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text("Confirm Delete"),
                      content: Text("Are you sure you want to delete ${client['name']}?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            "DELETE",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                // Call the onDelete callback
                if (widget.onDelete != null) {
                  widget.onDelete!(client['id'].toString(), index);
                }

                // Remove from local list
                setState(() {
                  _clients.removeAt(index);
                });

                // Show a snackbar with undo option
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${client['name']} deleted'),
                    backgroundColor: colorFirstGrad,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white,
                      onPressed: () {
                        // Refresh the list to restore data
                        widget.onRefresh();
                      },
                    ),
                  ),
                );
              },
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      // Custom height for the colored bar
                      Container(
                        width: 4, // Width of the border
                        height: 50, // Set desired height for the border
                        color: statusColor,
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
                                      '${client['name']![0].toUpperCase()}${client['name']!.substring(1)}',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _showEditDialog(context, client),
                                        tooltip: 'Edit Client',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                'Email: ${client['email']!.toUpperCase()}',
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
            ),
          ),
        );
      },
    );*/

      return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  // Custom height for the colored bar
                  Container(
                    width: 4, // Width of the border
                    height: 50, // Set desired height for the border
                    color: statusColor,
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
                                  '${client['name']![0].toUpperCase()}${client['name']!.substring(1)}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    onPressed: () => _showEditDialog(context, client),
                                    tooltip: 'Edit Client',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            'Email: ${client['email']!.toUpperCase()}',
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

  Widget _buildLoaderIndicator(){
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit Client',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Edit details of ${client['name']}',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddClient(client: client),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}


