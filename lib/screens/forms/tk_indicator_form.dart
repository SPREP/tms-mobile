import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/util/get_image_url.dart';
import 'package:macres/util/upload_file.dart';
import 'dart:convert';
import 'dart:io';
import 'package:macres/widgets/image_input.dart';
import 'package:path/path.dart' as p;

class TkIndicatorForm extends StatefulWidget {
  const TkIndicatorForm({super.key});

  @override
  State<TkIndicatorForm> createState() => _TkIndicatorFormState();
}

class _TkIndicatorFormState extends State<TkIndicatorForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  List<File> _selectedImages = [];
  final _formKey = GlobalKey<FormState>();

  var _isInProgress = false;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<http.Response> sendData(imageSourceUrls) async {
    final title = titleController.text;
    final body = bodyController.text;
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;
    var endpoint = '/event-report?_format=json';
    final basicAuth =
        "Basic ${base64.encode(utf8.encode('$username:$password'))}";
    dynamic res;

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
            "images": imageSourceUrls
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Indicator'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Fill in the following fields, to report an indicator from your location.",
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
                      return 'Enter the indicator title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: bodyController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    label: Text('Enter the indicator details here'),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Enter the indicator details";
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
                const SizedBox(height: 5),
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
                          final isValid = _formKey.currentState!.validate();
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
                            for (var n = 0; n < _selectedImages.length; n++) {
                              String fileExtension =
                                  p.extension(_selectedImages[n].path);
                              await imageUrl.call(fileExtension);

                              if (imageUrl.success) {
                                await uploadFile(context, imageUrl.uploadUrl,
                                    File(_selectedImages[n].path));
                              }

                              imageSourceUrls.add(imageUrl.downloadUrl);
                            }
                          }

                          await sendData(imageSourceUrls);
                          showAlertDialog(context);
                          setState(() {
                            clearFields();
                            _isInProgress = false;
                          });
                        },
                        child: const Text('Submit'),
                      ),
                  ],
                ),
              ],
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
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Indicator Report Status"),
      content:
          const Text("Your indicator report has been received.  Thank you."),
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
