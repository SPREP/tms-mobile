import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/providers/dark_theme_provider.dart';
import 'package:macres/providers/sun_provider.dart';
import 'package:macres/providers/weather_location.dart';
import 'package:macres/screens/evacuation_map_screen.dart';
import 'package:macres/screens/event_screen.dart';
import 'package:macres/screens/warning_screen.dart';
import 'package:macres/screens/report_screen.dart';
import 'package:macres/screens/weather_forcast/weather_forcast_screen.dart';
import 'package:macres/widgets/main_drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:macres/util/magnifier.dart' as Mag;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  DateTime dt = DateTime.now();
  int _selectedPageIndex = 0;
  late Widget activePage;
  String activePageTitle = '';
  List<Widget> actionButtons = [];
  String bgFilePath = '';
  Location selectedLocation = Location.tongatapu;
  bool visibility = false;
  late AppLocalizations localizations;

  String _onCurrentWeatherChange(String filepath, bool dayOrNight) {
    setState(() {
      bgFilePath = filepath;
    });

    return filepath;
  }

  @override
  void initState() {
    actionButtons = [];
    activePageTitle = DateFormat("EEE dd MMM yyyy").format(DateTime.now());

    super.initState();
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  getAppBar(backgroundColor) {
    if ((_selectedPageIndex == 0 || _selectedPageIndex == 4)) {
      return PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: getLocationDropdown(backgroundColor),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  visibility = !visibility;
                });
              },
              child: Icon(
                visibility ? Icons.search : Icons.search_off_rounded,
                color: Colors.white,
              ),
            ),
          ],
          foregroundColor: Colors.white,
        ),
      );
    } else {
      return AppBar(
        centerTitle: false,
        title: Text(activePageTitle),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                visibility = !visibility;
              });
            },
            child: Icon(
              visibility ? Icons.search : Icons.search_off_rounded,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
  }

  Widget getLocationDropdown(backgroundColor) {
    return Center(
        child: Column(
      children: [
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          margin: EdgeInsets.only(bottom: 3.0),
          height: 30.0,
          decoration: BoxDecoration(
              color: backgroundColor[0],
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButton<Location>(
            underline: SizedBox(),
            borderRadius: BorderRadius.circular(10),
            value: selectedLocation,
            dropdownColor: backgroundColor[0],
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

                WeatherLocationProvider weatherLocationProvider =
                    Provider.of<WeatherLocationProvider>(context,
                        listen: false);
                weatherLocationProvider.setLocation(value);
              });
            },
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    this.localizations = AppLocalizations.of(context)!;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    int _totalNewWarnings = 0;
    int _totalNewEvents = 0;

    if (_selectedPageIndex == 0 || _selectedPageIndex == 4) {
      activePage =
          WeatherForcastScreen(onCurrentWeatherChange: _onCurrentWeatherChange);
      if (bgFilePath == '') {
        bgFilePath = 'assets/images/splash.jpg';
      }
    }

    return Consumer2<SunProvider, ThemeProvider>(
        builder: (context, sunProvider, themeProvider, child) {
      List<Color> backgroundColor = _getColor(sunProvider, themeProvider);

      return Mag.Magnifier(
        size: Size(250.0, 250.0),
        enabled: visibility ? true : false,
        child: Container(
          width: width,
          decoration: _selectedPageIndex == 0 || _selectedPageIndex == 4
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: backgroundColor,
                  ),
                )
              : null,
          child: Scaffold(
            backgroundColor: _selectedPageIndex == 0 || _selectedPageIndex == 4
                ? const Color.fromARGB(0, 82, 38, 38)
                : null,
            body: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Container(
                padding: _selectedPageIndex == 0 || _selectedPageIndex == 4
                    ? const EdgeInsets.only(
                        right: 5,
                        left: 5,
                      )
                    : null,
                child: activePage,
              ),
            ),
            drawer: MainDrawerWidget(),
            appBar: getAppBar(backgroundColor),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(
                          color: Color.fromARGB(255, 233, 232, 232),
                          width: 1.0))),
              child: BottomNavigationBar(
                onTap: _selectPage,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: this.localizations.tabLabelHome,
                  ),
                  BottomNavigationBarItem(
                      label: this.localizations.tabLabelEvents,
                      icon: _totalNewEvents < 1
                          ? Icon(Icons.event)
                          : Stack(
                              children: <Widget>[
                                Icon(Icons.event),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 14,
                                      minHeight: 14,
                                    ),
                                    child: Text(
                                      _totalNewEvents.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            )),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.directions),
                    label: this.localizations.tabLabelEvacuation,
                  ),
                  BottomNavigationBarItem(
                    label: this.localizations.tabLabelWarning,
                    icon: _totalNewWarnings < 1
                        ? Icon(Icons.warning)
                        : Stack(
                            children: <Widget>[
                              Icon(Icons.warning),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 14,
                                  ),
                                  child: Text(
                                    _totalNewWarnings.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle_outline),
                    label: this.localizations.tabLabelMore,
                  ),
                ],
                currentIndex: _selectedPageIndex,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;

      if (_selectedPageIndex == 0 || _selectedPageIndex == 4) {
        activePage = WeatherForcastScreen(
          onCurrentWeatherChange: _onCurrentWeatherChange,
        );

        activePageTitle = DateFormat("EEE dd MMM yyyy").format(DateTime.now());

        // Remove Action items that include Celsius or Fahrenheit selection.
        // @TODO if not needed then clean up the code.
        // actionButtons = [actionFilter()];
      }

      if (_selectedPageIndex == 1) {
        activePage = const EventScreen();
        activePageTitle = this.localizations.pageTitleEvents;
      }

      if (_selectedPageIndex == 3) {
        activePage = const WarningScreen();
        activePageTitle = this.localizations.pageTitleWarning;
      }

      if (_selectedPageIndex == 2) {
        activePage = EvacuationMapScreen();
        activePageTitle = this.localizations.pageTitleEvacuation;
      }

      if (_selectedPageIndex == 4) {
        openEventReportOverlay();
      }
    });
  }

  getSavedTempUnit() async {
    var prefs = await SharedPreferences.getInstance();
    var tempUnit = prefs.getString('tempreture_unit');
    return tempUnit;
  }

  saveTempUnit(String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('tempreture_unit', value);
  }

  getTkAction() {
    //Add indicator button
    var indicator = IconButton(onPressed: () {}, icon: Icon(Icons.add));

    //Map View
    var mapView = IconButton(
      icon: Icon(Icons.map),
      onPressed: () {},
    );

    //List View
    var listView = IconButton(
      icon: Icon(Icons.list),
      onPressed: () {},
    );

    return [indicator, mapView, listView];
  }

  actionFilter() {
    var selectedTempUnit = 'c';
    var savedUnit = getSavedTempUnit();

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (savedUnit == '') {
            if (value.toLowerCase() == 'fahrenheit') {
              saveTempUnit('f');
              selectedTempUnit = 'f';
            }

            if (value.toLowerCase() == 'celsius') {
              saveTempUnit('s');
              selectedTempUnit = 's';
            }
          } else {
            selectedTempUnit = savedUnit.toString();
          }
          setState(() {});
        },
        icon: const Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) {
          return {'Celsius', 'Fahrenheit'}.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Column(
                children: [
                  Row(
                    children: [
                      selectedTempUnit == 'c' && choice == 'Celsius'
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                            )
                          : const Text(''),
                      selectedTempUnit == 'f' && choice == 'Fahrenheit'
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                            )
                          : const Text(''),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(choice),
                      const Spacer(),
                      choice == 'Celsius' ? const Text('°C') : const Text('°F'),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }

  void handleSelection(String value) {}

  void openEventReportOverlay() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      elevation: 10.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        side: BorderSide(color: Colors.white, width: 1.0),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => const ReportScreen(),
      ),
    );
  }

  _getColor(SunProvider sunProvider, ThemeProvider themeProvider) {
    List<Color> backgroundColor = [];
    List<Color> nightColor = [
      Color.fromARGB(255, 64, 65, 67),
      Color.fromARGB(255, 20, 24, 27)
    ];
    List<Color> dayColor = [Color.fromARGB(255, 3, 55, 97), Colors.blue];

    //manage the color here base on time/theme
    if (sunProvider.currentSunData.isDay()) {
      if (themeProvider.isDarkTheme) {
        backgroundColor = nightColor;
      } else {
        backgroundColor = dayColor;
      }
    } else {
      backgroundColor = nightColor;
    }
    return backgroundColor;
  }
}
