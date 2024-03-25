import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:macres/providers/user_provider.dart';
import 'package:macres/util/get_image_url.dart';
import 'package:macres/util/upload_file.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = new GlobalKey<FormState>();
  bool isLoading = false;

  File _selectedImage = new File('');

  validateEmail() {}

  var loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Updating... Please wait")
    ],
  );

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    var doProfile = () async {
      //if  _selectedImage is not empty then upload the file to get the url
      if (_selectedImage != '') {
        GetImageUrl imageUrl = GetImageUrl();
        await imageUrl.call(p.extension(_selectedImage.path));
        if (imageUrl.success) {
          try {
            UploadFile uploadFile = UploadFile();
            await uploadFile.call(
                imageUrl.uploadUrl, File(_selectedImage.path));

            if (uploadFile.isUploaded != false && uploadFile.isUploaded) {
              var userUpdate = [
                {'photo': imageUrl.downloadUrl}
              ];

              //Now its time to update the user
              var response = await auth.profileUpdate(userUpdate, context);
              setState(() {});

              if (response['status_code'] < 500) {
                Flushbar(
                  title: "User Profile",
                  message: response['message'],
                  duration: Duration(seconds: 3),
                ).show(context).then((value) => Navigator.pop(context));
              } else {
                Flushbar(
                  title: "Failed to Update",
                  message: response['message'],
                  duration: Duration(seconds: 5),
                ).show(context);
              }
              isLoading = false;

              return true;
            } else {
              throw uploadFile.message;
            }
          } catch (e) {
            throw ("Error ${e.toString()}");
          }
        }
      }
      isLoading = false;
    };

    return Consumer<UserProvider>(builder: (context, userProvider, child) {
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
                            userProvider.user.photo.toString(),
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
                  Text('Name: ' + userProvider.user.name.toString()),
                  SizedBox(height: 20.0),
                  Text('Email: ' + userProvider.user.email.toString()),
                  SizedBox(height: 20.0),
                  SizedBox(
                    height: 45,
                    width: 200,
                    child: isLoading
                        ? loading
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                doProfile();
                              });
                            },
                            child: Text("Update"),
                          ),
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
          ),
        ),
      );
    });
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
