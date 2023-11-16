import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/providers/tide_provider.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class TideSlide extends StatefulWidget {
  const TideSlide({super.key});

  @override
  State<TideSlide> createState() => _TideSlideState();
}

class _TideSlideState extends State<TideSlide> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TideProvider>(
      builder: (context, TideProvider, child) {
        var data = TideProvider.currentTideData;
        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Spacer(),
                Text('TIDE TIME FOR TODAY'),
                Spacer(),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                children: [],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('High Tide: ' + data.high.toString()),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Low Tide: ' + data.low.toString(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        );
      },
    );
  }
}
