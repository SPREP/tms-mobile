import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:macres/screens/event_screen.dart';
import 'package:macres/screens/notification_screen.dart';
import 'package:macres/screens/report_screen.dart';
import 'package:macres/screens/weather_forcast/weather_forcast_screen.dart';
import 'package:macres/widgets/main_drawer_widget.dart';
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

  String _onCurrentWeatherChange(String filepath, String dayOrNight) {
    setState(() {
      bgFilePath = filepath;
      dayOrNightStatus = dayOrNight;
    });

    return filepath;
  }

  @override
  void initState() {
    actionButtons = [actionFilter()];
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
    if (dayOrNightStatus == 'night' &&
        (_selectedPageIndex == 0 || _selectedPageIndex == 2)) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(activePageTitle),
          actions: actionButtons,
          foregroundColor: Colors.white,
        ),
      );
    } else {
      return PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(activePageTitle),
          actions: actionButtons,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
        ),
      );
    }
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
              image: DecorationImage(
                image: AssetImage(bgFilePath),
                fit: BoxFit.cover,
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
            unselectedItemColor: const Color.fromARGB(133, 18, 17, 17),
            selectedItemColor: const Color.fromARGB(255, 42, 35, 228),
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
                label: 'Report',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification',
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
            onCurrentWeatherChange: _onCurrentWeatherChange);
        activePageTitle = DateFormat("EEE dd MMM yyyy").format(DateTime.now());
        actionButtons = [actionFilter()];
      }

      if (_selectedPageIndex == 1) {
        activePage = const EventScreen();
        activePageTitle = 'Events';
        actionButtons = [];
      }

      if (_selectedPageIndex == 3) {
        activePage = const NotificationScreen();
        activePageTitle = 'Notifications';
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
            expand: false, builder: (_, controller) => const ReportScreen()));
  }
}
