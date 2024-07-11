import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/pref_manager.dart';
import 'package:tonner_app/screens/dasboard/dashboard.dart';
import 'package:tonner_app/screens/home/client/client.dart';
import 'package:tonner_app/screens/products/machine.dart';
import 'package:tonner_app/screens/reports/reports.dart';
import 'package:tonner_app/screens/supply_chian/supplychain.dart';
import 'package:tonner_app/screens/users/users.dart';

import '../authFlow/signin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
      body: WillPopScope(
        onWillPop: () async {
          if (_selectedIndex != 0) {
            _onItemTapped(0); // Navigate to Dashboard if not already there
            return false; // Do not pop the current route
          }
          return true; // Allow normal back behavior if already on Dashboard
        },
        child: PageView(
          physics: NeverScrollableScrollPhysics(), // Disable scroll physics
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            CategoriesDashboard(),
            ClientModule(),
            SupplyChain(),
            MachineModule(),
            MyReportScreen(),
            UsersModule(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Image.asset(
        "assets/images/app_name_logo.png",
        width: 120,
        height: 40,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading app logo: $error');
          return Text('Error loading logo');
        },
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
              // Navigator.pushNamed(context, '/profile');
            },
          ),
        ),
        SizedBox(width: 7),
      ],
    );
  }


  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [colorFirstGrad, colorSecondGrad],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Colors.white, Colors.white],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcATop,
                  child: Image.asset(
                    "assets/images/app_name_logo.png",
                    width: 100,
                    height: 40,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard,
              text: 'Dashboard',
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.person,
              text: 'Clients',
              index: 1,
            ),
            _buildDrawerItem(
              icon: Icons.account_tree_outlined,
              text: 'Supply Chain',
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.add_business,
              text: 'Machines',
              index: 3,
            ),
            _buildDrawerItem(
              icon: Icons.report,
              text: 'Reports',
              index: 4,
            ),
            _buildDrawerItem(
              icon: Icons.add,
              text: 'Users',
              index: 5,
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.white),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                showToast("Logout button pressed");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  PrefManager().clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthProcess()),
                        (Route<dynamic> route) => false,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon, required String text, required int index}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white)),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.blueAccent.withOpacity(0.3),
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index); // Directly jump to the page
    });
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
