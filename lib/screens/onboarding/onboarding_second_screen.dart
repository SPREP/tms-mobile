import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingSecondScreen extends StatefulWidget {
  const OnboardingSecondScreen({super.key});

  @override
  State<OnboardingSecondScreen> createState() {
    return _OnboardingSecondScreen();
  }
}

class _OnboardingSecondScreen extends State<OnboardingSecondScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'assets/images/onboarding2.png',
            fit: BoxFit.cover,
            height: size.height * 0.4,
            width: size.width,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
    );
  }
}
