import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class EventReportScreen extends StatefulWidget {
  const EventReportScreen({super.key});

  @override
  State<EventReportScreen> createState() => _EventReportScreenState();
}

class _EventReportScreenState extends State<EventReportScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<http.Response> sendData() async {
    final title = titleController.text;
    final body = bodyController.text;
    const username = 'mobile_app';
    const password = 'intel13!';
    final basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));

    final response = await http.post(
      Uri.parse('http://met-api.lndo.site/api/v1/event-report?_format=json'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': basicAuth
      },
      body: json.encode([
        {"nodetype": "event_report", "title": title, "body": body}
      ]),
    );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Fill in the following fields, to report an event from your location. For exmaple:  If you see a fire, you can report it here.  If you see a smoke coming out from a Vocano.",
            style: TextStyle(fontSize: 13),
          ),
          TextFormField(
            controller: titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          TextFormField(
            controller: bodyController,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            decoration: const InputDecoration(
              label: Text('Enter the event details here'),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              const Spacer(),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  sendData();
                  showAlertDialog(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    //Button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Event Report Status"),
      content: const Text("Your event report has been received.  Thank you."),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
