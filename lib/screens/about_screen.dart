import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "About",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                AppConfig.appName,
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'This App is developed and maintained by the Tonga Meteorological Service.',
              ),
              Image.asset(
                'assets/images/met_logo.jpg',
                width: 150.0,
                height: 150.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
