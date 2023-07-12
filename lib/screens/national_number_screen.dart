import 'package:flutter/material.dart';
import 'package:humanitarian_icons/humanitarian_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class NationalNumberScreen extends StatelessWidget {
  const NationalNumberScreen({super.key});

  Future _callThisNumber(String number) async {
    Uri url = Uri(scheme: "tel", path: number);
    print(url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('National number'),
      ),
      body: Column(
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  dense: true,
                  leading: const Icon(HumanitarianIcons.ambulance),
                  title: const Text('Ambulance'),
                  trailing: TextButton(
                    onPressed: () {
                      _callThisNumber('89332');
                    },
                    child: const Text('+676 89332'),
                  ),
                ),
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  dense: true,
                  leading: const Icon(Icons.local_police),
                  title: const Text('Police'),
                  trailing: TextButton(
                      onPressed: () {
                        _callThisNumber('89332');
                      },
                      child: const Text('+676 89332')),
                ),
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  dense: true,
                  leading: const Icon(
                    HumanitarianIcons.fire,
                    color: Colors.red,
                  ),
                  title: const Text('Fire'),
                  trailing: TextButton(
                    onPressed: () {
                      _callThisNumber('89332');
                    },
                    child: const Text('+676 89332'),
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
