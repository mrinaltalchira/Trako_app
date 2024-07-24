import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/globals.dart';
import 'package:Trako/model/all_user.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:Trako/screens/users/add_user.dart';

class UsersModule extends StatefulWidget {
  const UsersModule({Key? key}) : super(key: key);

  @override
  _UsersModuleState createState() => _UsersModuleState();
}

class _UsersModuleState extends State<UsersModule> {
  late Future<List<User>> usersFuture;
  final ApiService _apiService = ApiService(); // Initialize your ApiService

  @override
  void initState() {
    super.initState();
    usersFuture = getUsersList(null);
  }

  Future<List<User>> getUsersList(String? search) async {
    try {
      List<User> users = await _apiService.getAllUsers(search);
      // Debug print to check the fetched users
      print('Fetched users: $users');
      return users;
    } catch (e) {
      // Handle error
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<void> refreshUsersList() async {
    setState(() {
      usersFuture = getUsersList(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshUsersList,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Users",
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
                          usersFuture = getUsersList(searchQuery);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20.0), // Spacer between search and add button
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [colorFirstGrad,colorMixGrad], // Adjust gradient colors
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Navigate to add user screen
                        Navigator.pushNamed(context, '/add_user');
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
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FutureBuilder<List<User>>(
                        future: usersFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<User> users = snapshot.data ?? [];
                            // Debug print to check the users before passing to the widget
                            print('Users to display: $users');

                            if (users.isEmpty) {
                              return NoDataFoundWidget(
                                onRefresh: refreshUsersList,
                              );
                            } else {
                              return ScannedHistoryList(items: users);
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


class NameInputTextField extends StatelessWidget {
  const NameInputTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
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
                    child: Container(
                      width: 200,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Enter Name',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
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
                        // Example gradient colors
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

class EmailInputTextField extends StatelessWidget {
  const EmailInputTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
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
                    child: const SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Enter Email',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
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
                        // Example gradient colors
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

class PhoneInputTextField extends StatelessWidget {
  const PhoneInputTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
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
                    child: Container(
                      width: 200,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Phone No.',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.phone,
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
                        // Example gradient colors
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

class AddressInputTextField extends StatelessWidget {
  const AddressInputTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
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
                    child: const SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Enter Address',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 190,
                    child: const LinearGradientDivider(
                      height: 1,
                      gradient: LinearGradient(
                        colors: [colorFirstGrad, colorSecondGrad],
                        // Example gradient colors
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

class ContactPersonInputTextField extends StatelessWidget {
  const ContactPersonInputTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Example radius value
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
                    child: Container(
                      width: 200,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          filled: false,
                          hintText: 'Contact Person Name',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        keyboardType: TextInputType.text,
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
                        // Example gradient colors
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

class ScannedHistoryList extends StatelessWidget {
  final List<User> items;

  const ScannedHistoryList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Determine the background color based on is_active status
        Color? cardColor = items[index].isActive == "0" ? Colors.red[10] : Colors.grey[300];

        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: cardColor,
          // Set the color based on is_active status
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12.0, bottom: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Client name
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
                    // Edit and delete buttons
                    Row(
                      children: [
                        Opacity(
                          opacity: 1,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              _showEditDialog(context,items[index]);
                            }, // Set onPressed to null to disable the button
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  items[index].email,
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

  void _showEditDialog(BuildContext context, User client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User'),
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
              onPressed: () {  Navigator.of(context).pop();  // Close the dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUser(user: client),
                ),
              );
              },
            ),
          ],
        );
      },
    );
  }

  void _editClient(BuildContext context, User client) {
    // Implement your logic to edit the client
    print('Editing client: ${client.name}');
    // Add your logic here to update client data
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
