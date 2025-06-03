# Project Name

# IoT Health Scale Project

## Overview
This IoT project leverages an electronic health scale to collect and analyze body metrics such as weight, body fat percentage, muscle mass, and BMI (Body Mass Index). The system integrates the health scale with a backend server and a mobile front end to provide real-time data tracking, storage, and visualization of health metrics. The data is transmitted via IoT protocols (e.g., MQTT or HTTP) to a cloud-based server for processing and storage, enabling users to monitor their health trends through a Flutter-based mobile application.

The project aims to deliver a seamless user experience for health-conscious individuals, offering insights into their body metrics and personalized health recommendations based on the collected data.

## Key Features
- **Real-time Data Collection**: The electronic health scale measures body metrics and sends data to the backend instantly.
- **Data Processing**: The backend calculates key health indicators (e.g., BMI, body fat percentage) using standardized formulas.
- **Mobile Application**: A Flutter-based front end displays health metrics and trends in an intuitive interface.
- **Cloud Integration**: Data is securely stored and processed in the cloud for long-term tracking and analysis.
- **IoT Connectivity**: Utilizes MQTT protocols for reliable communication between the health scale and the backend.

## System Architecture
- **Hardware**: Electronic health scale equipped with sensors (e.g., load cells, bioelectrical impedance analysis) and an IoT module (e.g., ESP32 or Raspberry Pi).
- **Backend**: Node.js-based server for handling data processing, storage (e.g., MongoDB or PostgreSQL), and API endpoints.
- **Frontend**: Flutter mobile app for user interaction, data visualization, and health insights.
- **Communication**: IoT protocols (MQTT) ensure secure and efficient data transfer between the scale, backend, and mobile app.

## Objectives
- Provide accurate and real-time body metric tracking for users.
- Enable users to monitor health trends and receive actionable insights.
- Ensure data privacy and security through encrypted communication and storage.
- Create a scalable and extensible system for future integration with other health devices.

## Potential Use Cases
- Personal health monitoring for fitness enthusiasts.
- Integration with healthcare systems for remote patient monitoring.
- Data aggregation for research on population health trends.

## Requirements
- Node.js and npm (for backend)
- Flutter and Dart (for frontend)
- IoT hardware (e.g., ESP32, health scale sensors)
- Cloud service (e.g., AWS, Google Cloud) for data storage and processing
- Android Studio (for emulator testing, if needed)
- Mobile device with USB cable (optional, for testing)

## Installation and Running Instructions

### 1. Back End
1. Clone the repository to your local machine:
   ```bash
   git clone <repository_url>
   ```
2. Navigate to the back end directory:
   ```bash
   cd backend
   ```
3. Install dependencies:
   ```bash
   npm install
   ```
4. Start the server:
   ```bash
   npm start
   ```

### 2. Front End
1. Navigate to the front end directory:
   ```bash
   cd ../frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Locate the `main.dart` file in the `lib/` directory.
4. Run the application:
   - **If you have a mobile device**: Connect it via USB cable, ensure USB Debugging is enabled, then run:
     ```bash
     flutter run
     ```
   - **If no mobile device is available**: Open Android Studio, set up and run an emulator, then run:
     ```bash
     flutter run
     ```

## Notes
- Ensure the back end is running before starting the front end.
- Ensure the device or emulator is compatible with the Flutter version in use.

## Troubleshooting
- If the back end fails to start, verify that the required ports are free and Node.js is correctly installed.
- If the front end fails to run, ensure Flutter is properly configured and the correct device/emulator is selected.
- For further assistance, check the official documentation for [Node.js](https://nodejs.org/) and [Flutter](https://flutter.dev/).

## Contributing
To contribute to this project, please fork the repository, create a new branch, and submit a pull request with your changes.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.
