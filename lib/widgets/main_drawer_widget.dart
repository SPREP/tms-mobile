import 'package:flutter/material.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:macres/screens/about_screen.dart';
import 'package:macres/screens/help_screen.dart';
import 'package:macres/screens/national_number_screen.dart';
import 'package:macres/screens/settings_screen.dart';
import 'package:macres/screens/tabs_screen.dart';
import 'package:macres/screens/user/login_screen.dart';
import 'package:macres/screens/user/profile_screen.dart';
import 'package:macres/screens/user/signup_screen.dart';
import 'package:macres/util/user_preferences.dart';
import 'package:provider/provider.dart';

class MainDrawerWidget extends StatefulWidget {
  MainDrawerWidget({super.key});

  @override
  State<MainDrawerWidget> createState() => _MainDrawerWidgetState();
}

class _MainDrawerWidgetState extends State<MainDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    Future<UserModel> getUserData() => UserPreferences().getUser();

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CircleAvatar(
                          radius: 60,
                          child: ClipOval(
                              child: Image.network(
                            snapshot.data!.photo.toString(),
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                          )),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
                SizedBox(
                  width: 20,
                ),
                Consumer<AuthProvider>(builder: (context, authProvider, child) {
                  if (authProvider.loggedInStatus == Status.LoggedIn) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()),
                              );
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            )),
                        TextButton(
                            onPressed: () {
                              authProvider.logout();
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    );
                  } else {
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
                          ), //login or Logou
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
                          ), //login or Logou
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            leading: Icon(Icons.home, size: 26),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
            leading: Icon(Icons.phone_outlined, size: 26),
            title: Text(
              'National Numbers',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
            leading: Icon(Icons.settings, size: 26),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
            leading: Icon(Icons.help, size: 26),
            title: Text(
              'Help',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
            leading: Icon(Icons.info, size: 26),
            title: Text(
              'About',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
          const Spacer(),
          const Text(
            'Version 1.0',
            style: TextStyle(fontSize: 13),
          ),
          const Text('Tonga Meteorological Service',
              style: TextStyle(fontSize: 13)),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
