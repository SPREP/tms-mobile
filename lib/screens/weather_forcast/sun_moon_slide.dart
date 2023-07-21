import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class SunMoonSlide extends StatefulWidget {
  const SunMoonSlide({super.key});

  @override
  State<SunMoonSlide> createState() => _SunMoonSlideState();
}

class _SunMoonSlideState extends State<SunMoonSlide> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Spacer(),
            Text('Sun & Moon'),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          leading: BoxedIcon(
            WeatherIcons.sunrise,
            color: Colors.white,
          ),
          title: Text('Sunrise',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: Text(
            '7:17am/E',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: BoxedIcon(
            WeatherIcons.sunset,
            color: Colors.white,
          ),
          title: Text('Sunset',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: Text(
            '6:17pm/NW',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: BoxedIcon(
            WeatherIcons.moon_first_quarter,
            color: Colors.white,
          ),
          title: Text('Moonrise',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: Text(
            '6:17pm/NW',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: BoxedIcon(
            WeatherIcons.moon_third_quarter,
            color: Colors.white,
          ),
          title: Text('Moonset',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: Text(
            '7:10am/NW',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
