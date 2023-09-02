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

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const WeatherForcastScreen();
    String activePageTitle = 'Weather Forecast';
    double height = AppBar().preferredSize.height;

    if (_selectedPageIndex == 1) {
      activePage = const EventScreen();
      activePageTitle = 'Events';
    }

    if (_selectedPageIndex == 2) {
      activePage = const NotificationScreen();
      activePageTitle = 'Notifications';
    }

    if (_selectedPageIndex == 3) {
      activePage = const EventReportScreen();
      activePageTitle = 'Event Report';
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
        body:

        Container(
          padding: _selectedPageIndex == 0
              ? const EdgeInsets.only(
                  right: 5,
                  left: 5,
                )
              : null,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(padding:EdgeInsets.only(top:5, bottom: 5), child: activePage,),
          ),
        ),
        drawer: const MainDrawerWidget(),
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(activePageTitle),
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
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Event Report',
            ),
          ],
          currentIndex: _selectedPageIndex,
        ),
      ),
    );
  }
}
