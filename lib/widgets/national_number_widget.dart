import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macres/models/settings_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:macres/models/national_number_model.dart';

class NationalNumberWidget extends StatelessWidget {
  const NationalNumberWidget({super.key, required this.contactNumber});
  final dynamic contactNumber;

  @override
  Widget build(BuildContext context) {
    Future callThisNumber(String number) async {
      Uri url = Uri.parse('tel:$number');

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Column(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var contact in contactNumber.entries)
                if (contact.key.toString() == 'Location')
                  ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -3),
                    title: Text(
                      locationLabel[contact.value].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    tileColor: locationColor[contact.value],
                    textColor: Colors.white,
                  )
                else
                  ListTile(
                    onTap: () {
                      //callThisNumber('67689332');
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                    dense: true,
                    leading: categoryIcon[contact.key],
                    title: Text(
                      categoryLabel[contact.key].toString(),
                    ),
                    trailing: Text(
                      contact.value.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  )
            ],
          ),
        ),
      ],
    );
  }
}
