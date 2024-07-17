import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';

class UserStatus extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(color: Colors.white, child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [colorFirstGrad, colorSecondGrad],
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          AllUserList()
        ],),
      )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Image.asset(
        "assets/images/ic_trako.png",
        width: 120,
        height: 40,
      ),
    );
  }
}



class AllUserList extends StatefulWidget {
  @override
  _AllUserListState createState() => _AllUserListState();
}

class _AllUserListState extends State<AllUserList> {
  List<Map<String, dynamic>>  items = [
    {
      'client_name': 'Jams Karter',
      'created_at': 'Gurugram',
      'is_active': true,
    },
    {
      'client_name': 'Peter Parker',
      'created_at': 'Mumbai',
      'is_active': false,
    },
    {
      'client_name': 'Ken Tino',
      'created_at': 'Jaipur',
      'is_active': false,
    },
    {
      'client_name': 'Will Smith',
      'created_at': 'Delhi',
      'is_active': true,
    },
    // Add more items as needed
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // Simulate fetching data from API
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Determine the background color based on is_active status
        Color? cardColor = items[index]['is_active'] ? Colors.red[10] : Colors.grey[300];


        return Card(
          margin: const EdgeInsets.only(top:15.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: cardColor, // Set the color based on is_active status
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 12.0, right: 12.0),
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
                          Text(items[index]['client_name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                    // Radio button for active/inactive
                    Row(
                      children: [
                        _buildRadioButton(items[index]['is_active'], (value) {
                          // Handle radio button change
                          _toggleActiveStatus(index, value);
                        }, context),
                      ],
                    ),
                  ],
                ),
                Text(items[index]['created_at'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadioButton(bool isActive, Function(bool?) onChanged, BuildContext context) {
    return Row(
      children: [
        Radio<bool>(
          value: true,
          groupValue: isActive,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
        const Text('Active'),
        Radio<bool>(
          value: false,
          groupValue: isActive,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
        const Text('Inactive'),
      ],
    );
  }

  void _toggleActiveStatus(int index, bool? value) {
    if (value != null) {
      setState(() {
        items[index]['is_active'] = value;
      });
      // Call API to update status here if needed
    }
  }
}
