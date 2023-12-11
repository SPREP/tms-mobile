import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/util/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/checkbox_widget.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macres/util/get_image_url.dart';
import 'package:macres/util/upload_file.dart';
import 'dart:convert';
import 'dart:io';
import 'package:macres/widgets/image_input.dart';
import 'package:path/path.dart' as p;

class ImpactReportForm extends StatefulWidget {
  const ImpactReportForm({super.key, required this.eventId});
  final eventId;

  @override
  State<ImpactReportForm> createState() => _ImpactReportFormState();
}

class _ImpactReportFormState extends State<ImpactReportForm> {
  final _formKey = GlobalKey<FormState>();

  List<File> _selectedImages = [];
  var _isInProgress = false;

  Location? _selectedLocation;
  String? _selectedCategory;
  String? gender;
  int? _anyoneMissing;
  int? _anyonePassedAway;
  String? fullName;
  String? phoneNumber;
  String? message;

  bool? waterTank = false;
  bool? boat = false;
  bool? noHouse = false;
  bool? windows = false;
  bool? electricity = false;
  bool? gas = false;
  bool? roofTop = false;
  bool? walls = false;
  bool? toilet = false;
  bool? animals = false;
  bool? telephoneLine = false;
  bool? fuelOil = false;
  bool? machinery = false;
  bool? vehicles = false;
  bool? plane = false;
  bool? waterSupply = false;
  bool? phoneMobile = false;
  bool? internet = false;

  @override
  void initState() {
    super.initState();

    // Set default value to match Location settings.
    _loadSelectedLocation();
  }

  Future<void> _loadSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    var location = prefs.getString('user_location');
    if (location != false) {
      setState(() {
        _selectedLocation = LocationExtension.fromName(location);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<UserModel> getUserData() => UserPreferences().getUser();

    return FutureBuilder<UserModel>(
      future: getUserData(),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Impact Report'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: getForm(snapshot),
              ),
            ),
          );
        }
      },
    );
  }

  Future<http.Response> sendData(imageSourceUrls) async {
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;
    var endpoint = '/impact-report?_format=json';

    final basicAuth =
        "Basic ${base64.encode(utf8.encode('$username:$password'))}";
    dynamic response;

    try {
      response = await http.post(
        Uri.parse('$host$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuth
        },
        body: json.encode([
          {
            "event_id": widget.eventId,
            "nodetype": "impact_report",
            "body": message.toString(),
            "full_name": fullName.toString(),
            "phone": phoneNumber.toString(),
            "location": _selectedLocation!.name,
            "category": _selectedCategory.toString(),
            "images": imageSourceUrls,
            "anyone_missing": _anyoneMissing,
            "anyone_passed_away": _anyonePassedAway,
            "impacted_items": [
              waterTank == true ? 'watertank' : '',
              noHouse == true ? 'waterhouse' : '',
              boat == true ? 'boat' : '',
              windows == true ? 'windows' : '',
              electricity == true ? 'electricity' : '',
              gas == true ? 'gas' : '',
              roofTop == true ? 'rooftop' : '',
              walls == true ? 'rwalls' : '',
              toilet == true ? 'toilet' : '',
              animals == true ? 'animals' : '',
              telephoneLine == true ? 'telephoneline' : '',
              fuelOil == true ? 'fueloil' : '',
              machinery == true ? 'machinery' : '',
              vehicles == true ? 'vehicles' : '',
              plane == true ? 'plane' : '',
              waterSupply == true ? 'watersupply' : '',
              phoneMobile == true ? 'phonemobile' : '',
              internet == true ? 'internet' : '',
            ],
          }
        ]),
      );
    } catch (e) {
      log(e.toString());
    }

    print(response.body);

    return response;
  }

