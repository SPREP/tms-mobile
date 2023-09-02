import 'package:flutter/material.dart';
import 'package:macres/screens/about_screen.dart';
import 'package:macres/screens/help_screen.dart';
import 'package:macres/screens/national_number_screen.dart';
import 'package:macres/screens/settings_screen.dart';
import 'package:macres/screens/tabs_screen.dart';
import 'package:macres/screens/weather_forcast/weather_forcast_screen.dart';

class MainDrawerWidget extends StatelessWidget {
  const MainDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                      'https://img.freepik.com/premium-photo/portrait-pretty-cheerful-casual-african-girl-standing-isolated-white-wall_171337-97801.jpg'),
                ),
              ],
            ),
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            leading: Icon(Icons.home,
                size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const TabsScreen()),
            ),
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            leading: Icon(Icons.phone,
                size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text(
              'National Numbers',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NationalNumberScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            leading: Icon(Icons.settings,
                size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            leading: Icon(Icons.help,
                size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text(
              'Help',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            leading: Icon(Icons.info,
                size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text(
              'About',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
