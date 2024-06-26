import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tonner_app/app_data.dart';
import 'package:tonner_app/screens/add_toner/add_toner.dart';
import 'package:tonner_app/screens/authFlow/forgetPass.dart';
import 'package:tonner_app/screens/authFlow/signin.dart';
import 'package:tonner_app/screens/client/add_client.dart';
import 'package:tonner_app/screens/home/home.dart';
import 'package:tonner_app/screens/products/add_machine.dart';
import 'package:tonner_app/screens/products/machine.dart';
import 'package:tonner_app/screens/profile/profile.dart';
import 'package:tonner_app/screens/supply_chian/supplychain.dart';
import 'package:tonner_app/screens/user_privilege/user_privilege.dart';

import 'ThemeNotifier.dart';
import 'color/colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (context) => ThemeNotifier(
            ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                color: Colors.white,
                elevation: 0,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider<AppData>(
          create: (context) => AppData(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: true,
            theme: themeNotifier.currentTheme,
            home: const AuthProcess(),
            routes: {
              '/profile': (context) => const Profile(),
              '/home_screen': (context) => const HomeScreen(),
              '/add_client': (context) => AddClient(),
              '/add_machine': (context) => const AddMachine(),
              '/rq_view_tracesci': (context) => const QRViewTracesci(),
              '/add_toner': (context) => const AddToner(),
              '/user_privilege': (context) =>  UserPrivilege(),

            }
          /* routes: {
            '/report': (context) => const Report(),
          }, */
        );
      },
    );
  }
}