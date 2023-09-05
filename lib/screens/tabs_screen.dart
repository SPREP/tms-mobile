import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macres/screens/event_report_screen.dart';
import 'package:macres/screens/event_screen.dart';
import 'package:macres/screens/notification_screen.dart';
import 'package:macres/screens/weather_forcast/weather_forcast_screen.dart';
import 'package:macres/widgets/main_drawer_widget.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  String _unit = 'f';

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  toFahrenheit(c) {
    return (c / 5) * 9 + 32;
  }

  void handleSelection(String value) {}

  @override
  Widget build(BuildContext context) {
    Widget activePage = const WeatherForcastScreen();
    String activePageTitle = 'Weather Forecast';
    double height = AppBar().preferredSize.height;
    List<Widget> actionButtons = [
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: PopupMenuButton<String>(
          onSelected: handleSelection,
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) {
            return {'Celsius', 'Fahrenheit'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _unit == 'c' && choice == 'Celsius'
                            ? const Icon(Icons.check)
                            : const Text(''),
                        _unit == 'f' && choice == 'Fahrenheit'
                            ? const Icon(Icons.check)
                            : const Text(''),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(choice),
                        const Spacer(),
                        choice == 'Celsius'
                            ? const Text('°C')
                            : const Text('°F'),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ),
    ];

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
      activePage = const EventReportScreen();
      activePageTitle = 'Event Report';
      actionButtons = [];
    }

    void openEventReportOverlay() {
      showModalBottomSheet(
          context: context, builder: (ctx) => const EventReportScreen());
    }

    return Container(
      decoration: _selectedPageIndex == 0
          ? const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/windy_day.jpg'),
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: Scaffold(
        backgroundColor: _selectedPageIndex == 0
            ? const Color.fromARGB(0, 82, 38, 38)
            : null,
        body: Container(
          padding: _selectedPageIndex == 0
              ? const EdgeInsets.only(
                  right: 5,
                  left: 5,
                )
              : null,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: activePage,
            ),
          ),
        ),
        drawer: const MainDrawerWidget(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Text(activePageTitle),
            actions: actionButtons,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: const Color.fromARGB(255, 95, 94, 94),
          unselectedItemColor: Colors.white54,
          selectedItemColor: Colors.white,
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
              icon: Icon(Icons.add),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              //icon: Icon(Icons.more_vert),
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
          currentIndex: _selectedPageIndex,
        ),
      ),
    );
  }
}
