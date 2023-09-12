import 'package:flutter/material.dart';
import 'package:macres/widgets/national_number_widget.dart';
import 'package:macres/models/national_number_model.dart';
import 'package:macres/models/settings_model.dart';

class NationalNumberScreen extends StatelessWidget {
  const NationalNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tongatapuNumbers = {
      Location: Location.tongatapu,
      Category.majestyArmedForces: ["+676 926", "+676 23099"],
      Category.police: ["+676 922", "+676 23406"],
      Category.fire: ["+676 999", "+676 927", "+676 928", "+676 7401064"],
      Category.hospital: ["+676 933", "+676 7400200", "+676 7400403"],
      Category.wccc: ["+676 22240"],
    };

    const haapaiNumbers = {
      Location: Location.haapai,
      Category.majestyArmedForces: ["+676 60700"],
      Category.police: ["+676 60222", "+676 60544"],
      Category.fire: ["+676 60771"],
      Category.hospital: ["+676 60203"],
      Category.wccc: ["+676 60444"],
    };

    const vavauNumbers = {
      Location: Location.vavau,
      Category.majestyArmedForces: ["+676 70722", "+676 70499"],
      Category.police: ["+676 999", "+676 70233"],
      Category.fire: ["+676 70699"],
      Category.hospital: ["+676 933", "+676 70201"],
      Category.wccc: ["+676 70120"],
    };

    const niuafoouNumbers = {
      Location: Location.niuafoou,
      Category.wccc: ["+676 7581697"],
      Category.police: ["+676 80007"],
      Category.fire: ["+676 80007"],
      Category.hospital: ["+676 80100"]
    };

    const niuatoputapuNumbers = {
      Location: Location.niuatoputapu,
      Category.police: ["+676 7585030"],
      Category.fire: ["+676 7585180"],
      Category.hospital: ["+676 7585605"]
    };

    const euaNumbers = {
      Location: Location.eua,
      Category.majestyArmedForces: ["+676 50129"],
      Category.police: ["+676 50112", "+676 50313"],
      Category.fire: ["+676 50561"],
      Category.hospital: ["+676 50111"],
      Category.wccc: ["+676 7320547"],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('National number'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 30)),
            Text("Just tap the number you want to call"),
            SizedBox(height: 10),
            NationalNumberWidget(contactNumber: tongatapuNumbers),
            SizedBox(height: 10),
            NationalNumberWidget(contactNumber: haapaiNumbers),
            SizedBox(height: 10),
            NationalNumberWidget(contactNumber: vavauNumbers),
            SizedBox(height: 10),
            NationalNumberWidget(contactNumber: niuafoouNumbers),
            SizedBox(height: 10),
            NationalNumberWidget(contactNumber: niuatoputapuNumbers),
            SizedBox(height: 10),
            NationalNumberWidget(contactNumber: euaNumbers),
            Padding(padding: EdgeInsets.only(bottom: 30)),
          ],
        ),
      ),
    );
  }
}
