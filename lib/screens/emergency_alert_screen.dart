import 'package:flutter/material.dart';

class EmergencyAlertScreen extends StatefulWidget {
  const EmergencyAlertScreen({super.key});

  @override
  State<EmergencyAlertScreen> createState() => _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState extends State<EmergencyAlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Alert'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Text('content here'),
            ],
          ),
        ),
      ),
    );
  }
}
