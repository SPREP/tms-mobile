import 'package:flutter/material.dart';

class RequestAssistanceForm extends StatefulWidget {
  const RequestAssistanceForm({super.key});

  @override
  State<RequestAssistanceForm> createState() => _RequestAssistanceFormState();
}

class _RequestAssistanceFormState extends State<RequestAssistanceForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Request Assitance form"),
      ),
    );
  }
}
