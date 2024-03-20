import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/providers/weather_location.dart';
import 'package:macres/screens/event_screen.dart';
import 'package:macres/screens/notification_screen.dart';
import 'package:macres/screens/report_screen.dart';
import 'package:macres/screens/tk_screen.dart';
import 'package:macres/screens/weather_forcast/weather_forcast_screen.dart';
import 'package:macres/widgets/main_drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if ((_selectedPageIndex == 0 || _selectedPageIndex == 2)) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: getLocationDropdown(),
          actions: actionButtons,
          foregroundColor: Colors.white,
        ),
      );
    } else {
      return AppBar(
        title: Text(activePageTitle),
        actions: actionButtons,
        backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
        foregroundColor: Colors.white,
      );
    }
  }

  Widget getLocationDropdown() {
    return Center(
        child: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        DropdownButton<Location>(
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
                  Provider.of<WeatherLocationProvider>(context, listen: false);
              weatherLocationProvider.setLocation(value);
            });
          },
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (_selectedPageIndex == 0 || _selectedPageIndex == 2) {
      activePage =
          WeatherForcastScreen(onCurrentWeatherChange: _onCurrentWeatherChange);
      if (bgFilePath == '') {
        bgFilePath = 'assets/images/splash.jpg';
      }
    }

    return Container(
      width: width,
      decoration: _selectedPageIndex == 0 || _selectedPageIndex == 2
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
        backgroundColor: _selectedPageIndex == 0 || _selectedPageIndex == 2
            ? const Color.fromARGB(0, 82, 38, 38)
            : null,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: Container(
              padding: _selectedPageIndex == 0 || _selectedPageIndex == 2
                  ? const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    )
                  : null,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: activePage,
              ),
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
                      color: Color.fromARGB(255, 233, 232, 232), width: 1.0))),
          child: BottomNavigationBar(
            onTap: _selectPage,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_available_rounded),
                label: 'Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                label: 'More',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.warning),
                label: 'Warnings',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/images/bird_icon.png'),
                ),
                label: 'TK',
              ),
            ],
            currentIndex: _selectedPageIndex,
          ),
        ),
      ),
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;

      if (_selectedPageIndex == 0 || _selectedPageIndex == 2) {
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
        actionButtons = [];
      }

      if (_selectedPageIndex == 3) {
        activePage = const NotificationScreen();
        activePageTitle = 'Warnings';
        actionButtons = [];
      }

      if (_selectedPageIndex == 4) {
        activePage = const TkScreen();
        activePageTitle = 'Traditional Knowledge';
        actionButtons = [];
      }

      if (_selectedPageIndex == 2) {
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
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        elevation: 10.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) => DraggableScrollableSheet(
            snap: true,
            expand: false,
            builder: (_, controller) => const ReportScreen()));
  }
}
