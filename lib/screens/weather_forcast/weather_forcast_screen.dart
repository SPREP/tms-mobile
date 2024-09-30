import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/warning_model.dart';
import 'package:macres/models/sea_model.dart';
import 'package:macres/models/tide_model.dart';
import 'package:macres/models/weather_model.dart';
import 'package:macres/providers/weather_location.dart';
import 'package:macres/screens/weather_forcast/three_hrs_slide.dart';
import 'package:macres/screens/weather_forcast/tendays_slide.dart';
import 'package:macres/screens/weather_forcast/tide_slide.dart';
import 'package:macres/screens/weather_forcast/twentyfour_hrs_slide.dart';
import 'package:macres/widgets/warning_widget.dart';
import 'package:macres/widgets/weather_property_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:macres/models/settings_model.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class WeatherForcastScreen extends StatefulWidget {
  WeatherForcastScreen({super.key, required this.onCurrentWeatherChange});

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
    const Color.fromARGB(255, 21, 123, 207),
    Color.fromARGB(255, 22, 83, 133),
  ];

  List<Color> widgetBackgroundNightColors = <Color>[
    Color.fromARGB(255, 74, 78, 82),
    Color.fromARGB(255, 20, 24, 27)
  ];

  late WarningModel warningData;

  bool isLoading = false;
  late Timer _timerWeather;
  String dateTime = DateFormat("EEE dd MMM").format(DateTime.now());

  @override
  void initState() {
    _timerWeather = Timer.periodic(
      const Duration(minutes: 2),
      (Timer t) => getWeather(),
    );

    warningData = WarningModel();

    setLocation();
    setState(() {
      isLoading = true;
      getWeather();
      getWarning();
    });

    super.initState();
  }

  void dateTimeUpdate() {
    setState(() {
      dateTime = DateFormat("EEE dd MMM").format(DateTime.now());
    });
  }

  @override
  void dispose() {
    myController.dispose();
    _timerWeather.cancel(); //cancel the timer here
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

  getWarning() async {
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;

    var prefs = await SharedPreferences.getInstance();
    var lng = prefs.getString('user_language');

    String endpoint = '/warning/$lng?_format=json';

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
        WarningModel loadedItem = WarningModel();

        for (final item in listData.entries) {
          final warningLevel = int.parse(item.value['level']);
          // Only show warning notification
          if (warningLevel != 2 && warningLevel != 3) continue;

          //Only show warning for today
          if (isToday(int.parse(item.value['timestamp']))) {
            loadedItem = WarningModel(
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
          warningData = loadedItem;
          //isLoading = false;
        });

        return loadedItem;
      }
    } catch (e) {
      /*
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text('Error: Unable to load .'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      */
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
            TideModel tideModel = TideModel(
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
            SeaModel seaModel = SeaModel(
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
            TenDaysForecastModel dataModel = TenDaysForecastModel(
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
            CurrentWeatherModel dataModel = CurrentWeatherModel(
                location: item[0],
                iconId: int.parse(item[1]),
                currentTemp: item[2],
                humidity: item[3],
                pressure: item[4],
                windDirection: item[5],
                windSpeed: item[6],
                visibility: item[7],
                observedDate: item[8],
                windDirectionDegree: item[9],
                solarRadiation: item[10],
                station: item[11]);

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
              // visibility: item[6],
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
    AppLocalizations localizations = AppLocalizations.of(context)!;

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
                        if (warningData.body != null)
                          WarningWidget(warning: warningData)
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
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(children: [
                            Text(
                                '${localizations.weatherCurrentConditionTitle}'),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  dateTime,
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 226, 226, 226)),
                                ),
                                const Spacer(),
                                Text(
                                  locationLabel[selectedLocation].toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
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
                              height: 0,
                            ),
                            Row(
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(
                                          "${currentData.currentTemp}",
                                          style: const TextStyle(
                                              fontSize: 60,
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.left,
                                        ),
                                        Align(
                                          heightFactor: 1.5,
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            "\u00B0${selectedTempretureUnit.toUpperCase()}",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ]),
                                      Text(
                                        currentData
                                            .getIconDefinition(context)
                                            .toString(),
                                        style: TextStyle(fontSize: 19),
                                      ),
                                    ]),
                                Column(
                                  children: [
                                    Container(
                                      height: 130.0,
                                      width: 130.0,
                                      child: currentData.getIcon(),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ]),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherProperty(
                              title:
                                  '${localizations.weatherCurrentConditionHumidity}',
                              value: currentData.humidity,
                              unit: '%',
                              icon: Icon(
                                WeatherIcons.humidity,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            WeatherProperty(
                              title:
                                  '${localizations.weatherCurrentConditionPressure}',
                              value: currentData.pressure,
                              unit: 'mb',
                              icon: Icon(
                                WeatherIcons.barometer,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            WeatherProperty(
                                title:
                                    '${localizations.weatherCurrentConditionWindSpeed}',
                                value: currentData.windSpeed,
                                unit: 'km/h',
                                icon: Icon(
                                  WeatherIcons.strong_wind,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherProperty(
                              title:
                                  '${localizations.weatherCurrentConditionWindDirection}',
                              value: currentData.windDirection,
                              unit: '',
                              icon: Container(
                                height: 38.0,
                                child: WindIcon(
                                  degree:
                                      currentData.windDirectionDegree != null
                                          ? num.parse(
                                              currentData.windDirectionDegree!)
                                          : 0,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ),
                            WeatherProperty(
                              title:
                                  '${localizations.weatherCurrentConditionVisibility}',
                              value: currentData.visibility,
                              unit: 'km',
                              icon: Icon(
                                Icons.visibility_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            WeatherProperty(
                              title:
                                  '${localizations.weatherCurrentConditionSolarRadiation}',
                              value: currentData.solarRadiation,
                              unit: 'W/m\u00b2',
                              icon: Icon(
                                Icons.solar_power_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${localizations.weatherCurrentConditionFooter} ${currentData.station} ${currentData.getObservedTime()}',
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
                    height: 400,
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
                        ThreeHoursSlide(
                          currentData: currentThreeHoursData,
                        ),
                      ],
                    ),
                  ),

                  // 10 Days widget
                  const SizedBox(height: 10),
                  Container(
                    // height: 650,
                    height: 150,
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
                    margin: EdgeInsets.only(bottom: 10.0),
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
