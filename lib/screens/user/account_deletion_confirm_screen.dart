import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class AccountDeletion extends StatefulWidget {
  const AccountDeletion({super.key});

  @override
  State<AccountDeletion> createState() => _AccountDeletionState();
}

class _AccountDeletionState extends State<AccountDeletion> {
  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account deletion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Text('Are you sure you want to delete your account?'),
              height: 50.0,
            ),
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      var deleteStatus = await auth.delete();
                      var msg = '';
                      if (deleteStatus) {
                        msg = 'Your account has been successfully deleted.';
                      } else {
                        msg =
                            'Unable to delete your account, please try again later.';
                      }

                      Flushbar(
                        title: "User Profile",
                        message: msg,
                        duration: Duration(seconds: 3),
                      ).show(context).then((value) => Navigator.of(context)
                        ..pop()
                        ..pop());
                    },
                  ),
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context)..pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
