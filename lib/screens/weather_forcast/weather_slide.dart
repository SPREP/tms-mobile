import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherSlide extends StatefulWidget {
  const WeatherSlide({super.key});

  @override
  State<WeatherSlide> createState() => _WeatherSlideState();
}

class _WeatherSlideState extends State<WeatherSlide> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Spacer(),
            Text('Weather'),
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
        SizedBox(
          height: 10,
        ),
        ListTile(
          dense: true,
          leading: BoxedIcon(
            WeatherIcons.day_sunny,
            color: Colors.white,
          ),
          title: Text('Today',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: Text(
            '21/20',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          dense: true,
          leading: BoxedIcon(
            WeatherIcons.day_snow_thunderstorm,
            color: Colors.white,
          ),
          title: Text('Tommorow',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: Text(
            '21/20',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          dense: true,
          leading: BoxedIcon(
            WeatherIcons.day_cloudy_windy,
            color: Colors.white,
          ),
          title: Text('Monday',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: Text(
            '21/20',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          dense: true,
          leading: BoxedIcon(
            WeatherIcons.rain_wind,
            color: Colors.white,
          ),
          title: Text('Tuesday',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: Text(
            '21/20',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          dense: true,
          leading: BoxedIcon(
            WeatherIcons.day_cloudy,
            color: Colors.white,
          ),
          title: Text('Wednesday',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: Text(
            '21/20',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
