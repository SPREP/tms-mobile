import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WeatherForcastScreen extends StatefulWidget {
  const WeatherForcastScreen({super.key});

  @override
  State<WeatherForcastScreen> createState() {
    return _WeatherForcastScreenState();
  }
}

class _WeatherForcastScreenState extends State<WeatherForcastScreen> {
  final PageController myController = PageController(
    viewportFraction: 0.8,
    keepPage: true,
  );
  final _itemCount = 5;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(180, 0, 37, 42),
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
                    Row(
                      children: [
                        Text('\u2103'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('\u2109'),
                      ],
                    ),
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
          const SizedBox(height: 10),
          Container(
            height: 350,
            decoration: const BoxDecoration(
              color: Color.fromARGB(180, 0, 37, 42),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: PageView.builder(
                    controller: myController,
                    itemCount: _itemCount,
                    itemBuilder: (_, index) {
                      return const Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Spacer(),
                                Text('Weather'),
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
                              dense: true,
                              leading: BoxedIcon(
                                WeatherIcons.day_sunny,
                                color: Colors.white,
                              ),
                              title: Text('Today',
                                  style: TextStyle(color: Colors.white)),
                              trailing: Text(
                                '21/20',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              leading: BoxedIcon(
                                WeatherIcons.day_snow_thunderstorm,
                                color: Colors.white,
                              ),
                              title: Text('Tommorow',
                                  style: TextStyle(color: Colors.white)),
                              trailing: Text(
                                '21/20',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              leading: BoxedIcon(
                                WeatherIcons.day_cloudy_windy,
                                color: Colors.white,
                              ),
                              title: Text('Monday',
                                  style: TextStyle(color: Colors.white)),
                              trailing: Text(
                                '21/20',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              leading: BoxedIcon(
                                WeatherIcons.rain_wind,
                                color: Colors.white,
                              ),
                              title: Text('Tuesday',
                                  style: TextStyle(color: Colors.white)),
                              trailing: Text(
                                '21/20',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              leading: BoxedIcon(
                                WeatherIcons.day_cloudy,
                                color: Colors.white,
                              ),
                              title: Text('Wednesday',
                                  style: TextStyle(color: Colors.white)),
                              trailing: Text(
                                '21/20',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SmoothPageIndicator(
                  controller: myController,
                  count: _itemCount,
                  effect: const WormEffect(
                    paintStyle: PaintingStyle.stroke,
                    dotColor: Colors.white,
                    activeDotColor: Colors.white,
                    dotHeight: 10,
                    dotWidth: 10,
                    type: WormType.thin,
                    // strokeWidth: 5,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
