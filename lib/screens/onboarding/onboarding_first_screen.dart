import 'package:flutter/material.dart';
import 'package:macres/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macres/models/settings_model.dart';

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

class _OnboardingFirstScreen extends State<OnboardingFirstScreen> {
  Location? _selectedLocation;
  Language? _selectedLanguage = Language.en;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
                  "Malo e lelei",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 145, 142, 142)),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context).onBoardingSubtitle,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 152, 150, 150)),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context).onBoardingUnderSubtitle,
                ),
                const SizedBox(height: 20),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Consumer<LocaleProvider>(
                    builder: (context, localeProvider, child) => Row(
                      children: [
                        Text(
                            "${AppLocalizations.of(context).onBoardingLanguage}:"),
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

                              if (val == null) return;
                              int idx = val.toString().indexOf(".") + 1;
                              localeProvider.setLocale(
                                  val.toString().substring(idx).trim());
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
                ),
                const SizedBox(height: 20),
                Form(
                  key: widget.userLocationKey,
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 155, 153, 153),
                      ),
                    )),
                    hint: const Text('Select your location'),
                    value: _selectedLocation,
                    items: Location.values.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(locationLabel[value].toString()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      widget.validateLocation(val.toString());
                      setState(() {
                        _selectedLocation = val!;
                      });
                    },
                    validator: (val) {
                      if (val == null) {
                        String errMsg = "";
                        setState(() {
                          errMsg = AppLocalizations.of(context)
                              .onBoardingLocationError;
                        });
                        return errMsg;
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
