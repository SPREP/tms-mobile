import 'package:flutter/material.dart';
import 'package:macres/models/weather_model.dart';
import 'package:macres/providers/ten_days_provider.dart';
import 'package:macres/providers/three_hours_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class ThreeHoursSlide extends StatefulWidget {
  const ThreeHoursSlide({super.key});

  @override
  State<ThreeHoursSlide> createState() => _ThreeHoursSlideState();
}

class _ThreeHoursSlideState extends State<ThreeHoursSlide> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThreeHoursProvider>(
      builder: (context, threeHoursProvider, child) {
        var data = threeHoursProvider.currentThreeHoursData;

        return Column(
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Spacer(),
                Text('3-HOURS FORECAST'),
                Spacer(),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "${data.currentTemp}\u00B0",
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(
                width: 40,
              ),
              Column(
                children: [
                  Text(
                    '${data.caption}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  data.getIcon(30.0, Colors.white),
                ],
              ),
            ]),
            const SizedBox(
              height: 30,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 122, 121, 121),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.visibility_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                          const Text('Visibility'),
                          Text('${data.visibility} m'),
                        ]),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 122, 121, 121),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.explore,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(data.windDirection.toString()),
                          Text('${data.windSpeed.toString()} knts'),
                        ]),
                  ),
                ]),
          ],
        );
      },
    );
  }
}
