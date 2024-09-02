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


  Future<List<AcknowledgementModel>> getAcknowledgementDataList(String? search) async {
    try {
      List<AcknowledgementModel> clients = await _apiService.getAllAcknowledgeList(search);
      // Debug print to check the fetched clients
      print('Fetched clients: $clients');
      return clients;
    } catch (e) {
      // Handle error
      print('Error fetching clients: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    acknowledgementsFuture = getAcknowledgementDataList(null);

  }

  Future<void> refreshAcknowledgementsList() async {
    setState(() {
      acknowledgementsFuture = getAcknowledgementDataList(null);
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
                    color: colorMixGrad, // Replace with your colorSecondGrad
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
                          acknowledgementsFuture = getAcknowledgementDataList(searchQuery);
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
                            builder: (context) =>  AddAcknowledgement(),
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
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FutureBuilder<List<AcknowledgementModel>>(
                        future: acknowledgementsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<AcknowledgementModel> clients = snapshot.data ??
                                []; // Handle null case if necessary
                            // Debug print to check the clients before passing to the widget
                            print('Clients to display: $clients');

                            if (clients.isEmpty) {
                              return NoDataFoundWidget(
                                onRefresh: () async {
                                  // Simulate an API call
                                  refreshAcknowledgementsList();
                                },
                              );
                            } else {
                              return AcknowledgementList(items: clients);
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

class AcknowledgementList extends StatelessWidget {
  final List<AcknowledgementModel> items;

  const AcknowledgementList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Determine the background color based on isAcknowledged status


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
                    // Acknowledgement name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'QR - ${items[index].qrCode.toUpperCase()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                    // Edit button

                  ],
                ),
                const SizedBox(height: 10.0),

                Text(
                  'Date: ${items[index].dateTime}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, AcknowledgementItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Acknowledgement'),
          content: Text('Edit details of ${item.name}'),
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

              },
            ),
          ],
        );
      },
    );
  }

  void _editAcknowledgement(BuildContext context, AcknowledgementItem item) {
    // Implement your logic to edit the acknowledgement
    print('Editing acknowledgement: ${item.name}');
    // Add your logic here to update item data
  }

}
