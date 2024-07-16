import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';

class MachineStatus extends StatelessWidget {
  const MachineStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 10, bottom: 10),
                child: Row(
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AllMachineList(),
              )
            ],
          )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Image.asset(
        "assets/images/app_name_logo.png",
        width: 120,
        height: 40,
      ),
    );
  }
}

class AllMachineList extends StatefulWidget {
  @override
  _AllMachineListState createState() => _AllMachineListState();
}

class _AllMachineListState extends State<AllMachineList> {
  final List<Map<String, dynamic>> items = [
    {
      'machineName': 'Maple jet',
      'machineCode': 'gdf4g86fgv1cx3',
      'is_active': true,
    },
    {
      'machineName': 'Canon PIXMA E4570',
      'machineCode': 'gdf4g86fgv1cx3',
      'is_active': false,
    },
    {
      'machineName': 'Epson EcoTank L3250',
      'machineCode': 'gdf4g86fgv1cx3',
      'is_active': true,
    },
    {
      'machineName': 'HP Smart Tank 529',
      'machineCode': 'difluzkgbf5s2fg65sdf',
      'is_active': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // Simulate fetching data from API
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Determine the background color based on is_active status
        Color? cardColor =
            items[index]['is_active'] ? Colors.red[10] : Colors.grey[300];

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
                            items[index]['machineName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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
                Text(items[index]['machineCode'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadioButton(
      bool isActive, Function(bool?) onChanged, BuildContext context) {
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
