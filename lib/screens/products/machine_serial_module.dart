import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/products/add_machine.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../utils/custome_search_field.dart';

class MachineSerialModule extends StatefulWidget {
  @override
  _MachineSerialModuleState createState() => _MachineSerialModuleState();
}

class _MachineSerialModuleState extends State<MachineSerialModule> {
  late Future<List<Map<String, dynamic>>> machineFuture;
  final ApiService _apiService = ApiService(); // Initialize your ApiService

  @override
  void initState() {
    super.initState();
    machineFuture = getMachineList(null);
  }

  Future<List<Map<String, dynamic>>> getMachineList(String? search) async {
    try {
      List<Map<String, dynamic>> machines = await _apiService.getAllMachines(
        search: search,
        filter: null,
        page: 1, // Fetching the first page
        perPage: 20, // Fetching 20 items per page
      );
      return machines;
    } catch (e) {
      print('Error fetching machines: $e');
      return [];
    }
  }

  void softDeleteSerial(String? serialId) async {
    try {
      _apiService.softDeleteSerialNo(
          serialId: serialId.toString() // Fetching only 2 items per page
      );
      setState(() {
        machineFuture = getMachineList(null);
      });

    } catch (e) {
      print('Error fetching models: $e');
    }
  }

  Future<void> refreshMachineList() async {
    setState(() {
      machineFuture = getMachineList(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshMachineList,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Serial No.",
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomSearchField(
                      onSearchChanged: (searchQuery) {
                        setState(() {
                          machineFuture = getMachineList(searchQuery);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20.0),
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
                            builder: (context) => AddMachine(),
                          ),
                        );
                        refreshMachineList();
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: machineFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Map<String, dynamic>> machines = snapshot.data ?? [];

                      if (machines.isEmpty) {
                        return NoDataFoundWidget(
                          onRefresh: refreshMachineList,
                        );
                      } else {
                        return MachineList(
                          initialMachines: machines,
                          onRefresh: refreshMachineList,
                          onDelete: (machineId) async {
                            try {
                              softDeleteSerial(machineId.toString());
                            } catch (e) {
                              print('Error deleting machine: $e');
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to delete machine')),
                              );
                            }
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
}

class MachineList extends StatefulWidget {
  final List<Map<String, dynamic>> initialMachines;
  final String? search;
  final String? filter;
  final Future<void> Function() onRefresh;
  final Function(int) onDelete;

  const MachineList({
    Key? key,
    required this.initialMachines,
    this.search,
    this.filter,
    required this.onRefresh,
    required this.onDelete,
  }) : super(key: key);

  @override
  _MachineListState createState() => _MachineListState();
}

class _MachineListState extends State<MachineList>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late List<Map<String, dynamic>> _machines;
  bool _isLoading = false;
  int _currentPage = 2;
  bool _hasMoreData = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _machines = List.from(widget.initialMachines);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(MachineList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMachines != oldWidget.initialMachines) {
      setState(() {
        _machines = List.from(widget.initialMachines);
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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreMachines();
    }
  }

  Future<void> _loadMoreMachines() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newMachines = await ApiService().getAllMachines(
        search: widget.search,
        filter: widget.filter,
        page: _currentPage,
        perPage: 20,
      );

      setState(() {
        _machines.addAll(newMachines);
        _currentPage++;
        _isLoading = false;
        _hasMoreData = newMachines.isNotEmpty;
      });
    } catch (e) {
      print('Error loading more machines: $e');
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
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  _hasMoreData) {
                _loadMoreMachines();
                return true;
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _machines.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _machines.length) {
                  return _buildLoaderIndicator();
                }
                return _buildMachineCard(_machines[index], index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMachineCard(Map<String, dynamic> machine, int index) {
    final bool isActive = machine['isActive'] == "1";
    final Color statusColor = isActive ? Colors.green : Colors.red;

    // Extract model_name from API response
    print("sfsdfdfsdfdf $machine");
    final String modelName = machine['model_no'] ?? '';
    final String serialNo = machine['serial_no'] ?? '';


   /* return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Slidable(
              key: ValueKey(machine['id']),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(
                  onDismissed: () {
                    widget.onDelete(machine['id']);
                  },
                ),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      widget.onDelete(machine['id']);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child:Card(
                child: InkWell(
                  onTap: () => _showEditDialog(context, machine),
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
                                      '${serialNo.isNotEmpty ? '${serialNo[0].toUpperCase()}${serialNo.substring(1)}' : 'Unknown'}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
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
                                        onPressed: () =>
                                            _showEditDialog(context, machine),
                                        tooltip: 'Edit Serial No',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                modelName.isNotEmpty
                                    ? 'Model No: ${modelName[0].toUpperCase()}${modelName.substring(1)}'
                                    : 'Unknown Model',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
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
    );
*/

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Card(
            child: InkWell(
              onTap: () => _showEditDialog(context, machine),
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
                                  '${serialNo.isNotEmpty ? '${serialNo[0].toUpperCase()}${serialNo.substring(1)}' : 'Unknown'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
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
                                    onPressed: () =>
                                        _showEditDialog(context, machine),
                                    tooltip: 'Edit Serial No',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            modelName.isNotEmpty
                                ? 'Model No: ${modelName[0].toUpperCase()}${modelName.substring(1)}'
                                : 'Unknown Model',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> machine) {
    final String modelName = machine['model_name'] ?? 'this machine';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit Machine',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Text(
            'Edit details of $modelName',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMachine(machine: machine),
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
