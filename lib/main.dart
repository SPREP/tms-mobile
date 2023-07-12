import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macres/providers/locale_provider.dart';
import 'package:macres/screens/tabs_screen.dart';
import 'package:macres/widgets/onboarding/onboarding_page.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider())
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
                  )
              .copyWith(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 133, 131, 131),
            ),
          ),
          home: showOnboarding ? const OnboardingPage() : const TabsScreen(),
        ),
      ),
    );
  }
}
