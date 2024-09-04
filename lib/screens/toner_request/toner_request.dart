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
      tonersFuture = getTonersList(null);
  }

   Future<List<AllTonerRequest>> getTonersList(String? search) async {
    try {
      List<AllTonerRequest> toners = (await _apiService.getAllTonerRequests());
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
      tonersFuture = getTonersList(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshTonersList,
        child: Column(
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
              padding: const EdgeInsets.only(left: 25.0,  bottom: 10),
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
                          tonersFuture = getTonersList(searchQuery);
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
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FutureBuilder<List<AllTonerRequest>>(
                        future: tonersFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<AllTonerRequest> toners = snapshot.data ?? [];
                            // Debug print to check the toners before passing to the widget
                            print('Toners to display: $toners');

                            if (toners.isEmpty) {
                              return NoDataFoundWidget(
                                onRefresh: refreshTonersList,
                              );
                            } else {
                              return TonerRequestList(items: toners);
                            }
                          }
                        },
                      ),
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

class TonerRequestList extends StatelessWidget {
  final List<AllTonerRequest> items;

  const TonerRequestList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
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
      },
    );
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
