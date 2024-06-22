import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          //tabcontroller.index can be used to get the name of current index value of the tabview.
          title: Text(tabController.index == 0
              ? "TextConstants.titleTab_1"
              : tabController.index == 1
              ? "TextConstants.titleTab_2"
              : tabController.index == 2
              ? "TextConstants.titleTab_3"
              : "TextConstants.titleTab_4"),
          bottom: TabBar(controller: tabController, tabs: [
            Tab(
              text: "TextConstants.titleTab_1",
              icon: Icon(
                Icons.home,
                color: Colors.indigo.shade500,
              ),
            ),
            Tab(
                text: "TextConstants.titleTab_2",
                icon: Icon(
                  Icons.email,
                  color: Colors.indigo.shade500,
                )),
            Tab(
                text: "TextConstants.titleTab_3",
                icon: Icon(
                  Icons.star,
                  color: Colors.indigo.shade500,
                )),
            Tab(
                text: "TextConstants.titleTab_4",
                icon: Icon(
                  Icons.person,
                  color: Colors.indigo.shade500,
                ))
          ]),
        ),
        body: TabBarView(controller: tabController, children: [
          FirstScreen(
            tabController: tabController,
          ),
          SecondScreen(
            tabController: tabController,
          ),
          ThirdScreen(
            tabController: tabController,
          ),
          FourthScreen(
            tabController: tabController,
          )
        ]));
  }
}

class SecondScreen extends StatelessWidget {
  final TabController tabController;
  const SecondScreen({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenBody(
        tabBarTitle: "TextConstants.titleTab_2",
        tabController: tabController,
        tabIcon: Icons.mail);
  }
}


class ThirdScreen extends StatelessWidget {
  final TabController tabController;
  const ThirdScreen({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenBody(
        tabBarTitle: "TextConstants.titleTab_3",
        tabController: tabController,
        tabIcon: Icons.star);
  }
}


class FourthScreen extends StatelessWidget {
  final TabController tabController;
  const FourthScreen({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenBody(
        tabBarTitle: "TextConstants.titleTab_4",
        tabController: tabController,
        tabIcon: Icons.person);
  }
}

class FirstScreen extends StatelessWidget {
  final TabController tabController;
  const FirstScreen({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenBody(
        tabBarTitle: "TextConstants.titleTab_1",
        tabController: tabController,
        tabIcon: Icons.home);
  }
}

class ScreenBody extends StatefulWidget {
  final String tabBarTitle;
  final TabController tabController;
  final IconData tabIcon;

  const ScreenBody(
      {Key? key,
        required this.tabBarTitle,
        required this.tabController,
        required this.tabIcon})
      : super(key: key);

  @override
  State<ScreenBody> createState() => _ScreenBodyState();
}

class _ScreenBodyState extends State<ScreenBody> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo.shade400,
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.orange.shade200, shape: BoxShape.circle),
                child: Icon(
                  widget.tabIcon,
                  color: Colors.orange.shade900,
                  size: 100,
                ),
              ),
              Text(
                widget.tabBarTitle,
                style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        floatingActionButton: isExpanded == false
            ? FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: const Icon(
            Icons.add,
            color: Colors.orange,
          ),
          onPressed: () {
            setState(() {
              isExpanded = true;
            });
          },
        )
            : InkWell(
          hoverColor: Colors.indigo.shade200,
          onTap: () {
            setState(() {
              isExpanded = false;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                child: const Icon(
                  Icons.home,
                  color: Colors.orange,
                ),
                onPressed: () {
                  // to navigate to any other page by using tabcontroller.
                  widget.tabController.animateTo(0);
                },
              ),
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                child: const Icon(
                  Icons.mail,
                  color: Colors.orange,
                ),
                onPressed: () {
                  // to navigate to any other page by using tabcontroller.
                  widget.tabController.animateTo(1);
                },
              ),
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                child: const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                onPressed: () {
                  // to navigate to any other page by using tabcontroller.
                  widget.tabController.animateTo(2);
                },
              ),
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                child: const Icon(
                  Icons.person,
                  color: Colors.orange,
                ),
                onPressed: () {
                  // to navigate to any other page by using tabcontroller.
                  widget.tabController.animateTo(3);
                },
              ),
            ],
          ),
        ));
  }
}