import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:macres/util/user_preferences.dart';
import 'package:macres/widgets/image_input.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = new GlobalKey<FormState>();

  late String _username;
  File _selectedImage = new File('');

  validateEmail() {}

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    Future<UserModel> getUserData() => UserPreferences().getUser();

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

    var doProfile = () {
      final form = formKey.currentState;

      if (form!.validate()) {
        form.save();
        UserModel user = new UserModel();
        final Future successfulMessage = auth.profileUpdate(user);

        successfulMessage.then((response) {
          if (response['status_code'] == 200) {
            Flushbar(
              title: "Profile Password Success",
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context).then((value) => Navigator.pop(context));
          } else if (response['status_code'] < 500) {
            Flushbar(
              title: "Profile Password",
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

    return FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text('User Profile'),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(40.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _selectedImage.path == ''
                            ? CircleAvatar(
                                radius: 60,
                                child: ClipOval(
                                    child: Image.network(
                                  snapshot.data!.photo.toString(),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fill,
                                  alignment: Alignment.center,
                                )),
                              )
                            : CircleAvatar(
                                radius: 60,
                                child: ClipOval(
                                    child: Image.file(
                                  _selectedImage,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fill,
                                  alignment: Alignment.center,
                                ))),
                        TextButton.icon(
                          onPressed: _getImage,
                          icon: const Icon(Icons.camera),
                          label: const Text('Choose Profile Photos'),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(height: 20.0),
                        Text('Name: ' + snapshot.data!.name.toString()),
                        SizedBox(height: 20.0),
                        Text('Email: ' + snapshot.data!.email.toString()),
                        SizedBox(height: 20.0),
                        longButtons("Update", doProfile, context),
                        SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text('User Profile'),
                ),
                body: CircularProgressIndicator());
          }
        });
  }

  Widget longButtons(String title, fun, context) {
    return SizedBox(
      height: 45,
      width: 200,
      child: ElevatedButton(
        onPressed: fun,
        child: Text(title),
      ),
    );
  }

  Future _getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = File(pickedImage.path);
    }
    setState(() {});
  }
}
