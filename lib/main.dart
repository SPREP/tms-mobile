import 'package:flutter/material.dart';
import 'package:macres/screens/weather_forcast/weather_forcast.dart';
import 'package:macres/widgets/onboarding/onboarding_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tonga Weather App',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 148, 139, 92),
        ),
      ),
      home: const OnboardingPage(),
    );
  }
}
