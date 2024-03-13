import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/models/national_number_model.dart';

class NationalNumberWidget extends StatelessWidget {
  const NationalNumberWidget({super.key, required this.contactNumber});
  final dynamic contactNumber;

  Future callThisNumber(String number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } on Exception catch (_, e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  for (var n = 0; n < contact.value.length; n++)
                    ListTile(
                      onTap: () {
                        callThisNumber(contact.value[n].toString());
                      },
                      visualDensity: const VisualDensity(vertical: -3),
                      dense: true,
                      leading: categoryIcon[contact.key],
                      title: Text(
                        categoryLabel[contact.key].toString(),
                      ),
                      trailing: Text(
                        contact.value[n].toString(),
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
