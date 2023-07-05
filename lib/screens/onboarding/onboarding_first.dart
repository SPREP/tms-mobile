import 'package:flutter/material.dart';

class OnboardingFirst extends StatefulWidget {
  const OnboardingFirst({super.key});

  @override
  State<OnboardingFirst> createState() {
    return _OnboardingFirst();
  }
}

class _OnboardingFirst extends State<OnboardingFirst> {
  String? lang;
  final List<String> _locations = [
    'Select your location',
    'Tongatapu',
    'Vavau',
    'Haapai',
    'Eua',
    'Niuafoou',
    'Niuatoputapu'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Image.asset(
            'assets/images/onboarding1.png',
            fit: BoxFit.cover,
            height: size.height * 0.4,
            width: size.width,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: const [
                Text(
                  'Malo e lelei',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 145, 142, 142)),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome to Tonga weather App.',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 152, 150, 150)),
                ),
                SizedBox(height: 20),
                Text(
                  'Choose your language and location',
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
