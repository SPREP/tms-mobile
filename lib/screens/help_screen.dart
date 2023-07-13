import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Help'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
        child: Column(children: [
          Text(
              "Do you need help \n\nLorem ipsum dolor sit amet consectetur. Amet rhoncus blandit enim pellentesque viverra vitae maecenas volutpat. Massa malesuada ullamcorper tellus proin nibh eget lectus integer. Neque scelerisque ornare pulvinar tincidunt semper. Sit cursus scelerisque cras elit. Aliquet ornare pellentesque a aliquet quis sit posuere."),
        ]),
      ),
    );
  }
}
