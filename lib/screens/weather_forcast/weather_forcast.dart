import 'package:flutter/material.dart';

class WeatherForcast extends StatelessWidget {
  const WeatherForcast({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forcast'),
      ),
      body: const Center(
        child: Text('Weather Forcast Content Here'),
      ),
    );
  }
}
