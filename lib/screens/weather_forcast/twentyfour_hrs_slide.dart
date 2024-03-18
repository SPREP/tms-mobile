import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class TwentyFourHoursSlide extends StatefulWidget {
  const TwentyFourHoursSlide({super.key, required this.currentData});

  final currentData;

  @override
  State<TwentyFourHoursSlide> createState() => _TwentyFourHoursSlideState();
}

class _TwentyFourHoursSlideState extends State<TwentyFourHoursSlide> {
  @override
  Widget build(BuildContext context) {
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
          child: Text(widget.currentData.warning.toString()),
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Text(
              '${widget.currentData.caption}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            widget.currentData.getIcon(50.0, 50.0),
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
              "Max: ${widget.currentData.maxTemp}\u00B0",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Min: ${widget.currentData.minTemp}\u00B0",
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
            Text(widget.currentData.windDirection.toString()),
            Text('${widget.currentData.windSpeed.toString()} knts'),
          ]),
        ]),
        const SizedBox(
          height: 70,
        ),
      ],
    );
  }
}
