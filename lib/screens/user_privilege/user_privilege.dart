import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';

class UserPrivilege extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  title: const Text(
        "Users Privilege",
        style: TextStyle(
          fontSize: 24.0,
          color: colorMixGrad, // Replace with your colorSecondGrad
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          CreateUserCard(
            onTap: () {
              Navigator.pushNamed(context, '/create_user');

            },
          ),
          UserStatusCard(onTap: (){}),
          MachineStatusCard(onTap: (){}),
          AccessibilityCard(onTap: (){}),


        ]),
      ),
    );
  }
}

class CreateUserCard extends StatelessWidget {
  final VoidCallback onTap;

  const CreateUserCard({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      onTap: onTap,
      icon: Icons.person_add,
      title: 'Create User',
    );
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Colors.blueGrey[700],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MachineStatusCard extends StatelessWidget {
  final VoidCallback onTap;

  const MachineStatusCard({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      onTap: onTap,
      icon: Icons.settings,
      title: 'Machine Status',
    );
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Colors.blueGrey[700],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccessibilityCard extends StatelessWidget {
  final VoidCallback onTap;

  const AccessibilityCard({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      onTap: onTap,
      icon: Icons.accessibility,
      title: 'Accessibility',
    );
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Colors.blueGrey[700],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserStatusCard extends StatelessWidget {
  final VoidCallback onTap;

  const UserStatusCard({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      onTap: onTap,
      icon: Icons.person_outline,
      title: 'User Status',
    );
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Colors.blueGrey[700],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
