import 'package:flutter/material.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/screens/forms/impact_report_form.dart';
import 'package:macres/screens/forms/request_assistance_form.dart';
import 'package:macres/screens/user/login_screen.dart';
import 'package:macres/util/user_preferences.dart';

class IsLogin extends StatefulWidget {
  final String next;

  IsLogin({super.key, required this.next});

  @override
  State<IsLogin> createState() => _IsLoginState();
}

class _IsLoginState extends State<IsLogin> {
  var pageTitle = 'Login';
  var nextPage = null;

  @override
  Widget build(BuildContext context) {
    Future<UserModel> getUserData() => UserPreferences().getUser();
    if (widget.next == 'impact') {
      nextPage = ImpactReportForm(eventId: 0);
    } else {
      nextPage = RequestAssistanceForm(eventId: 0);
    }

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
                return nextPage;
              }
          }
        },
      ),
    );
  }
}
