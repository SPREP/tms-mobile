import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Info'),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
        child: Column(children: [
          Text(
            'Phone: ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text('24/7 Toll Free Number (For Digicel or Ucall): 0800 638'),
          SizedBox(
            height: 10,
          ),
          Text('General Inquiry:740 0062'),
          SizedBox(
            height: 10,
          ),
          Text('Weather Forecasts: 35 009'),
          SizedBox(
            height: 10,
          ),
          Text('Ship Trip Report: 7400093'),
          SizedBox(
            height: 10,
          ),
          Text('Fax: 35 123'),
          SizedBox(
            height: 30,
          ),
          Text(
            'Email: ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text('metstaff@met.gov.to'),
          SizedBox(
            height: 30,
          ),
          Text(
            'Facebook Page:',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text('https://www.facebook.com/tongametservice/'),
        ]),
      ),
    );
  }
}
