import 'dart:async';
import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/notification_model.dart';
import 'package:macres/models/tide_model.dart';
import 'package:macres/models/weather_model.dart';
import 'package:macres/providers/tide_provider.dart';
import 'package:macres/providers/ten_days_provider.dart';
import 'package:macres/providers/three_hours_provider.dart';
import 'package:macres/providers/twentyfour_hours_provider.dart';
import 'package:macres/screens/weather_forcast/three_hrs_slide.dart';
import 'package:macres/screens/weather_forcast/tendays_slide.dart';
import 'package:macres/screens/weather_forcast/twentyfour_hrs_and_tide_slide.dart';
import 'package:macres/widgets/notification_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:macres/models/settings_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherForcastScreen extends StatefulWidget {
  const WeatherForcastScreen({super.key, required this.onCurrentWeatherChange});

  final String Function(String filepath, String dayOrNight)
      onCurrentWeatherChange;

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
  String selectedTempretureUnit = 'c';

  Location selectedLocation = Location.tongatapu;
  CurrentWeatherModel currentData = CurrentWeatherModel();
  List<TenDaysForecastModel> currentTenDaysData = [];
  ThreeHoursForecastModel currentThreeHoursData = ThreeHoursForecastModel();
  TwentyFourHoursForecastModel currentTwentyFourHoursData =
      TwentyFourHoursForecastModel();
  TideModel currentTideData = TideModel(high: [], low: []);

  List<CurrentWeatherModel> currentWeatherData = [];
  List<TwentyFourHoursForecastModel> twentyFourHoursData = [];
  List<ThreeHoursForecastModel> threeHoursData = [];
  List<TenDaysForecastModel> tenDaysData = [];
  List<TideModel> tideData = [];

  late NotificationModel notificationData;

  bool isLoading = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer =
        Timer.periodic(const Duration(minutes: 2), (Timer t) => getWeather());

    notificationData = NotificationModel();

    setLocation();
    setState(() {
      isLoading = true;
      getWeather();
      getNotification();
    });
  }

  @override
  void dispose() {
    timer.cancel(); //cancel the timer here
    super.dispose();
  }

  void setLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final setLocation = prefs.getString('user_location');

    if (setLocation == null) {
      prefs.setString('user_location', selectedLocation.name.toString());
    } else {
      selectedLocation = LocationExtension.fromName(setLocation)!;
    }
  }

  void setTempretureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final tempUnit = prefs.getString('tempreture_unit');

    if (tempUnit == null) {
      prefs.setString('tempreture_unit', selectedTempretureUnit);
    } else {
      selectedTempretureUnit = tempUnit;
    }
  }

  void changeCurrentData() {
    //Load data for current weather forcast
    for (final item in currentWeatherData) {
      if (convertToLocation(item.location.toString()) == selectedLocation) {
        currentData = item;
      }
    }
    //Load data for 10days forcast
    currentTenDaysData.clear();
    for (final item in tenDaysData) {
      if (convertToLocation(item.location.toString()) == selectedLocation) {
        currentTenDaysData.add(item);
      }
    }

    //Load data for 3 hours forcast
    for (final item in threeHoursData) {
      if (convertToLocation(item.location.toString()) == selectedLocation) {
        currentThreeHoursData = item;
      }
    }

    //Load data for 24 hours forcast
    for (final item in twentyFourHoursData) {
      if (convertToLocation(item.location.toString()) == selectedLocation) {
        currentTwentyFourHoursData = item;
      }
    }

    //Load data for tide
    currentTideData = TideModel(high: [], low: []);
    for (final item in tideData) {
      if (convertToLocation(item.location.toString()) == selectedLocation) {
        currentTideData = item;
      }
    }

    //Update the provider ten days
    TenDaysProvider tenDaysProvider =
        Provider.of<TenDaysProvider>(context, listen: false);
    tenDaysProvider.setData(currentTenDaysData);

    //Three hours
    ThreeHoursProvider threeHoursProvider =
        Provider.of<ThreeHoursProvider>(context, listen: false);
    threeHoursProvider.setData(currentThreeHoursData);

    //Twenty Four Hours
    TwentyFourHoursProvider twentyFourHoursProvider =
        Provider.of<TwentyFourHoursProvider>(context, listen: false);
    twentyFourHoursProvider.setData(currentTwentyFourHoursData);

    //Tide high and low
    TideProvider tideProvider =
        Provider.of<TideProvider>(context, listen: false);
    tideProvider.setData(currentTideData);

    changeBgImage();
  }

  void changeBgImage() {
    String filePath = '';
    switch (currentData.iconId) {
      case 5:
      case 6:
      case 7:
        filePath = currentData.dayOrNight == 'day'
            ? 'assets/images/day_rain.jpg'
            : 'assets/images/night_rain.jpg';
        break;
      case 1:
        filePath = currentData.dayOrNight == 'day'
            ? 'assets/images/sunny_day.jpg'
            : 'assets/images/clear_night.jpg';
        break;
      case 2:
      case 3:
      case 4:
      case 8:
      case 9:
      case 10:
        filePath = currentData.dayOrNight == 'day'
            ? 'assets/images/cloudy_day.jpg'
            : 'assets/images/cloudy_night.jpg';
        break;
    }
    widget.onCurrentWeatherChange(filePath, currentData.dayOrNight);
  }

  void changeLocation(Location newLocation) async {
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

  getNotification() async {
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;

    var prefs = await SharedPreferences.getInstance();
    var lng = prefs.getString('user_language');

    String endpoint = '/notification/$lng?_format=json';

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
        NotificationModel loadedItem = NotificationModel();

        for (final item in listData.entries) {
          final notificationLevel = int.parse(item.value['level']);
          // Only show warning notification
          if (notificationLevel != 2 && notificationLevel != 3) continue;

          //Only show warning for today
          if (isToday(int.parse(item.value['timestamp']))) {
            loadedItem = NotificationModel(
                id: int.parse(item.value['id']),
                date: item.value['date'],
                time: item.value['time'],
                body: item.value['body'] ?? '',
                level: int.parse(item.value['level']),
                location: item.value['target_location'],
                title: item.value['title']);
          }
        }

        setState(() {
          notificationData = loadedItem;
          //isLoading = false;
        });

        return loadedItem;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text(
            'Error: Unable to load notification. Check your internet connection.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(e);
    }
  }

  bool isToday(timestamp) {
    final tdate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final tdateToday = DateTime(tdate.year, tdate.month, tdate.day);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (tdateToday == today) {
      return true;
    }
    return false;
  }

  getWeather() async {
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;
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

        // 10day
        if (listData['10day'].length > 0) {
          tenDaysData.clear();
          listData['10day'].forEach((final String key, final value) {
            for (var n in value) {
              var dataModel = TenDaysForecastModel(
                  iconId: int.parse(n['icon']),
                  day: n['day'],
                  maxTemp: n['max_temp'],
                  minTemp: n['min_temp'],
                  location: key);

              tenDaysData.add(dataModel);
            }
          });
        }

        // Current forecast
        if (listData['current'].length > 0) {
          currentWeatherData.clear();
          listData['current'].forEach((final String key, final value) {
            var dataModel = CurrentWeatherModel(
                location: key,
                iconId: int.parse(value['icon']),
                currentTemp: value['temperature'],
                humidity: value['humidity'],
                pressure: value['barometer'],
                windDirection: value['wind_direction'],
                windSpeed: value['wind_speed'],
                visibility: value['visibility']);
            currentWeatherData.add(dataModel);
          });
        }

        // 3Hrs
        if (listData['3hrs'].length > 0) {
          threeHoursData.clear();
          listData['3hrs'].forEach((final String key, final value) {
            threeHoursData.add(ThreeHoursForecastModel(
              location: key,
              iconId: int.parse(value['icon']),
              caption: value['condition'],
              currentTemp: value['temp'],
              windDirection: value['wind_direction'],
              windSpeed: value['wind_speed'],
              visibility: value['pressure'],
            ));
          });
        }

        // 24Hours
        if (listData['24hrs'].length > 0) {
          twentyFourHoursData.clear();
          listData['24hrs'].forEach((final String key, final value) {
            twentyFourHoursData.add(TwentyFourHoursForecastModel(
              location: key,
              iconId: int.parse(value['icon']),
              caption: value['condition'],
              maxTemp: value['max_temp'],
              minTemp: value['min_temp'],
              windDirection: value['wind_direction'],
              windSpeed: value['wind_speed'],
              warning: value['warning'],
            ));
          });
        }

        // Tide
        if (listData['tide'].length > 0) {
          tideData.clear();
          listData['tide'].forEach((final String key, final value) {
            TideModel tide = new TideModel(low: [], high: [], location: key);
            for (var item in value) {
              tide.high =
                  item['event'] == 'high' ? item['time'].split(',') : tide.high;
              tide.low =
                  item['event'] == 'low' ? item['time'].split(',') : tide.low;
            }
            tideData.add(tide);
          });
        }

        setState(() {
          isLoading = false;
          changeCurrentData();
        });
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text(
            'Error: Unable to load weather data. Check your internet connection.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                //Warning section
                Container(
                  child: Column(
                    children: [
                      if (notificationData.body != null)
                        NotificationWidget(notification: notificationData)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // End Warning section
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
                          // @todo - remove if not needed in the future.
                          // Degrees icon.
                          // const Spacer(),
                          // Icon(
                          //   selectedTempretureUnit == 'c'
                          //       ? WeatherIcons.celsius
                          //       : WeatherIcons.fahrenheit,
                          //   color: Colors.white,
                          //   size: 30.0,
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(currentData.getIconDefinition().toString()),
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            "${currentData.currentTemp}\u00B0${selectedTempretureUnit.toUpperCase()}",
                            style: const TextStyle(fontSize: 50),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              currentData.getIcon(50.0, Colors.white),
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
                              Text('${currentData.pressure}mb'),
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
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 700,
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
                            if (index == 0) {
                              activeSlide = TwentyFourHoursAndTideSlide();
                            }
                            if (index == 1) {
                              activeSlide = const ThreeHoursSlide();
                            }

                            if (index == 2) {
                              activeSlide = const TenDaysSlide();
                            }

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
