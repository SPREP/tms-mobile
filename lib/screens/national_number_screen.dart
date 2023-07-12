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
      Category.ambulance: "+676 387221",
      Category.police: "+676 387856",
      Category.fire: "+676 387332",
      Category.hospital: "+676 387976",
    };

    const haapaiNumbers = {
      Location: Location.haapai,
      Category.ambulance: "+676 38564",
      Category.police: "+676 387444",
      Category.fire: "+676 38756443",
      Category.hospital: "+676 38734333",
    };

    const vavauNumbers = {
      Location: Location.vavau,
      Category.ambulance: "+676 387754",
      Category.police: "+676 387244",
      Category.fire: "+676 387299",
      Category.hospital: "+676 387543",
    };

    const niuafoouNumbers = {
      Location: Location.niuafoou,
      Category.ambulance: "+676 38332",
      Category.police: "+676 387854",
      Category.fire: "+676 38444",
      Category.hospital: "+676 3873329",
    };

    const niuatoputapuNumbers = {
      Location: Location.niuatoputapu,
      Category.ambulance: "+676 387333",
      Category.police: "+676 38222",
      Category.fire: "+676 387555",
      Category.hospital: "+676 38666",
    };

    const euaNumbers = {
      Location: Location.eua,
      Category.ambulance: "+676 387444",
      Category.police: "+676 3874",
      Category.fire: "+676 38723129",
      Category.hospital: "+676 387543",
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
            Text("You will find here the national telephone numbers."),
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
