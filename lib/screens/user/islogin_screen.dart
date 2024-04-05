import 'package:flutter/material.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/screens/user/login_screen.dart';
import 'package:macres/util/user_preferences.dart';

class IsLogin extends StatefulWidget {
  final dynamic destination;

  IsLogin({super.key, required this.destination});

  @override
  State<IsLogin> createState() => _IsLoginState();
}

class _IsLoginState extends State<IsLogin> {
  var pageTitle = 'Login';

  @override
  Widget build(BuildContext context) {
    Future<UserModel> getUserData() => UserPreferences().getUser();

    return Scaffold(
      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else if (snapshot.data?.token == null) {
                return LoginScreen();
              } else {
                return widget.destination;
              }
          }
        },
      ),
    );
  }
}
