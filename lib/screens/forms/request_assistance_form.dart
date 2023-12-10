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
import 'package:geolocator/geolocator.dart';

class RequestAssistanceForm extends StatefulWidget {
  const RequestAssistanceForm({super.key, required this.eventId});
  final eventId;

  @override
  State<RequestAssistanceForm> createState() => _RequestAssistanceForm();
}

class _RequestAssistanceForm extends State<RequestAssistanceForm> {
  final _formKey = GlobalKey<FormState>();

  List<File> _selectedImages = [];
  var _isInProgress = false;

  Location? _selectedLocation;
  String? _selectedCategory;
  String? gender;
  int? _haveWater;
  int? _haveFood;
  int? _haveHouse;
  String? fullName;
  String? phoneNumber;
  String? message;

  bool? needWater = false;
  bool? needHouse = false;
  bool? needFood = false;
  bool? needDoctor = false;
  bool? needClothes = false;
  bool? needBlankets = false;
  bool? needHelp = false;
  bool? needOther = false;

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
  bool? road = false;
  bool? plantation = false;

  late Position userPosition;

  void initState() {
    // var response = _getCurrentUserLocation();
    // if (!response.isNull) {
    //   userPosition = response;
    // }
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

  _getCurrentUserLocation() async {
    // Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log(position.toString());
    print(position.toString());

    return position;
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
              title: const Text('Request Assistance'),
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
    var endpoint = '/request-assistance?_format=json';

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
            "event_id": widget.eventId,
            "nodetype": "request_assistance",
            "body": message.toString(),
            "full_name": fullName.toString(),
            "phone": phoneNumber.toString(),
            "location": _selectedLocation!.name,
            "images": imageSourceUrls,
            "have_water": _haveWater,
            "have_food": _haveFood,
            "have_house": _haveHouse,
            "needed_now": [
              needWater == true ? 'water' : '',
              needFood == true ? 'food' : '',
              needHouse == true ? 'house' : '',
              needDoctor == true ? 'doctor' : '',
              needClothes == true ? 'clothes' : '',
              needBlankets == true ? 'blankets' : '',
              needHelp == true ? 'help' : '',
              needOther == true ? 'other' : '',
            ],
            "assistance_with": [
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
              road == true ? 'road' : '',
              plantation == true ? 'plantation' : ''
            ],
          }
        ]),
      );
    } catch (e) {
      log(e.toString());
    }

    return res;
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
            const Text(
              'Fill in the following fields to request assistance.',
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
            const SizedBox(height: 40),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Do you have water?')),
            Row(
              children: [
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 70,
                    width: 90,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('Yes'),
                      leading: Radio(
                        value: 1,
                        groupValue: _haveWater,
                        onChanged: (value) {
                          setState(() {
                            _haveWater = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 70,
                    width: 90,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('No'),
                      leading: Radio(
                        value: 0,
                        groupValue: _haveWater,
                        onChanged: (value) {
                          setState(() {
                            _haveWater = value;
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
                child: Text('Do you have food?')),
            Row(
              children: [
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 70,
                    width: 85,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('Yes'),
                      leading: Radio(
                        value: 1,
                        groupValue: _haveFood,
                        onChanged: (value) {
                          setState(() {
                            _haveFood = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 70,
                    width: 85,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('No'),
                      leading: Radio(
                        value: 0,
                        groupValue: _haveFood,
                        onChanged: (value) {
                          setState(() {
                            _haveFood = value;
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
              child: Text('Do you have house/shelter?'),
            ),
            Row(
              children: [
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 70,
                    width: 85,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('Yes'),
                      leading: Radio(
                        value: 1,
                        groupValue: _haveHouse,
                        onChanged: (value) {
                          setState(() {
                            _haveHouse = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: SizedBox(
                    height: 70,
                    width: 85,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('No'),
                      leading: Radio(
                        value: 0,
                        groupValue: _haveHouse,
                        onChanged: (value) {
                          setState(() {
                            _haveHouse = value;
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
              child: Text(
                'Select what you really needed now.',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CustomCheckBox(
                  label: 'Water',
                  value: needWater,
                  onChanged: (value) {
                    setState(() => needWater = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'Food',
                  value: needFood,
                  onChanged: (value) {
                    setState(() => needFood = value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                CustomCheckBox(
                  label: 'House / Shelter',
                  value: needHouse,
                  onChanged: (value) {
                    setState(() => needHouse = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'See Doctor',
                  value: needDoctor,
                  onChanged: (value) {
                    setState(() => needDoctor = value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                CustomCheckBox(
                  label: 'Warm Clothes',
                  value: needClothes,
                  onChanged: (value) {
                    setState(() => needClothes = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'Blankets',
                  value: needBlankets,
                  onChanged: (value) {
                    setState(() => needBlankets = value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                CustomCheckBox(
                  label: 'Help',
                  value: needHelp,
                  onChanged: (value) {
                    setState(() => needHelp = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'Other',
                  value: needOther,
                  onChanged: (value) {
                    setState(() => needOther = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select what you need an assistance with from the list below.',
              ),
            ),
            const SizedBox(height: 20),
            Row(
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
            Row(
              children: [
                CustomCheckBox(
                  label: 'Plantation',
                  value: plantation,
                  onChanged: (value) {
                    setState(() => plantation = value!);
                  },
                ),
                CustomCheckBox(
                  label: 'Road',
                  value: road,
                  onChanged: (value) {
                    setState(() => road = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 50),
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
