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
    return Scaffold(body: _buildUI());
  }

  Widget _buildUI() {
    return SafeArea(
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Chào mừng bạn đến với ứng dụng cân sức khỏe thông minh",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              ElevatedButton(
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
            ],
          ),
        ),
      ),
    );
  }
}
