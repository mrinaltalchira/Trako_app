import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';

class Accessibility extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(color: Colors.white, child: UserAuthorityModule()),
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

class UserAuthorityModule extends StatefulWidget {
  const UserAuthorityModule({super.key});

  @override
  _UserAuthorityModuleState createState() => _UserAuthorityModuleState();
}

class _UserAuthorityModuleState extends State<UserAuthorityModule> {
  final List<Map<String, dynamic>> items = [
    {
      'client_name': 'Jams Karter',
      'created_at': 'Gurugram',
      'is_active': true,
      'machine_module': false,
      'client_module': true,
      'users': false,
    },
    {
      'client_name': 'Peter Parker',
      'created_at': 'Mumbai',
      'is_active': false,
      'machine_module': true,
      'client_module': false,
      'users': true,
    },
    {
      'client_name': 'Ken Tino',
      'created_at': 'Jaipur',
      'is_active': false,
      'machine_module': false,
      'client_module': true,
      'users': false,
    },
    {
      'client_name': 'Will Smith',
      'created_at': 'Delhi',
      'is_active': true,
      'machine_module': true,
      'client_module': true,
      'users': true,
    },
  ];

  void _showEditDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Client'),
          content: CheckBoxRow(item: item),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10, bottom: 10),
            child: Row(
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ScannedHistoryList(items: items, onEdit: _showEditDialog),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannedHistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(BuildContext, Map<String, dynamic>) onEdit;

  const ScannedHistoryList({super.key, required this.items, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        Color? cardColor = items[index]['is_active'] ? Colors.red[10] : Colors.grey[300];

        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(items[index]['client_name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        onEdit(context, items[index]);
                      },
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
}

class CheckBoxRow extends StatefulWidget {
  final Map<String, dynamic> item;

  const CheckBoxRow({required this.item});

  @override
  _CheckBoxRowState createState() => _CheckBoxRowState();
}

class _CheckBoxRowState extends State<CheckBoxRow> {
  bool machineModuleChecked = false;
  bool clientModuleChecked = false;
  bool userPrivilegeChecked = false;
  bool activeChecked = true;

  @override
  void initState() {
    super.initState();
    machineModuleChecked = widget.item['machine_module'];
    clientModuleChecked = widget.item['client_module'];
    userPrivilegeChecked = widget.item['users'];
    activeChecked = widget.item['is_active'];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomCheckbox(
                value: machineModuleChecked,
                onChanged: (bool? value) {
                  setState(() {
                    machineModuleChecked = value ?? false;
                    widget.item['machine_module'] = machineModuleChecked;
                  });
                },
                activeColor: colorMixGrad,
              ),
              const SizedBox(width: 10.0),
              const Expanded(
                child: Text('Machine Module'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CustomCheckbox(
                value: clientModuleChecked,
                onChanged: (bool? value) {
                  setState(() {
                    clientModuleChecked = value ?? false;
                    widget.item['client_module'] = clientModuleChecked;
                  });
                },
                activeColor: colorMixGrad,
              ),
              const SizedBox(width: 10.0),
              const Expanded(
                child: Text('Client Module'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CustomCheckbox(
                value: userPrivilegeChecked,
                onChanged: (bool? value) {
                  setState(() {
                    userPrivilegeChecked = value ?? false;
                    widget.item['users'] = userPrivilegeChecked;
                  });
                },
                activeColor: colorMixGrad,
              ),
              const SizedBox(width: 10.0),
              const Expanded(
                child: Text('User Privilege'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Active Status:'),
              const SizedBox(width: 5),
              Row(
                children: [
                  CustomRadio(
                    value: true,
                    groupValue: activeChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        activeChecked = value ?? false;
                        widget.item['is_active'] = activeChecked;
                      });
                    },
                    activeColor: colorMixGrad,
                  ),
                  const Text('Active'),
                  const SizedBox(height: 5),
                  CustomRadio(
                    value: false,
                    groupValue: activeChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        activeChecked = value ?? false;
                        widget.item['is_active'] = activeChecked;
                      });
                    },
                    activeColor: colorMixGrad,
                  ),
                  const Text('Inactive'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color activeColor;

  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }
}

class CustomRadio extends StatelessWidget {
  final bool value;
  final bool? groupValue;
  final ValueChanged<bool?>? onChanged;
  final Color activeColor;

  const CustomRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }
}
