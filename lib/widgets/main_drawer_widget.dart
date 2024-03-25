import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:macres/providers/user_provider.dart';
import 'package:macres/screens/about_screen.dart';
import 'package:macres/screens/contact_screen.dart';
import 'package:macres/screens/national_number_screen.dart';
import 'package:macres/screens/settings_screen.dart';
import 'package:macres/screens/tabs_screen.dart';
import 'package:macres/screens/user/login_screen.dart';
import 'package:macres/screens/user/profile_screen.dart';
import 'package:macres/screens/user/signup_screen.dart';
import 'package:macres/util/user_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawerWidget extends StatefulWidget {
  MainDrawerWidget({super.key});

  @override
  State<MainDrawerWidget> createState() => _MainDrawerWidgetState();
}

class _MainDrawerWidgetState extends State<MainDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    Future<UserModel> getUserData() => UserPreferences().getUser();

    Consumer<AuthProvider> authConsumer =
        Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Text(
                'Edit',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                authProvider.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const TabsScreen()),
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              )),
        ],
      );
    });

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(92, 125, 138, 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar
                Consumer2<UserProvider, AuthProvider>(
                  builder: (context, userProvider, authProvider, child) {
                    if (authProvider.loggedInStatus == Status.LoggedIn) {
                      return CircleAvatar(
                        radius: 60,
                        child: ClipOval(
                          child: Image.network(
                            userProvider.user.photo.toString(),
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                          ),
                        ),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 60,
                        child: ClipOval(
                          child: Image.network(
                            'https://macres-media-storage.s3.ap-southeast-2.amazonaws.com/user.png',
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                // Login/Logout buttons.
                Consumer2<UserProvider, AuthProvider>(
                  builder: (context, userProvider, authProvider, child) {
                    if (authProvider.loggedInStatus != Status.LoggedIn) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Render Edit and Logout buttons.
                      return authConsumer;
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Color.fromARGB(255, 98, 97, 97),
            ),
            leading: Icon(Icons.home,
                size: 26, color: Color.fromARGB(255, 98, 97, 97)),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 17,
                  ),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const TabsScreen()),
            ),
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 15, color: Color.fromARGB(255, 98, 97, 97)),
            leading: Icon(Icons.phone_outlined,
                size: 26, color: Color.fromARGB(255, 98, 97, 97)),
            title: Text(
              'National Numbers',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 17,
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
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 15, color: Color.fromARGB(255, 98, 97, 97)),
            leading: Icon(Icons.settings,
                size: 26, color: Color.fromARGB(255, 98, 97, 97)),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 17,
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
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 15, color: Color.fromARGB(255, 98, 97, 97)),
            leading: Icon(Icons.help,
                size: 26, color: Color.fromARGB(255, 98, 97, 97)),
            title: Text(
              'Contact',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 17,
                  ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ContactScreen()),
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 15, color: Color.fromARGB(255, 98, 97, 97)),
            leading: Icon(Icons.info,
                size: 26, color: Color.fromARGB(255, 98, 97, 97)),
            title: Text(
              'About',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 17,
                  ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          const Spacer(),
          const Text(
            'Version ' + AppConfig.version,
            style: TextStyle(fontSize: 13),
          ),
          const Text('Tonga Meteorological Service',
              style: TextStyle(fontSize: 13)),
          InkWell(
            onTap: () => launchUrl(
                Uri.parse('http://app.met.gov.to/app/privacy-policy')),
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  color: Colors.blue),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
