import 'package:flutter/material.dart';

import 'package:macres/screens/tk_indicators_screen.dart';
import 'package:macres/screens/tk_map_screen.dart';
import 'package:macres/util/magnifier.dart' as Mag;

class TkFrontScreen extends StatefulWidget {
  const TkFrontScreen({super.key});

  @override
  State<TkFrontScreen> createState() => _TkFrontScreenState();
}

class _TkFrontScreenState extends State<TkFrontScreen> {
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return Mag.Magnifier(
      size: Size(250.0, 250.0),
      enabled: visibility ? true : false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Traditional Knowledge'),
          centerTitle: false,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  visibility = !visibility;
                });
              },
              child: Icon(
                visibility ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset('assets/images/frigate_bird.jpg'),
                SizedBox(
                  height: 10.0,
                ),
                Text('Traditional Weather and Climate Knowledge',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'The islands of Tonga have been inhabited for over 3000 years. During this time, Tongans learned to use natural indicators to forecast and predict the weather and climate and its impacts. These knowledge are still useful today for both traditional and contemporary weather and climate forecasting.',
                  softWrap: true,
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TkIndicatorsScreen(),
                      ),
                    );
                  },
                  child: Text('Check out traditional indicators'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TkMapScreen(),
                      ),
                    );
                  },
                  child: Text('Report a traditional Indicator'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
