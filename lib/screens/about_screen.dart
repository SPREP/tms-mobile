import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          child: Column(children: [
            Text(
              'This App is developed and maintained by the Tonga Meteorological Service.',
            ),
            Image.asset(
              'assets/images/met_logo.jpg',
              width: 150.0,
              height: 150.0,
            ),
          ]),
        ),
      ),
    );
  }
}
