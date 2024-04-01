import 'package:flutter/material.dart';
import 'package:macres/widgets/weather_property_widget.dart';
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
            Container(
              height: 80.0,
              width: 80.0,
              child: widget.currentData.getIcon(),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Spacer(),
          WeatherProperty(
            title: 'Max: ${widget.currentData.maxTemp}\u00B0',
            value: 'Min: ${widget.currentData.minTemp}\u00B0',
            unit: '',
            icon: Icon(
              WeatherIcons.thermometer,
              color: Colors.white,
              size: 30,
            ),
          ),
          Spacer(),
          WeatherProperty(
            title: 'Wind Direction',
            value: widget.currentData.windDirection.toString(),
            unit: '',
            icon: Icon(
              WeatherIcons.wind_direction,
              color: Colors.white,
              size: 30,
            ),
          ),
          Spacer(),
          WeatherProperty(
            title: 'Wind Speed',
            value: widget.currentData.windSpeed.toString(),
            unit: 'km/h',
            icon: Icon(
              WeatherIcons.strong_wind,
              color: Colors.white,
              size: 30,
            ),
          ),
          Spacer(),
        ]),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
