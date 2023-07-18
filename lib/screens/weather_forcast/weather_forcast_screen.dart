import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherForcastScreen extends StatelessWidget {
  const WeatherForcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(200, 0, 0, 0),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: const Column(
              children: [
                Row(
                  children: [
                    Text('Tongatapu'),
                    Spacer(),
                    Icon(
                      Icons.favorite_sharp,
                      color: Colors.white,
                    ),
                    Spacer(),
                    Text('C F'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "21\u00B0",
                      style: TextStyle(fontSize: 50),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          'RAINING 21/21',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        BoxedIcon(
                          WeatherIcons.rain,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Column(
                      children: [
                        BoxedIcon(
                          WeatherIcons.humidity,
                          color: Colors.white,
                        ),
                        Text('Humidity'),
                        Text('70%'),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Icon(
                          Icons.compress_outlined,
                          color: Colors.white,
                        ),
                        Text('Pressure'),
                        Text('1015 hPa'),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        BoxedIcon(
                          WeatherIcons.windy,
                          color: Colors.white,
                        ),
                        Text('NW'),
                        Text('4.2mph'),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Icon(
                          Icons.visibility,
                          color: Colors.white,
                        ),
                        Text('Visibility'),
                        Text('10.00'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Cloudy periods with few showers'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