/*
  @override
  void dispose() {
    _formKey.currentState!.dispose();
    super.dispose();
  }
*/
  void clearFields() {
    _formKey.currentState!.reset();
    _selectedImages.clear();
  }

  Widget getForm(snapshot) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fill in the following fields to report the impact.',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              initialValue: snapshot.data.name,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
              onSaved: (newValue) {
                fullName = newValue;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              onSaved: (newValue) {
                phoneNumber = newValue;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Choose your location'),
              value: _selectedLocation,
              items: Location.values.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(locationLabel[value].toString()),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedLocation = val!;
                });
              },
              validator: (val) {
                if (val == null) {
                  String errMsg = "Please choose your location.";
                  return errMsg;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Impact Category',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Impact Category'),
              value: _selectedCategory,
              items: <String>[
                'Home',
                'School',
                'Airport',
                'Hospital',
                'Wharf',
                'Church',
                'Business',
                'Village',
                'Harbour',
                'Beach',
                'Road',
                'Island',
                'Plantation'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategory = val.toString();
                });
              },
              validator: (val) {
                if (val == null) {
                  String errMsg = "Please select a category";
                  return errMsg;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select the impacted items from the list below.',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomCheckBox(
                  label: 'Water tank',
                  value: waterTank,
                  onChanged: (value) {
                    setState(() => waterTank = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'No House',
                  value: noHouse,
                  onChanged: (value) {
                    setState(() => noHouse = value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                CustomCheckBox(
                  label: 'Boat',
                  value: boat,
                  onChanged: (value) {
                    setState(() => boat = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'Windows',
                  value: windows,
                  onChanged: (value) {
                    setState(() => windows = value!);
                  },
                ),
              ],
            ),
            Row(children: [
              CustomCheckBox(
                label: 'Electiricity',
                value: electricity,
                onChanged: (value) {
                  setState(() => electricity = value!);
                },
              ),
              CustomCheckBox(
                label: 'Gas',
                value: gas,
                onChanged: (value) {
                  setState(() => gas = value!);
                },
              ),
            ]),
            Row(children: [
              CustomCheckBox(
                label: 'Roof top',
                value: roofTop,
                onChanged: (value) {
                  setState(() => roofTop = value!);
                },
              ),
              CustomCheckBox(
                label: 'Walls',
                value: walls,
                onChanged: (value) {
                  setState(() => walls = value!);
                },
              ),
            ]),
            Row(
              children: [
                CustomCheckBox(
                  label: 'Toilet',
                  value: toilet,
                  onChanged: (value) {
                    setState(() => toilet = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'Animals',
                  value: animals,
                  onChanged: (value) {
                    setState(() => animals = value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                CustomCheckBox(
                  label: 'Telephone line',
                  value: telephoneLine,
                  onChanged: (value) {
                    setState(() => telephoneLine = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'Fuel/Oil',
                  value: fuelOil,
                  onChanged: (value) {
                    setState(() => fuelOil = value!);
                  },
                ),
              ],
            ),
            Row(children: [
              CustomCheckBox(
                label: 'Machinery',
                value: machinery,
                onChanged: (value) {
                  setState(() => machinery = value!);
                },
              ),
              CustomCheckBox(
                label: 'Vehicles',
                value: vehicles,
                onChanged: (value) {
                  setState(() => vehicles = value!);
                },
              ),
            ]),
            Row(children: [
              CustomCheckBox(
                label: 'Plane',
                value: plane,
                onChanged: (value) {
                  setState(() => plane = value!);
                },
              ),
              CustomCheckBox(
                label: 'Water supply',
                value: waterSupply,
                onChanged: (value) {
                  setState(() => waterSupply = value!);
                },
              ),
            ]),
            Row(
              children: [
                CustomCheckBox(
                  label: 'Phone mobile',
                  value: phoneMobile,
                  onChanged: (value) {
                    setState(() => phoneMobile = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'Internet',
                  value: internet,
                  onChanged: (value) {
                    setState(() => internet = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Is anyone missing?'),
            ),
            Row(
              children: [
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 100,
                    width: 90,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('Yes'),
                      leading: Radio(
                        value: 1,
                        groupValue: _anyoneMissing,
                        onChanged: (value) {
                          setState(() {
                            _anyoneMissing = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 100,
                    width: 90,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('No'),
                      leading: Radio(
                        value: 0,
                        groupValue: _anyoneMissing,
                        onChanged: (value) {
                          setState(() {
                            _anyoneMissing = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Has anyone passed away?'),
            ),
            Row(
              children: [
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 100,
                    width: 85,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('Yes'),
                      leading: Radio(
                        value: 1,
                        groupValue: _anyonePassedAway,
                        onChanged: (value) {
                          setState(() {
                            _anyonePassedAway = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 100,
                    width: 85,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('No'),
                      leading: Radio(
                        value: 0,
                        groupValue: _anyonePassedAway,
                        onChanged: (value) {
                          setState(() {
                            _anyonePassedAway = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter Message',
                  border: OutlineInputBorder(),
                ),
                onSaved: (newValue) {
                  message = newValue;
                },
                keyboardType: TextInputType.multiline,
                maxLines: 5),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ImageInput(
              onPickImage: (selectedImages) {
                _selectedImages = selectedImages;
              },
            ),
            const SizedBox(height: 5),
            ListTileTheme(
              contentPadding: const EdgeInsets.only(left: 0),
              child: CheckboxListTile(
                value: true,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    //key = value;
                  });
                },
                title: const Text(
                    'I declare that all information given above is true and complete.'),
              ),
            ),
            const SizedBox(height: 30),
            if (_isInProgress) const CircularProgressIndicator(),
            if (!_isInProgress)
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
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
                      clearFields();
                      setState(() {
                        _isInProgress = false;
                      });
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
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
      title: const Text("Impact Report Status"),
      content: const Text("Your impact report has been received.  Thank you."),
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
}
