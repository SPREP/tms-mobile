import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:macres/screens/user/login_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = new GlobalKey<FormState>();

  late String _username, _password, _name;

  validateEmail() {}

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final nameField = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Please enter your name" : null,
      onSaved: (value) => _name = value!,
      decoration: InputDecoration(
          label: Text("Name"), icon: Icon(Icons.account_circle)),
    );

    final usernameField = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Please enter email" : null,
      onSaved: (value) => _username = value!,
      decoration:
          InputDecoration(label: Text("Email"), icon: Icon(Icons.email)),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value!.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value!,
      decoration:
          InputDecoration(label: Text("Password"), icon: Icon(Icons.lock)),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          child: Text("Already have an account? Login",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ],
    );

    var doSignUp = () {
      final form = formKey.currentState;

      if (form!.validate()) {
        form.save();

        final Future successfulMessage =
            auth.register(_username, _password, _name);

        successfulMessage.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Sign up",
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context).then((value) => Navigator.pop(context));
          } else {
            Flushbar(
              title: "Failed to Sign up",
              message: response['message'] + " " + response['data']['message'],
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
        title: Text('Sign up'),
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
                nameField,
                SizedBox(height: 20.0),
                usernameField,
                SizedBox(height: 20.0),
                passwordField,
                SizedBox(height: 20.0),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Sign up", doSignUp, context),
                SizedBox(height: 5.0),
                forgotLabel
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
      child: Text('Sign up'),
    ),
  );
}
