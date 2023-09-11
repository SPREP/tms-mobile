import 'package:flutter/material.dart';
import 'package:macres/models/weather_model.dart';
import 'package:macres/providers/ten_days_provider.dart';
import 'package:macres/providers/twentyfour_hours_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class TwentyFourHoursSlide extends StatefulWidget {
  const TwentyFourHoursSlide({super.key});

  @override
  State<TwentyFourHoursSlide> createState() => _TwentyFourHoursSlideState();
}

class _TwentyFourHoursSlideState extends State<TwentyFourHoursSlide> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TwentyFourHoursProvider>(
      builder: (context, twentyFourHoursProvider, child) {
        var data = twentyFourHoursProvider.currentTwentyFourHoursData;

        return Column(
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Spacer(),
                Text('24-HOURS FORECAST'),
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
              child: Text(data.warning.toString()),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  '${data.caption}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                data.getIcon(40.0, Colors.white),
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
                  "Max: ${data.maxTemp}\u00B0",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Min: ${data.minTemp}\u00B0",
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
                Text(data.windDirection.toString()),
                Text('${data.windSpeed.toString()} knts'),
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
