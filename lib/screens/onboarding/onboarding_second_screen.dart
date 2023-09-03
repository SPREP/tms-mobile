import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macres/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSecondScreen extends StatefulWidget {
  const OnboardingSecondScreen({super.key});

  @override
  State<OnboardingSecondScreen> createState() {
    return _OnboardingSecondScreen();
  }
}

class _OnboardingSecondScreen extends State<OnboardingSecondScreen> {
  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    final prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('user_location');

    // fcm.subscribeToTopic(location);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/onboarding2.png',
              fit: BoxFit.cover,
              height: size.height * 0.4,
              width: size.width,
            ),
            Container(
              height: 400,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context).onBoardingHeadingText),
                  const SizedBox(height: 20),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(AppLocalizations.of(context).onBoardListItem1),
                  ),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(AppLocalizations.of(context).onBoardListItem2),
                  ),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(AppLocalizations.of(context).onBoardListItem3),
                  ),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(AppLocalizations.of(context).onBoardListItem4),
                  ),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(AppLocalizations.of(context).onBoardListItem5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
