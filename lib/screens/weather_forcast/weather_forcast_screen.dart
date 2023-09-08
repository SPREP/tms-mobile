import 'package:flutter/material.dart';
import 'package:humanitarian_icons/humanitarian_icons.dart';
import 'package:macres/models/weather_model.dart';
import 'package:macres/screens/weather_forcast/sun_moon_slide.dart';
import 'package:macres/screens/weather_forcast/tide_slide.dart';
import 'package:macres/screens/weather_forcast/weather_slide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:macres/models/settings_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  CurrentWeatherModel currentData = CurrentWeatherModel();
  List<CurrentWeatherModel> currentWeatherData = [];
  List<TwentyFourHoursForecastModel> twentyFourHoursData = [];
  List<ThreeHoursForecastModel> threeHoursData = [];
  List<TenDaysForecastModel> tenDaysData = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setLocation();
    setState(() {
      isLoading = true;
      getWeather();
    });
  }

  void setLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final setLocation = prefs.getString('weather_location');

    if (setLocation == null) {
      prefs.setString('weather_location', selectedLocation.name.toString());
    } else {
      selectedLocation = LocationExtension.fromName(setLocation)!;
    }
  }

  void changeCurrentData() {
    for (final item in currentWeatherData) {
      if (convertToLocation(item.location.toString()) == selectedLocation) {
        currentData = item;
      }
    }
  }

  void changeLocation(Location newLocation) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('weather_location', newLocation.name.toString());
    changeCurrentData();
  }

  Location convertToLocation(String name) {
    switch (name) {
      case 'tbu':
        return Location.tongatapu;
      case 'vv':
        return Location.vavau;
      case 'hpp':
        return Location.haapai;
      case 'nfo':
        return Location.niuafoou;
      case 'ntt':
        return Location.niuatoputapu;
      case 'eua':
        return Location.eua;
    }

    return Location.tongatapu;
  }

  getWeather() async {
    var username = metapi[Credential.username];
    var password = metapi[Credential.password];
    String host = metapi[Credential.host].toString();
    String endpoint = '/weather?_format=json';

    final basicAuth =
        "Basic ${base64.encode(utf8.encode('$username:$password'))}";
    dynamic response;
    try {
      response = await http.get(
        Uri.parse('$host$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuth
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body).isEmpty) {
          setState(() {
            isLoading = false;
          });
          return [];
        }

        final Map<String, dynamic> listData = jsonDecode(response.body);

        if (listData['10days'].length > 0) {
          for (final item in listData['10days']) {
            var dataModel = TenDaysForecastModel(
                iconId: int.parse(item[1]),
                day: item[2],
                maxTemp: item[3],
                minTemp: item[4],
                location: item[0]);

            tenDaysData.add(dataModel);
          }
        }

        if (listData['current'].length > 0) {
          for (final item in listData['current']) {
            var dataModel = CurrentWeatherModel(
              location: item[0],
              iconId: int.parse(item[1]),
              currentTemp: item[2],
              humidity: item[3],
              pressure: item[4],
              windDirection: item[5],
              windSpeed: item[6],
              visibility: item[7],
              minTemp: item[8],
              maxTemp: item[9],
            );

            currentWeatherData.add(dataModel);
            if (convertToLocation(item[0]) == selectedLocation) {
              currentData = dataModel;
            }
          }
        }

        if (listData['3hrs'].length > 0) {
          for (final item in listData['3hrs']) {
            threeHoursData.add(ThreeHoursForecastModel(
              location: item[0],
              iconId: int.parse(item[1]),
              caption: item[2],
              currentTemp: item[3],
              windDirection: item[4],
              windSpeed: item[5],
              visibility: item[6],
            ));
          }
        }

        if (listData['24hrs'].length > 0) {
          for (final item in listData['24hrs']) {
            twentyFourHoursData.add(TwentyFourHoursForecastModel(
              location: item[0],
              iconId: int.parse(item[1]),
              caption: item[2],
              maxTemp: item[3],
              minTemp: item[4],
              windDirection: item[5],
              windSpeed: item[6],
              warning: item[7],
            ));
          }
        }

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text(
            'Error: Unable to load weather data. Check your internet connection.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : DefaultTextStyle.merge(
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
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
                            dropdownColor:
                                const Color.fromARGB(255, 17, 48, 51),
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
                                changeLocation(value);
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
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            "${currentData.currentTemp}\u00B0",
                            style: const TextStyle(fontSize: 50),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                'SUNNY ${currentData.minTemp}/${currentData.maxTemp}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              currentData.getIcon(40.0, Colors.white),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Column(
                            children: [
                              const Icon(
                                WeatherIcons.humidity,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(height: 10),
                              const Text('Humidity'),
                              Text('${currentData.humidity}%'),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              const Icon(
                                WeatherIcons.barometer,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Pressure'),
                              Text('${currentData.pressure}hPa'),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              const Icon(
                                Icons.explore_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(height: 5),
                              Text('${currentData.windDirection}'),
                              Text('${currentData.windSpeed} knts'),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              const Icon(
                                Icons.visibility_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                              const Text('Visibility'),
                              Text('${currentData.visibility}'),
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
