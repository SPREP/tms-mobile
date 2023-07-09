import 'package:flutter/material.dart';
import 'package:macres/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class OnboardingFirstScreen extends StatefulWidget {
  const OnboardingFirstScreen(
      {super.key,
      required this.validateLocation,
      required this.userLocationKey});

  final void Function(String) validateLocation;
  final GlobalKey<FormState> userLocationKey;

  @override
  State<OnboardingFirstScreen> createState() {
    return _OnboardingFirstScreen();
  }
}

//language
enum Language { to, en }

class _OnboardingFirstScreen extends State<OnboardingFirstScreen> {
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
  Language? _selectedLanguage = Language.en;

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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Consumer<LocaleProvider>(
                    builder: (context, localeProvider, child) => Row(
                      children: [
                        const Text('Language: '),
                        Radio(
                          value: Language.en,
                          groupValue: _selectedLanguage,
                          onChanged: (val) {
                            setState(() {
                              _selectedLanguage = val;

                              if (val == null) return;
                              int idx = val.toString().indexOf(".") + 1;
                              localeProvider.setLocale(
                                  val.toString().substring(idx).trim());
                            });
                          },
                        ),
                        const Text(
                          'English',
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        Radio(
                          value: Language.to,
                          groupValue: _selectedLanguage,
                          onChanged: (val) {
                            setState(() {
                              _selectedLanguage = val;

                              if (val == null) return;
                              int idx = val.toString().indexOf(".") + 1;
                              localeProvider.setLocale(
                                  val.toString().substring(idx).trim());
                            });
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
                ),
                const SizedBox(height: 20),
                Form(
                  key: widget.userLocationKey,
                  child: DropdownButtonFormField(
                    value: _selectedLocation,
                    items: _locations.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      widget.validateLocation(val!);
                      setState(() {
                        _selectedLocation = val.toString();
                      });
                    },
                    validator: (val) {
                      if (val == 'Select your location') {
                        return 'Please select your location';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
