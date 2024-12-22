import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:macres/providers/dark_theme_provider.dart';
import 'package:macres/providers/event_counter_provider.dart';
import 'package:macres/providers/locale_provider.dart';
import 'package:macres/providers/tide_provider.dart';
import 'package:macres/providers/ten_days_provider.dart';
import 'package:macres/providers/three_hours_provider.dart';
import 'package:macres/providers/twentyfour_hours_provider.dart';
import 'package:macres/providers/user_provider.dart';
import 'package:macres/providers/warning_counter_provider%20copy.dart';
import 'package:macres/providers/weather_location.dart';
import 'package:macres/screens/tabs_screen.dart';
import 'package:macres/util/theme_styles.dart';
import 'package:macres/widgets/onboarding/onboarding_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vibration/vibration.dart';
import 'to_intl.dart';
import 'firebase_options.dart';

//Handle notification message in background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();

  //increase warning counter
  if (message.data['warning'] == '1') {
    int warningTotalCounter = 0;
    int currentTotalWarnings = prefs.getInt('total_new_warnings') ?? 0;
    warningTotalCounter = currentTotalWarnings + 1;
    prefs.setInt('total_new_warnings', warningTotalCounter);
  }

  //increase event counter
  if (message.data['event'] == '1') {
    int eventTotalCounter = 0;
    int currentTotalEvents = prefs.getInt('total_new_events') ?? 0;
    eventTotalCounter = currentTotalEvents + 1;
    prefs.setInt('total_new_events', eventTotalCounter);
  }

  if (message.notification != null) {
    // print('Message also contained a notification: ${message.notification}');
    //vibrate the device when receive message
    if (await Vibration.hasVibrator() != false) {
      Vibration.vibrate();
    }
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  if (showOnboarding == true) {
    prefs.setBool('showOnboarding', true);
  }

  await Firebase.initializeApp(
    name: 'macres',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  //set page orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(App(showOnboarding: showOnboarding)),
  );

  //runApp(App(showOnboarding: showOnboarding));
}

class App extends StatefulWidget {
  const App({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeProvider themeChangeProvider = new ThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.themePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => TenDaysProvider()),
        ChangeNotifierProvider(create: (context) => ThreeHoursProvider()),
        ChangeNotifierProvider(create: (context) => TwentyFourHoursProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TideProvider()),
        ChangeNotifierProvider(create: (context) => WeatherLocationProvider()),
        ChangeNotifierProvider(create: (context) => EventCounterProvider()),
        ChangeNotifierProvider(create: (context) => WarningCounterProvider()),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProvider, ThemeProvider, child) => MaterialApp(
          localizationsDelegates: const [
            ToMaterialLocalizations.delegate,
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('to'), Locale('en', 'US')],
          locale: localeProvider.selectedLocale,
          title: 'Tonga Weather App',
          theme: Styles.themeData(ThemeProvider.darkTheme, context),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: widget.showOnboarding
              ? const OnboardingPage()
              : const TabsScreen(),
        ),
      ),
    );
  }
}
