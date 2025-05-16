import 'package:flutter/material.dart';
import 'package:frontend/consts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.superLightGray,
        title: const Text("Trang chủ"),
        centerTitle: true,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Center(
        child: SizedBox(
          width: 200,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/edit-profile');
            },
            child: Text("Bắt đầu", style: TextStyle(fontSize: 32)),
          ),
        ),
      ),
    );
  }
}
