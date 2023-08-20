import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macres/models/settings_model.dart';

void main() => runApp(const SettingsScreen());

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<FormState> userLocationKey = GlobalKey<FormState>();
  Location _selectedLocation = Location.tongatapu;
  Language? _selectedLanguage = Language.en;
  double _value = 50.0;
  bool light = true;

  void _saveSettings() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Row(children: [
          Icon(Icons.settings),
          SizedBox(width: 10),
          Text('Settings'),
        ]),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Consumer(
              builder: (context, localeProvider, child) => Row(
                children: [
                  Text("${AppLocalizations.of(context).onBoardingLanguage}:"),
                  Radio(
                    value: Language.en,
                    groupValue: _selectedLanguage,
                    onChanged: (val) {
                      setState(() {
                        _selectedLanguage = val;

                        if (val == null) return;
                        int idx = val.toString().indexOf(".") + 1;
                        //localeProvider
                        //    .setLocale(val.toString().substring(idx).trim());
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
                        //localeProvider
                        //   .setLocale(val.toString().substring(idx).trim());
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
            const SizedBox(height: 20),
            Form(
              key: userLocationKey,
              child: DropdownButtonFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: _selectedLocation,
                items: Location.values.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(locationLabel[value].toString()),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedLocation = val!;
                  });
                },
                validator: (val) {
                  /*  if (val == Location.select) {
                    String errMsg = "";
                    setState(() {
                      errMsg =
                          AppLocalizations.of(context).onBoardingLocationError;
                    });
                    return errMsg;
                  } */
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Dark Theme:'),
            Switch(
                value: light,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  setState(() {
                    light = value;
                  });
                }),
            const Divider(
              indent: 20,
              endIndent: 20,
              thickness: 0.5,
            ),
            const SizedBox(height: 10),
            const Text('Font Size:'),
            SfSlider(
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                stepSize: 50.0,
                min: 0.0,
                max: 100.0,
                interval: 50,
                value: _value,
                onChanged: (dynamic value) {
                  setState(() {
                    _value = value;
                  });
                }),
            const SizedBox(height: 50),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _saveSettings();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
