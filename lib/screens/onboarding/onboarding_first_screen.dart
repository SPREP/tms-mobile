import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macres/models/settings_model.dart';

class OnboardingFirstScreen extends StatefulWidget {
  const OnboardingFirstScreen(
      {super.key,
      required this.validateLocation,
      required this.validateLanguage,
      required this.userLocationKey});

  final void Function(String) validateLocation;
  final void Function(Language) validateLanguage;
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
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 100.0,
              ),
              Container(
                width: 130.0,
                height: 130.0,
                child: Image.asset(
                  "assets/images/mob_logo.png",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 400,
                padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                child: Column(
                  children: [
                    Text(
                      // localizations.onBoardingSubtitle,
                      AppConfig.appName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      localizations.onBoardingUnderSubtitle,
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Consumer<LocaleProvider>(
                        builder: (context, localeProvider, child) => Row(
                          children: [
                            Text("${localizations.onBoardingLanguage}:"),
                            Radio(
                              value: Language.en,
                              groupValue: _selectedLanguage,
                              onChanged: (val) {
                                widget.validateLanguage(val!);
                                setState(() {
                                  _selectedLanguage = val;

                                  if (val == null) return;

                                  localeProvider.setLocale(val.name);
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
                                widget.validateLanguage(val!);
                                setState(() {
                                  _selectedLanguage = val;

                                  if (val == null) return;

                                  localeProvider.setLocale(val.name);
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
                          widget.validateLocation(val!.name.toString());
                          setState(() {
                            _selectedLocation = val!;
                          });
                        },
                        validator: (val) {
                          if (val == null) {
                            String errMsg = "";
                            setState(() {
                              errMsg = AppLocalizations.of(context)!
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    child: Image.asset(
                      "assets/images/coa_tonga.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  Container(
                    width: 110.0,
                    height: 110.0,
                    child: Image.asset(
                      "assets/images/met_logo.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
