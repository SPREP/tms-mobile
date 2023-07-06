import 'package:flutter/material.dart';

class OnboardingSecond extends StatelessWidget {
  const OnboardingSecond({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
              children: const [
                Text(
                    'This app, allows you to report to us events. You can send us your post disaster impact report, request assistance and more.'),
                SizedBox(height: 20),
                ListTile(
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  title: Text('Let us know when you felt an earthquake'),
                ),
                ListTile(
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  title: Text('Receive Weather Forecast'),
                ),
                ListTile(
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  title: Text(
                      'Receive Critical Notifications and Alerts (Tsunami, Weather, Volcanic and more)'),
                ),
                ListTile(
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                  title: Text('Send Disaster Impact Report'),
                ),
                ListTile(
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
