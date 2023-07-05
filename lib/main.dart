import 'package:flutter/material.dart';
import 'package:macres/screens/weather_forcast/weather_forcast.dart';
import 'package:macres/widgets/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  var showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(App(showOnboarding: showOnboarding));
}

class App extends StatelessWidget {
  const App({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    print("showOnboarding: $showOnboarding");

    return MaterialApp(
      title: 'Tonga Weather App',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 148, 139, 92),
        ),
      ),
      home: showOnboarding ? const OnboardingPage() : const WeatherForcast(),
    );
  }
}
