import 'package:flutter/material.dart';

class TkDetailsScreen extends StatefulWidget {
  const TkDetailsScreen({super.key});

  @override
  State<TkDetailsScreen> createState() => _TkDetailsScreenState();
}

class _TkDetailsScreenState extends State<TkDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
        foregroundColor: Colors.white,
        title: const Text('TK Indicator Details'),
        elevation: 0,
      ),
      body: Center(child: Text('TK Details here')),
    );
  }
}
