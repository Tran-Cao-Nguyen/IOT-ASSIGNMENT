import 'package:flutter/material.dart';
import 'package:frontend/consts.dart';
import 'package:frontend/pages/ble_page.dart';
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
    const List<Map<String, dynamic>> dummyBodyMetrics = [
      {"name": "Weight", "value": 72.5, "unit": "Kg"},
      {"name": "BMI", "value": 23.4, "unit": ""},
      {"name": "BMR", "value": 1600, "unit": "kcal/day"},
      {"name": "TDEE", "value": 2200, "unit": "kcal/day"},
      {"name": "LBM", "value": 55.0, "unit": "kg"},
      {"name": "Fat %", "value": 18.5, "unit": "%"},
      {"name": "Water %", "value": 60.2, "unit": "%"},
      {"name": "Bone Mass", "value": 3.2, "unit": "kg"},
      {"name": "Muscle Mass", "value": 40.1, "unit": "kg"},
      {"name": "Protein %", "value": 16.0, "unit": "%"},
      {"name": "Visceral Fat", "value": 7.0, "unit": "kg"},
      {"name": "Ideal Weight", "value": 70.0, "unit": "kg"},
    ];

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
        "/ble-screen":
            (context) => const DisplayBodyMetricsScreen(bodyMetrics: dummyBodyMetrics),
      },
    );
  }
}
