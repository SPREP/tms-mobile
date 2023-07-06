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

  String _selectedLocation = 'Select your location';

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
              children: [
                const Text(
                  'Malo e lelei',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 145, 142, 142)),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to Tonga weather App.',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 152, 150, 150)),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Choose your language and location',
                ),
                const SizedBox(height: 20),
                const Divider(),
                Container(
                  child: Row(
                    children: [
                      const Text('Language: '),
                      Radio(
                        value: 1,
                        groupValue: 'lang',
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      const Text(
                        'English',
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      Radio(
                        value: 2,
                        groupValue: 'lang',
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      const Text(
                        'Tongan',
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton(
                  value: _selectedLocation,
                  items: _locations.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedLocation = val.toString();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
