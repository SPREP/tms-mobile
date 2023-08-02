import 'package:flutter/material.dart';

class ImpactReportForm extends StatefulWidget {
  const ImpactReportForm({super.key});

  @override
  State<ImpactReportForm> createState() => _ImpactReportFormState();
}

class _ImpactReportFormState extends State<ImpactReportForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Impact report form here'),
      ),
    );
  }
}
