import 'package:flutter/material.dart';
import 'package:frontend/consts.dart';
import 'package:frontend/pages/ble_page.dart';
// import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  // final _fullnameController = TextEditingController();
  final _heightController = TextEditingController();
  String? _birthDateError;

  // final _weightController = TextEditingController(); // Thêm controller cho cân nặng
  String? _selectedRace;
  String? _selectedGender;
  DateTime? _selectedDate;
  double? _selectedActivityFactor;

  final List<String> _genderOptions = ['Nam', 'Nữ'];
  final List<String> _raceOptions = ['Châu Á', 'Khác'];
  final List<Map<String, double>> _activityFactorOptions = [
    {"Ít hoạt động": 1.2},
    {"Vận động nhẹ": 1.375},
    {"Vận động vừa": 1.55},
    {"Vận động nhiều": 1.725},
    {"Vận động rất nhiều": 1.9},
  ];

  @override
  void initState() {
    super.initState();
    // Gọi hàm lấy thông tin người dùng khi trang được tải
  }

  // bool isAnyFieldFilled() {
  //   return _fullnameController.text.isNotEmpty ||
  //       _heightController.text.isNotEmpty ||
  //       _weightController.text.isNotEmpty ||
  //       _selectedGender != null ||
  //       _selectedDate != null;
  // }

  @override
  Widget build(BuildContext context) {
    // if (user == null) {
    //   return const Center(
    //     child:
    //         CircularProgressIndicator(), // Hiển thị vòng xoay khi chưa có dữ liệu
    //   );
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.superLightGray,
        title: const Text("Chỉnh sửa hồ sơ"),
        centerTitle: true,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: const BoxDecoration(color: AppColors.superLightGray),
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Giới tính
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  border: OutlineInputBorder(),
                ),
                value: _selectedGender == "male" ? "Nam" : "Nữ",
                items:
                    _genderOptions
                        .map(
                          (gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value == "Nam" ? "male" : "female";
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn giới tính';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Chủng tộc
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Chủng tộc',
                  border: OutlineInputBorder(),
                ),
                value: _selectedRace == "asian" ? "Châu Á" : "Khác",
                items:
                    _raceOptions
                        .map(
                          (race) =>
                              DropdownMenuItem(value: race, child: Text(race)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRace = value == "Châu Á" ? "asian" : "caucasian";
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn giới tính';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Ngày sinh
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _birthDateError = null; // reset lỗi khi chọn ngày
                    });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Ngày sinh',
                        border: OutlineInputBorder(),
                        errorText: _birthDateError, // hiển thị lỗi
                      ),
                      child: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Chọn ngày sinh',
                        style: TextStyle(
                          color:
                              _selectedDate != null
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Chiều cao
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Chiều cao (cm)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập chiều cao';
                  }
                  if (value.isNotEmpty && double.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // // // Cân nặng
              // TextFormField(
              //   controller: _weightController,
              //   keyboardType: TextInputType.number,
              //   decoration: const InputDecoration(
              //     labelText: 'Cân nặng (kg)',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Vui lòng nhập cân nặng';
              //     }
              //     if (value.isNotEmpty && double.tryParse(value) == null) {
              //       return 'Vui lòng nhập số hợp lệ';
              //     }

              //     return null;
              //   },
              // ),
              // const SizedBox(height: 16),

              // Mức độ hoạt động
              DropdownButtonFormField<double>(
                decoration: const InputDecoration(
                  labelText: 'Mức độ hoạt động',
                  border: OutlineInputBorder(),
                ),
                value: _selectedActivityFactor,
                items:
                    _activityFactorOptions.map((factor) {
                      // Lấy key và value từ map
                      String activityLevel = factor.keys.first; // Key
                      double factorValue = factor.values.first; // Value

                      return DropdownMenuItem<double>(
                        value: factorValue, // Set giá trị value là kiểu double
                        child: Text(
                          activityLevel,
                        ), // Hiển thị key (mức độ hoạt động)
                      );
                    }).toList(),
                onChanged: (double? value) {
                  setState(() {
                    _selectedActivityFactor = value; // Cập nhật giá trị
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn mức độ hoạt động';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Nút lưu
              ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(150, 50)),
                onPressed: () {
                  setState(() {
                    _birthDateError =
                        _selectedDate == null
                            ? 'Vui lòng chọn ngày sinh'
                            : null;
                  });

                  if (_formKey.currentState!.validate() && _birthDateError == null) {
                    var data = {
                      // "fullName": _fullnameController.text,
                      "dateOfBirth": _selectedDate?.toIso8601String(),
                      "gender": _selectedGender,
                      "race": _selectedRace,
                      "height": _heightController.text,
                      // "weight": _weightController.text,
                      "activityFactor": _selectedActivityFactor,
                    };

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                BluetoothConnectionScreen(userData: data),
                      ),
                    );
                  }
                },
                child: const Text('Xác nhận'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
