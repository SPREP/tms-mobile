import 'package:flutter/material.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  final UserModel? user;

  Dashboard({Key? key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user!);

    return Scaffold(
      body: Container(
        child: Center(
          child: Text("USER DASHBOARD PAGE"),
        ),
      ),
    );
  }
}
