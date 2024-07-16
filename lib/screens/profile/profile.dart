import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/pref_manager.dart';
import 'package:Trako/screens/home/home.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage> with SingleTickerProviderStateMixin {

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _roleController;
  late TextEditingController _userStatusController;
  final FocusNode myFocusNode = FocusNode();
  bool _status = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _roleController = TextEditingController();
    _userStatusController = TextEditingController();
    initializeControllers();
  }

  Future<void> initializeControllers() async {
    try {
      _nameController.text = await PrefManager().getUserName() ?? '';
      _emailController.text = await PrefManager().getUserEmail() ?? '';
      _phoneController.text = await PrefManager().getUserPhone() ?? '';
      _roleController.text = await PrefManager().getUserRole() ?? '';
      _userStatusController.text = await PrefManager().getUserStatus() ?? '';
      setState(() {}); // Update UI after initialization
    } catch (e) {
      throw Exception('Failed to initialize controllers');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _userStatusController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 250.0,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Stack(fit: StackFit.loose, children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 140.0,
                                height: 140.0,
                                  child:  CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.grey[200],
                                    child: Text(
                                      getInitials(_nameController.text),
                                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ),

                              ),
                            ],
                          ),
                        /*  const Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: colorFirstGrad,
                                  radius: 25.0,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                        ]),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0, ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Personal Information',
                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Name',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: colorMixGrad), // Border color when focused
                                    ),
                                    hintText: "Name",
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Email',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: colorMixGrad), // Border color when focused
                                    ),
                                    hintText: "Email",
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Phone',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: colorMixGrad), // Border color when focused
                                    ),
                                    hintText: "Phone",
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  'Role',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: const Text(
                                    'Status',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: TextField(
                                    controller: _roleController,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: colorMixGrad), // Border color when focused
                                      ),
                                      hintText: "Role",
                                    ),
                                    enabled: false,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: TextField(
                                  controller: _userStatusController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: colorMixGrad), // Border color when focused
                                    ),
                                    hintText: "Status",
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        !_status ? _getActionButtons() : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Profile"),
      backgroundColor: colorFirstGrad,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                child: ElevatedButton(
                  child: Text("Save"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: colorFirstGrad, disabledForegroundColor: colorMixGrad.withOpacity(0.38), disabledBackgroundColor: colorMixGrad.withOpacity(0.12),
                    elevation: 5,
                  ),
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                child: ElevatedButton(
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.grey, disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                    elevation: 5,
                  ),
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: colorMixGrad,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
