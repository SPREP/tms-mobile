import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/providers/sun_provider.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class SunSlide extends StatefulWidget {
  const SunSlide({super.key});

  @override
  State<SunSlide> createState() => _SunSlideState();
}

class _SunSlideState extends State<SunSlide> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SunProvider>(
      builder: (context, SunProvider, child) {
        var data = SunProvider.currentSunData;
        return Column(
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Spacer(),
                Text('SUN RISE / SUN SET'),
                Spacer(),
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
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
              child: Text(data.sunset.toString()),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  data.sunrise.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(children: [
                const Icon(
                  WeatherIcons.thermometer,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Max:",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Min",
                  style: const TextStyle(fontSize: 16),
                ),
              ]),
              const SizedBox(
                width: 40,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(
                  Icons.explore,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
            ]),
            const SizedBox(
              height: 30,
            ),
          ],
        );
      },
    );
  }
}
