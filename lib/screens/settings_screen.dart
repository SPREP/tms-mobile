import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macres/providers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/providers/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<FormState> userLocationKey = GlobalKey<FormState>();
  Location? _selectedLocation = Location.tongatapu;
  Language? _selectedLanguage = Language.en;

  bool light = true;

  late FirebaseMessaging fcmInstance;

  bool isError = false;

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    fcm.requestPermission();
    fcmInstance = fcm;
  }

  void initState() {
    getDefault();
    setupPushNotifications();
    super.initState();
  }

  void getDefault() async {
    final prefs = await SharedPreferences.getInstance();

    var location = prefs.getString('user_location');
    var language = prefs.getString('user_language');

    if (location != false) {
      _selectedLocation = LocationExtension.fromName(location);
    }

    if (language != false) {
      _selectedLanguage = LanguageExtension.fromName(language);
    }

    setState(() {});
  }

  void _saveSettings() async {
    //save values
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('user_location', _selectedLocation!.name.toString());
    prefs.setString('user_language', _selectedLanguage!.name.toString());

    //@TODO:

    //Push notification subscribe user
    fcmInstance.subscribeToTopic(_selectedLanguage!.name.toString());
    fcmInstance.subscribeToTopic(_selectedLocation!.name.toString());
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Row(children: [
          Icon(Icons.settings),
          SizedBox(width: 10),
          Text('Settings'),
        ]),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) => Row(
                children: [
                  Text("${localizations.onBoardingLanguage}:"),
                  Radio(
                    value: Language.en,
                    groupValue: _selectedLanguage,
                    onChanged: (val) {
                      setState(() {
                        _selectedLanguage = val;
                        localeProvider.setLocale(val!.name);
                      });
                    },
                  ),
                  Text(
                    languageLabel[Language.en].toString(),
                    style: const TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  Radio(
                    value: Language.to,
                    groupValue: _selectedLanguage,
                    onChanged: (val) {
                      setState(() {
                        _selectedLanguage = val;
                        localeProvider.setLocale(val!.name);
                      });
                    },
                  ),
                  Text(
                    languageLabel[Language.to].toString(),
                    style: const TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: userLocationKey,
              child: DropdownButtonFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: _selectedLocation,
                items: Location.values.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(locationLabel[value].toString()),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedLocation = val!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Dark Theme:'),
            CupertinoSwitch(
                value: themeChange.darkTheme,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  themeChange.darkTheme = value;
                }),
            const Divider(
              indent: 20,
              endIndent: 20,
              thickness: 0.5,
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _saveSettings();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
