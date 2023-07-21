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
    String activePageTitle = '';
    double height = AppBar().preferredSize.height + 40;

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

    return Scaffold(
      extendBodyBehindAppBar: _selectedPageIndex == 0 ? true : false,
      body: Container(
        padding: _selectedPageIndex == 0
            ? EdgeInsets.only(
                top: height,
                right: 10,
                left: 10,
              )
            : null,
        width: double.infinity,
        height: double.infinity,
        decoration: _selectedPageIndex == 0
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/windy_day.jpg'),
                  fit: BoxFit.cover,
                ),
              )
            : null,
        child: SingleChildScrollView(
          child: activePage,
        ),
      ),
      drawer: const MainDrawerWidget(),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: Colors.transparent,
        title: Text(activePageTitle),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: const Color.fromARGB(255, 110, 107, 99),
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
    );
  }
}
