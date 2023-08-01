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
    double height = AppBar().preferredSize.height + 60;

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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/sunny_day.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
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
              child: activePage,
            ),
          ),
          drawer: const MainDrawerWidget(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(activePageTitle),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
            ),
            /*
            bottom: const TabBar(
              tabs: [
                Tab(text: '24 HOURS'),
                Tab(text: '5 DAYS'),
                Tab(text: '16 DAYS')
              ],
            ),
            */
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            backgroundColor: Color.fromARGB(255, 95, 94, 94),
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
      ),
    );
  }
}
