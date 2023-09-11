import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/providers/locale_provider.dart';
import 'package:macres/providers/ten_days_provider.dart';
import 'package:macres/providers/three_hours_provider.dart';
import 'package:macres/providers/twentyfour_hours_provider.dart';
import 'package:macres/screens/tabs_screen.dart';
import 'package:macres/widgets/onboarding/onboarding_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'to_intl.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  if (showOnboarding == true) {
    prefs.setBool('showOnboarding', false);
  }

  await Firebase.initializeApp(
    name: 'MACRES',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App(showOnboarding: showOnboarding));
}

class App extends StatefulWidget {
  const App({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => TenDaysProvider()),
        ChangeNotifierProvider(create: (context) => ThreeHoursProvider()),
        ChangeNotifierProvider(create: (context) => TwentyFourHoursProvider())
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) => MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            ToMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('to'), Locale('en', 'US')],
          locale: localeProvider.selectedLocale,
          title: 'Tonga Weather App',
          theme: ThemeData(
            //fontFamily: GoogleFonts.openSans().fontFamily,
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color.fromARGB(255, 238, 235, 246),
            ),
          ).copyWith(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 133, 131, 131),
            ),
          ),
          home: widget.showOnboarding
              ? const OnboardingPage()
              : const TabsScreen(),
        ),
      ),
    );
  }
}
