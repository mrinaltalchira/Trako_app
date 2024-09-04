import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/model/all_clients.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/home/client/add_client.dart';

class ClientModule extends StatefulWidget {
  const ClientModule({super.key});

  @override
  _ClientModuleState createState() => _ClientModuleState();
}

class _ClientModuleState extends State<ClientModule> {
  late Future<List<Client>> clientsFuture;
  final ApiService _apiService = ApiService(); // Initialize your ApiService

  @override
  void initState() {
    super.initState();
    clientsFuture = getClientsList(null);
  }

  Future<List<Client>> getClientsList(String? search) async {
    try {
      List<Client> clients = await _apiService.getAllClients(search:search,filter: null);
      // Debug print to check the fetched clients
      print('Fetched clients: $clients');
      return clients;
    } catch (e) {
      // Handle error
      print('Error fetching clients: $e');
      return [];
    }
  }

    Future<void> refreshClientsList() async {
      setState(() {
        clientsFuture = getClientsList(null);
      });
      await clientsFuture; // Await the future to complete
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshClientsList,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Client",
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomSearchField(
                      onSearchChanged: (searchQuery) {
                        setState(() {
                          clientsFuture = getClientsList(searchQuery);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  GradientIconButton(
                    icon: Icons.add,
                    onPressed: () async{

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddClient(),
                        ),
                      );
                      refreshClientsList();
                      // Navigate to add machine screen
                      // Navigator.pushNamed(context, '/add_machine');
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<List<Client>>(
                    future: clientsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Client> clients = snapshot.data ??
                            []; // Handle null case if necessary
                        // Debug print to check the clients before passing to the widget
                        print('Clients to display: $clients');

                        if (clients.isEmpty) {
                         return NoDataFoundWidget(
                           onRefresh: () async {
                             // Simulate an API call
                             refreshClientsList();
                           },
                         );
                        } else {
                          return ClientList(items: clients);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  class ClientList extends StatelessWidget {
    final List<Client> items;

    const ClientList({Key? key, required this.items}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          Color? cardColor =
              items[index].isActive == "0" ? Colors.red[10] : Colors.grey[300];

          print('Items length: ${items[index].isActive}');
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: cardColor,
            // Assign the color based on isActive status
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${items[index].name[0].toUpperCase()}${items[index].name.substring(1)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, items[index]);
                        },
                      ),
                    ],
                  ),
                  Text(
                    'City: ${items[index].city[0].toUpperCase()}${items[index].city.substring(1)}',
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

    void _showEditDialog(BuildContext context, Client client) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Client'),
            content: Text('Edit details of ${client.name}'),
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

    void _editClient(BuildContext context, Client client) {
      // Implement your logic to edit the client
      print('Editing client: ${client.id}');
      // Add your logic here to update client data
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

