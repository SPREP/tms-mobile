import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/main.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/providers/event_counter_provider.dart';
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
  String dayOrNightStatus = 'day';
  Location selectedLocation = Location.tongatapu;
  bool visibility = false;

  String _onCurrentWeatherChange(String filepath, String dayOrNight) {
    setState(() {
      bgFilePath = filepath;
      dayOrNightStatus = dayOrNight;
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

  getAppBar() {
    if ((_selectedPageIndex == 0 || _selectedPageIndex == 4)) {
      return PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: getLocationDropdown(),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  visibility = !visibility;
                });
              },
              child: Icon(
                visibility ? Icons.visibility : Icons.visibility_off,
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
              visibility ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
  }

  Widget getLocationDropdown() {
    return Center(
        child: Column(
      children: [
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          margin: EdgeInsets.only(bottom: 3.0),
          height: 30.0,
          decoration: BoxDecoration(
              color: dayOrNightStatus == 'day'
                  ? Color.fromARGB(255, 26, 99, 152)
                  : Color.fromARGB(255, 88, 88, 88),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButton<Location>(
            underline: SizedBox(),
            borderRadius: BorderRadius.circular(10),
            value: selectedLocation,
            dropdownColor: dayOrNightStatus == 'day'
                ? Color.fromARGB(255, 33, 123, 187)
                : Color.fromARGB(255, 70, 73, 76),
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
                  colors: dayOrNightStatus == 'day'
                      ? <Color>[Color.fromARGB(255, 3, 55, 97), Colors.blue]
                      : <Color>[
                          Color.fromARGB(255, 64, 65, 67),
                          Color.fromARGB(255, 20, 24, 27)
                        ],
                ),
              )
            : null,
        child: Scaffold(
          backgroundColor: _selectedPageIndex == 0 || _selectedPageIndex == 4
              ? const Color.fromARGB(0, 82, 38, 38)
              : null,
          body: SingleChildScrollView(
            child: ConstrainedBox(
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
          ),
          drawer: MainDrawerWidget(),
          appBar: getAppBar(),
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
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    label: 'Events',
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
                  label: 'Evacuation',
                ),
                BottomNavigationBarItem(
                  label: 'Warnings',
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
                  label: 'More',
                ),
              ],
              currentIndex: _selectedPageIndex,
            ),
          ),
        ),
      ),
    );
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
        activePageTitle = 'Events';
      }

      if (_selectedPageIndex == 3) {
        activePage = const WarningScreen();
        activePageTitle = 'Warnings';
      }

      if (_selectedPageIndex == 2) {
        activePage = EvacuationMapScreen();
        activePageTitle = 'Evacuation Map';
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
        builder: (context) => DraggableScrollableSheet(
            expand: false, builder: (_, controller) => const ReportScreen()));
  }
}
