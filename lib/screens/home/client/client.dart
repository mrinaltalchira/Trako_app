import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/model/all_clients.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/home/client/add_client.dart';
import 'package:flutter/material.dart';

class ClientModule extends StatefulWidget {
  const ClientModule({Key? key}) : super(key: key);

  @override
  _ClientModuleState createState() => _ClientModuleState();
}

class _ClientModuleState extends State<ClientModule> {
  late Future<List<Client>> clientsFuture;
  final ApiService _apiService = ApiService();
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    clientsFuture = getClientsList(null);
  }

  Future<List<Client>> getClientsList(String? search) async {
    try {
      List<Client> clients = await _apiService.getAllClients(
        search: search,
        filter: null,
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
      clientsFuture = getClientsList(_searchQuery);
    });
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
                          clientsFuture = getClientsList(searchQuery);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20.0),
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
                child: FutureBuilder<List<Client>>(
                  future: clientsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Client> initialClients = snapshot.data ?? [];
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


}


class ClientList extends StatefulWidget {
  final List<Client> initialClients;
  final String? search;
  final String? filter;
  final Future<void> Function() onRefresh;

  const ClientList({
    Key? key,
    required this.initialClients,
    this.search,
    this.filter,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late List<Client> _clients;
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

  Widget _buildClientCard(Client client, int index) {
    final bool isActive = client.isActive == "1";
    final Color statusColor = isActive ? Colors.red : Colors.green;

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
                                    '${client.name![0].toUpperCase()}${client.name!.substring(1)}',
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
                              'City: ${client.city![0].toUpperCase()}${client.city!.substring(1)}',
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
        );
      },
    );
  }


  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
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

  void _showEditDialog(BuildContext context, Client client) {
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
            'Edit details of ${client.name}',
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

