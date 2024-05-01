import 'package:another_flushbar/flushbar.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/models/village_model.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:macres/util/user_location.dart';
import 'package:macres/util/user_preferences.dart';
import 'package:provider/provider.dart';
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
import 'package:macres/util/magnifier.dart' as Mag;

class RequestAssistanceForm extends StatefulWidget {
  const RequestAssistanceForm({super.key, required this.eventId});
  final eventId;

  @override
  State<RequestAssistanceForm> createState() => _RequestAssistanceForm();
}

class _RequestAssistanceForm extends State<RequestAssistanceForm> {
  Future<UserModel> getUserData() => UserPreferences().getUser();
  final _formKey = GlobalKey<FormState>();
  bool visibility = false;
  final userLocation = new UserLocation();
  List<File> _selectedImages = [];
  var _isInProgress = false;
  List<VillageModel> _villageData = [];

  Location? _selectedLocation;
  int? _villageId;
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

  bool _declare = true;

  late Position userPosition;
  dynamic _user;
  AuthProvider authprovider = new AuthProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authprovider = Provider.of<AuthProvider>(context);
  }

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
      _selectedLocation = LocationExtension.fromName(location);
      _villageData = await getVillages();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Mag.Magnifier(
      size: Size(250.0, 250.0),
      enabled: visibility ? true : false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Request Assistance'),
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
            padding: const EdgeInsets.all(20),
            child: getForm(),
          ),
        ),
      ),
    );
  }

  Future<http.Response> sendData(imageSourceUrls) async {
    var host = AppConfig.baseUrl;
    var endpoint = '/request-assistance?_format=json';

    dynamic res;

    //get user GPS location
    double lat = 0.0;
    double lon = 0.0;

    if (userLocation.currentPosition != null) {
      lat = userLocation.currentPosition!.latitude;
      lon = userLocation.currentPosition!.longitude;
    }

    //load user model
    _user = await getUserData();

    //get csrfToken
    var csrfToken = await authprovider.getCsrfToken();

    try {
      res = await http.post(
        Uri.parse('$host$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': _user.token.toString(),
          'X-CSRF-Token': csrfToken
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
            "lat": lat,
            "lon": lon,
            "village": _villageId,
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
              noHouse == true ? 'nohouse' : '',
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

  Widget getForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Text(
            'Fill in the following fields to request assistance.',
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Theme.of(context).hintColor),
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),

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
            style: TextStyle(color: Theme.of(context).hintColor),
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
            style: TextStyle(color: Theme.of(context).hintColor),
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
            onChanged: (val) async {
              _selectedLocation = val!;
              _villageId = null;
              _villageData = await getVillages();
              setState(() {});
            },
            validator: (val) {
              if (val == null) {
                String errMsg = "Please choose your location.";
                return errMsg;
              }
              return null;
            },
          ),
          if (_selectedLocation != null)
            Column(children: [
              SizedBox(
                height: 20.0,
              ),
              DropdownButtonFormField(
                style: TextStyle(color: Theme.of(context).hintColor),
                decoration: const InputDecoration(
                  labelText: 'Village',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Choose your village'),
                value: _villageId,
                items: _villageData.map<DropdownMenuItem<int>>((value) {
                  return DropdownMenuItem<int>(
                    value: value.id,
                    child: Text(value.name!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _villageId = val!;
                  });
                },
                validator: (val) {
                  if (val == null) {
                    String errMsg = "Please select your village.";
                    return errMsg;
                  }
                  return null;
                },
              )
            ]),
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
              'Select your immediate needs from the list.',
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
              'Select what you need assistance with.',
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
          ImageInput(
            onPickImage: (selectedImages) {
              _selectedImages = selectedImages;
            },
          ),
          const SizedBox(height: 5),
          ListTileTheme(
            contentPadding: const EdgeInsets.only(left: 0),
            child: CheckboxListTile(
              value: _declare,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  _declare = value!;
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

                    var result = await sendData(imageSourceUrls);

                    clearFields();
                    setState(() {
                      _isInProgress = false;
                    });

                    if (result.statusCode == 201) {
                      showAlertDialog(context);
                    } else {
                      Flushbar(
                        title: "Error",
                        message: "There's an error, please try again later",
                        duration: Duration(seconds: 3),
                      ).show(context).then(
                            (value) => Navigator.pop(context),
                          );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Future<List<VillageModel>> getVillages() async {
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;

    var rid = locationIds[_selectedLocation];

    String endpoint = '/village/$rid?_format=json';
    List<VillageModel> data = [];

    final basicAuth =
        "Basic ${base64.encode(utf8.encode('$username:$password'))}";
    dynamic response;
    try {
      response = await http.get(
        Uri.parse('$host$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuth
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body).isEmpty) {
          return [];
        }

        final loaded_data = json.decode(response.body) as List<dynamic>;
        return loaded_data.map((json) => VillageModel.fromJson(json)).toList();
      }
    } catch (e) {
      /*
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text('Error: Unable to load village data.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      */
      print(e);
    }
    return data;
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
      title: const Text("Assistance Request Status"),
      content:
          const Text("Your assistance request has been received.  Thank you."),
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
