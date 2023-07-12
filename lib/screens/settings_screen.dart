import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() => runApp(const SettingsScreen());

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        title: Row(children: const [
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
            const Text('Language:'),
            const Divider(
              indent: 20,
              endIndent: 20,
              thickness: 0.5,
            ),
            const SizedBox(height: 10),
            const Text('Location:'),
            const Divider(
              indent: 20,
              endIndent: 20,
              thickness: 0.5,
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
            SizedBox(height: 50),
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
