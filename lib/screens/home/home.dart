import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';
import 'package:tonner_app/screens/client/client.dart';
import 'package:tonner_app/screens/dasboard/dashboard.dart';
import 'package:tonner_app/screens/products/machine.dart';
import 'package:tonner_app/screens/supply_chian/supplychain.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        /*body: Body(),
      // We are not able to BottomNavigationBar because the icon parameter dont except SVG
      // We also use Provied to manage the state of our Nav

       */
        body: MyHomePage()

    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Image.asset(
        "assets/images/app_name_logo.png",
        width: 120, // Adjust width as per your requirement
        height: 40, // Adjust height as per your requirement
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomImageWidget(
            imageUrl: 'assets/images/ic_profile.png',
            width: 30,
            height: 30,
            radius: 25,
            isNetworkImage: false,
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ),
        SizedBox(width: 7), // Adjust as needed
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex = 0;
  late PageController _pageController; // Remove late keyword here

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: _selectedIndex); // Initialize _pageController here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController, // Use _pageController here
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
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -7),
              blurRadius: 30,
              color: Color(0xFF4B1A39).withOpacity(0.2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.dashboard),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  _pageController.jumpToPage(0);
                },
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                  _pageController.jumpToPage(1);
                },
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.account_tree_outlined),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                  _pageController.jumpToPage(2);
                },
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.add_business),

                onPressed: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                  _pageController.jumpToPage(3);
                },
                color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class NameInputTextField extends StatelessWidget {
  const NameInputTextField({Key? key}) : super(key: key);

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