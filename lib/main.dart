import 'package:flutter/material.dart';
import 'package:macres/screens/weather_forcast/weather_forcast_screen.dart';
import 'package:macres/widgets/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'to_intl.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('showOnboarding', true);

  var showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(App(showOnboarding: showOnboarding));
}

class App extends StatelessWidget {
  const App({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ToMaterialLocalizations.delegate,
      ],
      supportedLocales: const [Locale('to'), Locale('en', 'US')],
      locale: const Locale('to'),
      title: 'Tonga Weather App',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 148, 139, 92),
        ),
      ),
      home: showOnboarding
          ? const OnboardingPage()
          : const WeatherForcastScreen(),
    );
  }
}
