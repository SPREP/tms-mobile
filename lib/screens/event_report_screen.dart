import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/util/get_image_url.dart';
import 'package:macres/util/upload_file.dart';
import 'package:macres/util/user_location.dart';
import 'dart:convert';
import 'dart:io';
import 'package:macres/widgets/image_input.dart';
import 'package:path/path.dart' as p;
import 'package:macres/util/magnifier.dart' as Mag;

class EventReportScreen extends StatefulWidget {
  EventReportScreen({super.key});

  final userLocation = new UserLocation();

  @override
  State<EventReportScreen> createState() => _EventReportScreenState();
}

class _EventReportScreenState extends State<EventReportScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  List<File> _selectedImages = [];
  final _formKey = GlobalKey<FormState>();
  bool visibility = false;
  var _isInProgress = false;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.userLocation.getCurrentPosition();
  }

  Future<http.Response> sendData(imageSourceUrls) async {
    final title = titleController.text;
    final body = bodyController.text;
    String username = AppConfig.userName;
    String password = AppConfig.password;
    String host = AppConfig.baseUrl;
    String endpoint = '/event-report?_format=json';
    final basicAuth =
        "Basic ${base64.encode(utf8.encode('$username:$password'))}";
    dynamic res;

    double lat = 0;
    double lng = 0;

    if (widget.userLocation.currentPosition != null) {
      lat = widget.userLocation.currentPosition!.latitude;
      lng = widget.userLocation.currentPosition!.longitude;
    }

    try {
      res = await http.post(
        Uri.parse('$host$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuth
        },
        body: json.encode([
          {
            "nodetype": "event_report",
            "title": title,
            "body": body,
            "images": imageSourceUrls,
            "lat": lat,
            "lng": lng
          }
        ]),
      );
    } catch (e) {
      log(e.toString());
    }

    return res;
  }

  void clearFields() {
    titleController.text = '';
    bodyController.text = '';
    _selectedImages.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Mag.Magnifier(
      size: Size(250.0, 250.0),
      enabled: visibility ? true : false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Event Report'),
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    visibility = !visibility;
                  });
                },
                child: Icon(
                  visibility ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 10, right: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Fill in the following fields, to report an event from your location. For exmaple:  If you see a fire, you can report it here.  If you see a smoke coming out from a Volcano.",
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: titleController,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text('Title'),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Enter the event title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: bodyController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          label: Text('Enter the event details here'),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Enter the event details";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ImageInput(
                        onPickImage: (selectedImages) {
                          _selectedImages = selectedImages;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Spacer(),
                          const SizedBox(width: 16),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  clearFields();
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')),
                          const SizedBox(width: 20),
                          if (_isInProgress) const CircularProgressIndicator(),
                          if (!_isInProgress)
                            ElevatedButton(
                              onPressed: () async {
                                final isValid =
                                    _formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                                _formKey.currentState!.save();

                                setState(() {
                                  _isInProgress = true;
                                });

                                GetImageUrl imageUrl = GetImageUrl();
                                List<String> imageSourceUrls = [];

                                if (_selectedImages.isNotEmpty) {
                                  for (var n = 0;
                                      n < _selectedImages.length;
                                      n++) {
                                    String fileExtension =
                                        p.extension(_selectedImages[n].path);
                                    await imageUrl.call(fileExtension);

                                    if (imageUrl.success) {
                                      await uploadFile(
                                          context,
                                          imageUrl.uploadUrl,
                                          File(_selectedImages[n].path));
                                    }

                                    imageSourceUrls.add(imageUrl.downloadUrl);
                                  }
                                }

                                await sendData(imageSourceUrls);

                                setState(() {
                                  clearFields();
                                  _isInProgress = false;
                                });
                                showAlertDialog(context);
                              },
                              child: const Text('Submit'),
                            ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> uploadFile(context, String url, File image) async {
    try {
      UploadFile uploadFile = UploadFile();
      await uploadFile.call(url, image);

      if (uploadFile.isUploaded != false && uploadFile.isUploaded) {
        return true;
      } else {
        throw uploadFile.message;
      }
    } catch (e) {
      throw ("Error ${e.toString()}");
    }
  }

  showAlertDialog(BuildContext context) {
    //Button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Event Report Status"),
      content: const Text("Your event report has been received.  Thank you."),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
