import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/screens/client/client.dart';
import 'package:tonner_app/screens/dasboard/dashboard.dart';
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
          physics: NeverScrollableScrollPhysics(),
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
      title: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Colors.white, Colors.white],
            tileMode: TileMode.mirror,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcATop,
        child: Image.asset(
          "assets/images/app_name_logo.png",
          width: 120,
          height: 40,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
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
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
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


class CategoriesDashboard extends StatelessWidget {
  const CategoriesDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 24.0,
                color: colorFirstGrad,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Handle onTap for each category item
                    int categoryId = StaticData.categories[index]["id"];
                    showSnackBar(context, "Clicked on - id_${categoryId}");

                    // You can navigate to another screen or perform any action here
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    elevation: 3.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          StaticData.categories[index]["icon"],
                          width: 80,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          StaticData.categories[index]["title"],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: StaticData.categories.length,
            ),
            SizedBox(height: 24.0),
            AspectRatio(
              aspectRatio: 1.8, // Adjusted aspect ratio for LineChart
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 0),
                        FlSpot(2, 5),
                        FlSpot(3, 10),
                        FlSpot(4, 5),
                        FlSpot(5, 2),
                        FlSpot(6, 14),
                      ],
                      gradient: const LinearGradient(
                        colors: [colorFirstGrad, colorMixGrad, colorSecondGrad],
                      ),
                      isCurved: true,
                      curveSmoothness: 0.6,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
