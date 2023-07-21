import 'package:flutter/material.dart';
import 'package:macres/screens/weather_forcast/sun_moon_slide.dart';
import 'package:macres/screens/weather_forcast/tide_slide.dart';
import 'package:macres/screens/weather_forcast/weather_slide.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:macres/models/settings_model.dart';

class WeatherForcastScreen extends StatefulWidget {
  const WeatherForcastScreen({super.key});

  @override
  State<WeatherForcastScreen> createState() {
    return _WeatherForcastScreenState();
  }
}

class _WeatherForcastScreenState extends State<WeatherForcastScreen> {
  final PageController myController = PageController(
    keepPage: true,
  );
  final _itemCount = 3;
  dynamic activeSlide;

  Location selectedLocation = Location.tongatapu;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(210, 0, 37, 42),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    DropdownButton<Location>(
                      borderRadius: BorderRadius.circular(10),
                      value: selectedLocation,
                      dropdownColor: const Color.fromARGB(255, 17, 48, 51),
                      icon: const Icon(
                        Icons.expand_more,
                        color: Colors.white,
                      ),
                      items: Location.values.map((Location value) {
                        return DropdownMenuItem<Location>(
                          value: value,
                          child: Text(
                            locationLabel[value].toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value!;
                        });
                      },
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.favorite_sharp,
                      color: Colors.white,
                    ),
                    /*
                    const Spacer(),
                    const Row(
                      children: [
                        Text('\u2103'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('\u2109'),
                      ],
                    ),
                    */
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
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
                          'SUNNY 21/20',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        BoxedIcon(
                          WeatherIcons.day_sunny,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
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
                const SizedBox(height: 20),
                const Text('Cloudy periods with few showers'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 350,
            decoration: const BoxDecoration(
              color: Color.fromARGB(210, 0, 37, 42),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: myController,
                    itemCount: _itemCount,
                    itemBuilder: (_, index) {
                      if (index == 0) activeSlide = const WeatherSlide();

                      if (index == 1) activeSlide = const TideSlide();

                      if (index == 2) activeSlide = const SunMoonSlide();

                      //if (index == 3) activeSlide = const RainfallSlide();

                      //if (index == 4) activeSlide = const OceanSlide();

                      return activeSlide;
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
