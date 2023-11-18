import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final formKey = new GlobalKey<FormState>();

  late String _username;

  validateEmail() {}

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Please enter email" : null,
      onSaved: (value) => _username = value!,
      decoration:
          InputDecoration(label: Text("Email"), icon: Icon(Icons.email)),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Processing ... Please wait")
      ],
    );

    var doForgot = () {
      final form = formKey.currentState;

      if (form!.validate()) {
        form.save();

        final Future successfulMessage = auth.forgot(_username);

        successfulMessage.then((response) {
          if (response['status_code'] == 200) {
            Flushbar(
              title: "Forgot Password Success",
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context).then((value) => Navigator.pop(context));
          } else if (response['status_code'] < 500) {
            Flushbar(
              title: "Forgot Password",
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          } else {
            Flushbar(
              title: "Error",
              message: "Try again later",
              duration: Duration(seconds: 5),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                usernameField,
                SizedBox(height: 20.0),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Submit", doForgot, context),
                SizedBox(height: 5.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget longButtons(String title, fun, context) {
  return SizedBox(
    height: 45,
    width: 200,
    child: ElevatedButton(
      onPressed: fun,
      child: Text('Submit'),
    ),
  );
}
