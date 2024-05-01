import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macres/util/user_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSecondScreen extends StatefulWidget {
  const OnboardingSecondScreen({super.key});

  @override
  State<OnboardingSecondScreen> createState() {
    return _OnboardingSecondScreen();
  }
}

class _OnboardingSecondScreen extends State<OnboardingSecondScreen> {
  UserLocation ul = new UserLocation();

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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.onBoardingHeadingText,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    horizontalTitleGap: 5,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem1),
                  ),
                  ListTile(
                    horizontalTitleGap: 5,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem2),
                  ),
                  ListTile(
                    horizontalTitleGap: 5,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem3),
                  ),
                  ListTile(
                    horizontalTitleGap: 5,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem4),
                  ),
                  ListTile(
                    horizontalTitleGap: 5,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem5),
                  ),
                  ListTile(
                    horizontalTitleGap: 5,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem6),
                  ),
                  ListTile(
                    horizontalTitleGap: 5,
                    leading: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(localizations.onBoardListItem7),
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
