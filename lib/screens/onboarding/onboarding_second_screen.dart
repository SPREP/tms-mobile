import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

    fcm.subscribeToTopic(location!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100.0,
            ),
            Image.asset(
              'assets/images/onboarding2.png',
              fit: BoxFit.cover,
              height: 240.0,
              width: 240.0,
            ),
            Container(
              height: 430,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  Text(localizations.onBoardingHeadingText),
                  const SizedBox(height: 20),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem1),
                  ),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem2),
                  ),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem3),
                  ),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem4),
                  ),
                  ListTile(
                    horizontalTitleGap: 1,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem5),
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
