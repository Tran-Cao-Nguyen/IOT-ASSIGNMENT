import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:frontend/services/http_services.dart';

class DisplayBodyMetricsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bodyMetrics;

  const DisplayBodyMetricsScreen({Key? key, required this.bodyMetrics})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bodyMetrics.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Body Metrics'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(
          child: Text(
            'No body metrics available.',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Body Metrics'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: bodyMetrics.length,
          itemBuilder: (context, index) {
            final metric = bodyMetrics[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metric['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${metric['value'] ?? ''} ${metric['unit'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.fitness_center,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
class BluetoothConnectionScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const BluetoothConnectionScreen({super.key, required this.userData});

  @override
  State<BluetoothConnectionScreen> createState() =>
      _BluetoothConnectionScreenState();
}

class _BluetoothConnectionScreenState
    extends State<BluetoothConnectionScreen> {
  BluetoothDevice? miScale;
  bool _isConnecting = true;
  bool _isConnected = false;
  bool _finishGetingWeight = false;
  double _weight = 0.0;
  late Map<String, dynamic> userData;

  final Guid serviceUuid = Guid('0000181d-0000-1000-8000-00805f9b34fb');
  final Guid characteristicUuid = Guid('00002a9d-0000-1000-8000-00805f9b34fb');

  @override
  void initState() {
    super.initState();
    userData = Map<String, dynamic>.from(widget.userData); // Tạo bản sao dữ liệu user
    startScan();
  }

  @override
  void dispose() {
    super.dispose();
    miScale?.disconnect();
  }

  void startScan() {
    if (!_isConnected) {
      FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 30),
        withNames: ["MI SCALE2"],
      );

      Future.delayed(const Duration(seconds: 30), () {
        if (!_isConnected) {
          setState(() {
            _isConnecting = false;
            print("MI SCALE 2 not found.");
          });
        }
      });

      FlutterBluePlus.scanResults.listen((results) {
        if (results.isNotEmpty) {
          ScanResult scaleResult = results.last;

          if (scaleResult.device.platformName == "MI SCALE2") {
            print('Device found: ${scaleResult.device.platformName}');
            miScale = scaleResult.device;
            FlutterBluePlus.stopScan();
            connectToDevice(scaleResult.device);

            setState(() {
              _isConnecting = false;
              _isConnected = true;
            });
          }
        }
      });
    }
  }

  Future<void> processReceivedData(List<int> data) async {
    int weightValue = (data[1] | (data[2] << 8));
    double weight = weightValue / 200;

    bool isWeightStable = (data[0] & (1 << 5)) != 0;
    bool isWeightRemoved = (data[0] & (1 << 7)) != 0;

    if (isWeightStable && !isWeightRemoved) {
      try {
        await miScale?.disconnect(); // Ngắt kết nối khi cân xong
        setState(() {
          _finishGetingWeight = true;
          _weight = weight;
        });
      } catch (e) {
        print('Error disconnecting device: $e');
      }
    }

    print("Weight: ${weight.toStringAsFixed(2)} kg");

    setState(() {
      _weight = weight;
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      print('Connected to ${device.platformName}');

      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid == characteristicUuid) {
            print('Found characteristic with UUID: ${characteristic.uuid}');
            characteristic.setNotifyValue(true);
            characteristic.lastValueStream.listen((value) {
              if (value.isNotEmpty) {
                processReceivedData(value);
              }
            });
          }
        }
      }
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  // Hàm gửi dữ liệu lên server và trả về kết quả phân tích chỉ số cơ thể
  Future<Map<String, dynamic>?> _sendData() async {
    userData['weight'] = _weight;
    try {
      final response = await HttpServices().post('/metrics', data: userData);
      if (response != null && response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error sending weight data: $e');
    }
    return null;
  }

  // Hàm xử lý sau khi lấy được cân nặng
  Future<void> _handleFinishWeight() async {
    final res = await _sendData(); // Gửi lên server
    if (res != null && mounted) {
      // mounted để đảm bảo widget chưa bị huỷ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayBodyMetricsScreen(bodyMetrics: res['metrics']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Khi đang kết nối Bluetooth
    if (_isConnecting) {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(color: Colors.lightBlue),
                    ),
                    Image.asset(
                      'assets/img/miscale2.png',
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Connecting to MI SCALE 2',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
                const Text(
                  'Please step on the scale',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Khi đã cân xong
    if (_finishGetingWeight) {
      _finishGetingWeight = false; // Đánh dấu đã xử lý
      _handleFinishWeight(); // Gửi dữ liệu và điều hướng
    }

    // Khi đã kết nối và chưa gửi dữ liệu
    if (_isConnected) {
      return WeightDisplayScreen(
        weight: _weight,
      );
    } else {
      return const CannotConnectScreen();
    }
  }
}



class CannotConnectScreen extends StatelessWidget {
  const CannotConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(""),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.bluetooth_disabled_rounded,
                size: 50, // Adjust size
                color: Colors.red, // Adjust color
              ),
              SizedBox(height: 20),
              Text(
                'Cannot connect to MI SCALE 2',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                'Please try again',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                  fontFamily: 'Roboto',
                ),
              ),
              // ElevatedButton(
              //   child: const Text('Retry'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeightDisplayScreen extends StatefulWidget {
  final double weight; // Receive the weight variable from the parent

  const WeightDisplayScreen({super.key, required this.weight});

  @override
  _WeightDisplayScreenState createState() => _WeightDisplayScreenState();
}

class _WeightDisplayScreenState extends State<WeightDisplayScreen>
    with SingleTickerProviderStateMixin {
  // Mix in the ticker provider
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller for spinning effect
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Repeats infinitely
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glowing and spinning circle around the weight
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Spinning circular progress indicator with a glowing effect
                    Transform.rotate(
                      angle: _animationController.value * 2 * pi,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.7),
                            width: 6,
                          ),
                        ),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blueAccent.withOpacity(0.5),
                          ),
                          strokeWidth: 5,
                          backgroundColor: Colors.transparent,
                          value: null,
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.weight} ', // Weight part
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Kg', // Smaller "Kg"
                            style: TextStyle(
                              fontSize: 20, // Smaller font size for "Kg"
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
