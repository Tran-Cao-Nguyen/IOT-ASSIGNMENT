import 'package:flutter/material.dart';
import 'package:frontend/consts.dart';
// import 'package:frontend/pages/ble_page.dart';
import 'package:frontend/pages/edit_profile_page.dart';
import 'package:frontend/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'IOT App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: AppColors.mainColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/homepage',
      routes: {
        "/homepage": (context) => const Homepage(),
        "/edit-profile": (context) => const EditProfilePage(),
      },
    );
  }
}
