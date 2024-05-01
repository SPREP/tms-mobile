import 'package:flutter/material.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:macres/screens/user/login_screen.dart';
import 'package:macres/util/user_preferences.dart';
import 'package:provider/provider.dart';

class IsLogin extends StatefulWidget {
  final dynamic destination;

  IsLogin({super.key, required this.destination});

  @override
  State<IsLogin> createState() => _IsLoginState();
}

class _IsLoginState extends State<IsLogin> {
  var pageTitle = 'Login';
  UserModel user = new UserModel();

  AuthProvider authprovider = new AuthProvider();
  Future<UserModel> getUserData() => UserPreferences().getUser();

  Future<UserModel> getUser() async {
    user = await getUserData();
    authprovider.isLogin(user);
    return user;
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getUser(),
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
                print(snapshot.data!.name.toString());
                return widget.destination;
              }
          }
        },
      ),
    );
  }
}
