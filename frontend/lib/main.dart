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
    const List<Map<String, dynamic>> dummyBodyMetrics =  [
    {
      "key": "Weight",
      "name": "Cân nặng",
      "value": 72.5,
      "unit": "Kg"
    },
    {
      "key": "BMI",
      "name": "Chỉ số khối (BMI)",
      "value": 23.67,
      "unit": ""
    },
    {
      "key": "BMR",
      "name": "Tỉ lệ trao đổi chất (BMR)",
      "value": 1757.54,
      "unit": "kcal/ngày"
    },
    {
      "key": "TDEE",
      "name": "Năng lượng tiêu hao (TDEE)",
      "value": 2724.19,
      "unit": "kcal/ngày"
    },
    {
      "key": "LBM",
      "name": "Khối lượng không mỡ (LBM)",
      "value": 53.63,
      "unit": "kg"
    },
    {
      "key": "Fat %",
      "name": "Tỉ lệ mỡ",
      "value": 20.78,
      "unit": "%"
    },
    {
      "key": "Water %",
      "name": "Tỉ lệ nước",
      "value": 43.57,
      "unit": "%"
    },
    {
      "key": "Bone Mass",
      "name": "Khối lượng xương",
      "value": 9.39,
      "unit": "kg"
    },
    {
      "key": "Muscle Mass",
      "name": "Khối lượng cơ",
      "value": 48.04,
      "unit": "kg"
    },
    {
      "key": "Protein %",
      "name": "Tỉ lệ protein",
      "value": 19.56,
      "unit": "%"
    },
    {
      "key": "Visceral Fat",
      "name": "Mỡ nội tạng",
      "value": 8.54,
      "unit": "kg"
    },
    {
      "key": "Ideal Weight",
      "name": "Cân nặng lý tưởng",
      "value": 70.46,
      "unit": "kg"
    },
    {
      "overall": {
        "status": "Thừa cân",
        "evaluation": [
          "BMI (23.67): Thừa cân - Bạn có nguy cơ về sức khỏe nếu không kiểm soát cân nặng",
          "Độ tuổi: Thanh niên/Trưởng thành - Sức khỏe thường ổn định",
          "Giới tính: Nam - Thường có cơ bắp nhiều hơn",
          "Chủng tộc: Châu Á - Áp dụng ngưỡng sức khỏe phù hợp"
        ],
        "recommendations": [
          "Giảm cân bằng chế độ ăn và tập thể dục"
        ],
        "overall_status": "Sức khỏe tổng quan: Khá ổn - Theo dõi và điều chỉnh nếu cần"
      }
    }
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
      initialRoute: "/homepage",
      routes: {
        "/homepage": (context) => const Homepage(),
        "/edit-profile": (context) => const EditProfilePage(),
        // "/ble-screen":
        //     (context) => const DisplayBodyMetricsScreen(bodyMetrics: dummyBodyMetrics),
      },
    );
  }
}
