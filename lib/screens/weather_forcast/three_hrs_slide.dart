import 'package:flutter/material.dart';
import 'package:macres/widgets/weather_property_widget.dart';
import 'package:weather_icons/weather_icons.dart';

class ThreeHoursSlide extends StatefulWidget {
  const ThreeHoursSlide({super.key, required this.currentData});

  final currentData;

  @override
  State<ThreeHoursSlide> createState() => _ThreeHoursSlideState();
}

class _ThreeHoursSlideState extends State<ThreeHoursSlide> {
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
            "${widget.currentData.currentTemp}\u00B0",
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(
            width: 10,
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
        ]),
        SizedBox(
          height: 20.0,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              WeatherProperty(
                title: 'Visibility',
                value: widget.currentData.visibility,
                unit: 'm',
                icon: Icon(
                  Icons.visibility_outlined,
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
      ],
    );
  }
}
