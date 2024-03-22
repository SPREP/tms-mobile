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
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          child: Column(children: [
            Text(
              'About this App',
              maxLines: 100,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
      ),
    );
  }
}
