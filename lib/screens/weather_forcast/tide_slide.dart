import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class TideSlide extends StatefulWidget {
  const TideSlide({super.key});

  @override
  State<TideSlide> createState() => _TideSlideState();
}

class _TideSlideState extends State<TideSlide> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Spacer(),
            Text('Tides'),
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
