import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/notification_model.dart';
import 'package:macres/models/sea_model.dart';
import 'package:macres/models/tide_model.dart';
import 'package:macres/models/weather_model.dart';
import 'package:macres/providers/weather_location.dart';
import 'package:macres/screens/weather_forcast/three_hrs_slide.dart';
import 'package:macres/screens/weather_forcast/tendays_slide.dart';
import 'package:macres/screens/weather_forcast/tide_slide.dart';
import 'package:macres/screens/weather_forcast/twentyfour_hrs_slide.dart';
import 'package:macres/widgets/notification_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';
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

  String selectedTempretureUnit = 'c';

  Location selectedLocation = Location.tongatapu;
  CurrentWeatherModel currentData = CurrentWeatherModel();
  List<TenDaysForecastModel> currentTenDaysData = [];
  ThreeHoursForecastModel currentThreeHoursData = ThreeHoursForecastModel();
  TwentyFourHoursForecastModel currentTwentyFourHoursData =
      TwentyFourHoursForecastModel();
  List<TideModel> currentTideData = [];
  SeaModel currentSeaData = SeaModel();

  List<CurrentWeatherModel> currentWeatherData = [];
  List<TwentyFourHoursForecastModel> twentyFourHoursData = [];
  List<ThreeHoursForecastModel> threeHoursData = [];
  List<TenDaysForecastModel> tenDaysData = [];
  List<TideModel> tideData = [];
  List<SeaModel> seaData = [];

  List<Color> widgetBackgroundDayColors = <Color>[
    Color.fromARGB(255, 22, 83, 133),
    const Color.fromARGB(255, 21, 123, 207)
  ];

  List<Color> widgetBackgroundNightColors = <Color>[
    Color.fromARGB(255, 40, 43, 46),
    Color.fromARGB(255, 20, 24, 27)
  ];

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
    myController.dispose();
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
    currentTideData.clear();
    for (final item in tideData) {
      if (convertToLocation(item.location.toString()) == selectedLocation) {
        currentTideData.add(item);
      }
    }

    //Load data for sea
    currentSeaData = SeaModel();
    for (final item in seaData) {
      if (convertToLocation(item.location.toString()) == selectedLocation) {
        currentSeaData = item;
      }
    }
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
        content: Text('Error: Unable to load notification..'),
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

        if (listData['tide'].length > 0) {
          tideData.clear();
          for (final item in listData['tide']) {
            var tideModel = TideModel(
              id: item[1],
              status: item[3],
              time: item[4],
              level: item[5],
              date: item[6],
              location: item[0],
            );

            tideData.add(tideModel);
          }
        }

        if (listData['sea'].length > 0) {
          seaData.clear();
          for (final item in listData['sea']) {
            var seaModel = SeaModel(
                level: item[1],
                temp: item[2],
                location: item[0],
                observedDate: item[3]);

            seaData.add(seaModel);
          }
        }

        if (listData['10days'].length > 0) {
          tenDaysData.clear();
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

        if (listData['weather'].length > 0) {
          currentWeatherData.clear();
          for (final item in listData['weather']) {
            var dataModel = CurrentWeatherModel(
                location: item[0],
                iconId: int.parse(item[1]),
                currentTemp: item[2],
                humidity: item[3],
                pressure: item[4],
                windDirection: item[5],
                windSpeed: item[6],
                visibility: item[7],
                observedDate: item[8]);

            currentWeatherData.add(dataModel);
            if (convertToLocation(item[0]) == selectedLocation) {
              currentData = dataModel;
            }
          }
          widget.onCurrentWeatherChange('', currentData.dayOrNight);
        }

        if (listData['3hrs'].length > 0) {
          threeHoursData.clear();
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
          twentyFourHoursData.clear();
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
          changeCurrentData();
        });
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text('Error: Unable to load weather data.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Consumer<WeatherLocationProvider>(
            builder: (context, weatherLocationProvider, child) {
            selectedLocation = weatherLocationProvider.selectedLocation;
            changeCurrentData();

            return DefaultTextStyle.merge(
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: currentData.dayOrNight == 'day'
                            ? widgetBackgroundDayColors
                            : widgetBackgroundNightColors,
                      ),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('TODAY'),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text(DateFormat("EEE dd MMM, hh:mm a")
                                .format(DateTime.now())),
                            const Spacer(),
                            Text(currentData.getIconDefinition().toString()),
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
                        Row(
                          children: [
                            Text(
                              "${currentData.currentTemp}",
                              style: const TextStyle(
                                  fontSize: 60, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.left,
                            ),
                            Align(
                              heightFactor: 1.5,
                              alignment: Alignment.topRight,
                              child: Text(
                                "\u00B0${selectedTempretureUnit.toUpperCase()}",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                currentData.getIcon(50.0, 50.0),
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
                                Text('${currentData.pressure} mb'),
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
                                Text('${currentData.visibility} m'),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Current conditions at ${currentData.getObservedTime()}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 24 Hours widget
                  const SizedBox(height: 10),
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: currentData.dayOrNight == 'day'
                            ? widgetBackgroundDayColors
                            : widgetBackgroundNightColors,
                      ),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        TwentyFourHoursSlide(
                          currentData: currentTwentyFourHoursData,
                        ),
                      ],
                    ),
                  ),

                  // 3 Hours widget
                  const SizedBox(height: 10),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: currentData.dayOrNight == 'day'
                            ? widgetBackgroundDayColors
                            : widgetBackgroundNightColors,
                      ),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        ThreeHoursSlide(
                          currentData: currentThreeHoursData,
                        ),
                      ],
                    ),
                  ),

                  // 10 Days widget
                  const SizedBox(height: 10),
                  Container(
                    height: 600,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: currentData.dayOrNight == 'day'
                            ? widgetBackgroundDayColors
                            : widgetBackgroundNightColors,
                      ),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        TenDaysSlide(
                          currentData: currentTenDaysData,
                        ),
                      ],
                    ),
                  ),

                  // Tide widget
                  const SizedBox(height: 10),
                  Container(
                    height: 600,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: currentData.dayOrNight == 'day'
                              ? widgetBackgroundDayColors
                              : widgetBackgroundNightColors),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        TideSlide(
                          seaData: currentSeaData,
                          tideData: currentTideData,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
  }
}
