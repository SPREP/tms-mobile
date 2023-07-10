import 'package:flutter/material.dart';
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
    String activePageTitle = 'Weather Forcast screen';

    if (_selectedPageIndex == 1) {
      activePage = const EventScreen();
      activePageTitle = 'Events';
    }

    if (_selectedPageIndex == 2) {
      activePage = const NotificationScreen();
      activePageTitle = 'Notifications';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const MainDrawerWidget(),
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: const Color.fromARGB(255, 110, 107, 99),
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_available_rounded), label: 'Events'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notification')
        ],
        currentIndex: _selectedPageIndex,
      ),
    );
  }
}
