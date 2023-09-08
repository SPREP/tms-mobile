import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macres/screens/event_report_screen.dart';
import 'package:macres/screens/event_screen.dart';
import 'package:macres/screens/notification_screen.dart';
import 'package:macres/screens/report_screen.dart';
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
  final String _unit = 'f';
  Widget activePage = const WeatherForcastScreen();
  String activePageTitle = 'Weather Forecast';
  List<Widget> actionButtons = [];

  @override
  void initState() {
    actionButtons = [actionFilter()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = AppBar().preferredSize.height;

    return Container(
      decoration: _selectedPageIndex == 0 || _selectedPageIndex == 2
          ? const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/windy_day.jpg'),
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: Scaffold(
        backgroundColor: _selectedPageIndex == 0 || _selectedPageIndex == 2
            ? const Color.fromARGB(0, 82, 38, 38)
            : null,
        body: Container(
          padding: _selectedPageIndex == 0 || _selectedPageIndex == 2
              ? const EdgeInsets.only(
                  right: 5,
                  left: 5,
                )
              : null,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: activePage,
            ),
          ),
        ),
        drawer: const MainDrawerWidget(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: AppBar(
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
          unselectedItemColor: Color.fromARGB(133, 18, 17, 17),
          selectedItemColor: Color.fromARGB(255, 42, 35, 228),
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
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;

      if (_selectedPageIndex == 0 || _selectedPageIndex == 2) {
        activePage = const WeatherForcastScreen();
        activePageTitle = 'Weather Forecast';
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

  actionFilter() {
    return Padding(
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

  toFahrenheit(c) {
    return (c / 5) * 9 + 32;
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
