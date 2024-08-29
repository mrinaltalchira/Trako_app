import 'package:flutter/material.dart';

import '../../color/colors.dart';
import '../../globals.dart';
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
  late Future<List<Toner>> tonersFuture;
  final ApiService _apiService = ApiService(); // Initialize your ApiService

  @override
  void initState() {
    super.initState();
      tonersFuture = getTonersList(null);
  }

   Future<List<Toner>> getTonersList(String? search) async {
    try {
      List<Toner> toners = (await _apiService.getAllToners(search)) as List<Toner>;
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
              padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 10),
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
                      FutureBuilder<List<Toner>>(
                        future: tonersFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<Toner> toners = snapshot.data ?? [];
                            // Debug print to check the toners before passing to the widget
                            print('Toners to display: $toners');

                            if (toners.isEmpty) {
                              return NoDataFoundWidget(
                                onRefresh: refreshTonersList,
                              );
                            } else {
                              return TonerList(items: toners);
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


class TonerList extends StatelessWidget {
  final List<Toner> items;

  const TonerList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Determine the background color based on isActive status
        Color? cardColor = Colors.grey[300];

        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: cardColor,
          // Set the color based on isActive status
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Toner name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${items[index].name[0].toUpperCase()}${items[index].name.substring(1)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                    // Edit button
                    Row(
                      children: [
                        Opacity(
                          opacity: 1,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              _showEditDialog(context, items[index]);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  items[index].type,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show the edit dialog
  void _showEditDialog(BuildContext context, Toner toner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Toner'),
          content: Text('Edit details of ${toner.name}'),
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
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestToner(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Function to edit a toner (Placeholder for actual implementation)
  void _editToner(BuildContext context, Toner toner) {
    // Implement your logic to edit the toner
    print('Editing toner: ${toner.name}');
    // Add your logic here to update toner data
  }
}

class Toner {
  final String id;
  final String name;
  final String type;
  final String color;

  Toner({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
  });

  // Factory method to create a Toner object from JSON data
  factory Toner.fromJson(Map<String, dynamic> json) {
    return Toner(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      color: json['color'],
    );
  }
}
