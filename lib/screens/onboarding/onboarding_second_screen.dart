import 'package:flutter/material.dart';

class OnboardingSecondScreen extends StatefulWidget {
  const OnboardingSecondScreen({super.key, required this.userSelectedLanguage});

  final String userSelectedLanguage;

  @override
  State<OnboardingSecondScreen> createState() {
    return _OnboardingSecondScreen();
  }
}

class _OnboardingSecondScreen extends State<OnboardingSecondScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String lang = widget.userSelectedLanguage;
    String strLang = lang == 'Language.tongan'
        ? 'Koe App ko eni teke lava lipooti mai ai ngaahi fakatamaki.'
        : 'This app, allows you to report to us events. You can send us your post disaster impact report, request assistance and more.';
    print(lang);

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                Text(strLang),
                const SizedBox(height: 20),
                const ListTile(
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  title: Text('Let us know when you felt an earthquake'),
                ),
                const ListTile(
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  title: Text('Receive Weather Forecast'),
                ),
                const ListTile(
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  title: Text(
                      'Receive Critical Notifications and Alerts (Tsunami, Weather, Volcanic and more)'),
                ),
                const ListTile(
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  title: Text('Send Disaster Impact Report'),
                ),
                const ListTile(
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  title: Text('Send Assitance Request'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
