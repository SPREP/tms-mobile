import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:macres/providers/user_provider.dart';
import 'package:macres/screens/user/signup_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = new GlobalKey<FormState>();

  late String _username, _password;

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
          child: Text("Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
        TextButton(
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
        ),
      ],
    );

    var doLogin = () {
      final form = formKey.currentState;

      if (form!.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(_username, _password);

        successfulMessage.then((response) {
          if (response['status_code'] == 200) {
            UserModel user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Flushbar(
              title: "Login Success",
              message: "You have successfully logged in",
              duration: Duration(seconds: 3),
            ).show(context).then(
                  (value) => Navigator.pop(context),
                );
          } else {
            Flushbar(
              title: "Failed Login",
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                passwordField,
                SizedBox(height: 20.0),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Login", doLogin),
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

Widget longButtons(String title, fun) {
  return SizedBox(
    height: 45,
    width: 200,
    child: ElevatedButton(
      onPressed: fun,
      child: Text('Login'),
    ),
  );
}
