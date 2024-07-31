import 'package:flutter/material.dart';
import 'package:macres/widgets/weather_property_widget.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TwentyFourHoursSlide extends StatefulWidget {
  const TwentyFourHoursSlide({super.key, required this.currentData});

  final currentData;

  @override
  State<TwentyFourHoursSlide> createState() => _TwentyFourHoursSlideState();
}

class _TwentyFourHoursSlideState extends State<TwentyFourHoursSlide> {
  @override
  Widget build(BuildContext context) {
    //We find the size of the screen to better format the content
    final screenWidth = MediaQuery.of(context).size.width;
    var isSmallDevice = false;
    if (screenWidth <= 350.0) isSmallDevice = true;

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Spacer(),
            Text(localizations.twelveHoursTitle),
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
          //  child: Text(widget.currentData.warning.toString()),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Text(
              '${widget.currentData.getIconDefinition(context)}',
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
        if (!isSmallDevice)
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            WeatherProperty(
              title:
                  '${localizations.max}: ${widget.currentData.maxTemp}\u00B0',
              value:
                  '${localizations.min}: ${widget.currentData.minTemp}\u00B0',
              unit: '',
              icon: Icon(
                WeatherIcons.thermometer,
                color: Colors.white,
                size: 30,
              ),
            ),
            WeatherProperty(
              title: localizations.weatherCurrentConditionWindDirection,
              value: widget.currentData.windDirection.toString(),
              unit: '',
              icon: Icon(
                WeatherIcons.wind_direction,
                color: Colors.white,
                size: 30,
              ),
            ),
            WeatherProperty(
              title: localizations.weatherCurrentConditionWindSpeed,
              value: widget.currentData.windSpeed.toString(),
              unit: 'km/h',
              icon: Icon(
                WeatherIcons.strong_wind,
                color: Colors.white,
                size: 30,
              ),
            ),
          ]),
        if (isSmallDevice)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            WeatherProperty(
              title:
                  '${localizations.max}: ${widget.currentData.maxTemp}\u00B0',
              value:
                  '${localizations.min}: ${widget.currentData.minTemp}\u00B0',
              unit: '',
              icon: Icon(
                WeatherIcons.thermometer,
                color: Colors.white,
                size: 30,
              ),
            ),
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
          ]),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
