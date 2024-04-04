import 'package:another_flushbar/flushbar.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/tk_model.dart';
import 'package:macres/util/get_image_url.dart';
import 'package:macres/util/upload_file.dart';
import 'package:macres/util/user_location.dart';
import 'dart:convert';
import 'dart:io';
import 'package:macres/widgets/image_input.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path/path.dart' as p;

class TkIndicatorForm extends StatefulWidget {
  const TkIndicatorForm({super.key});

  @override
  State<TkIndicatorForm> createState() => _TkIndicatorFormState();
}

class _TkIndicatorFormState extends State<TkIndicatorForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  var _selectedPhoto;
  final _formKey = GlobalKey<FormState>();
  final AsyncMemoizer<List<TkIndicatorModel>> _memoizer =
      AsyncMemoizer<List<TkIndicatorModel>>();

  bool _isInProgress = false;
  int _indicators_field_value = 1;
  double _photo_lat = 0;
  double _photo_lng = 0;
  DateTime _photo_date = new DateTime.now();
  late UserLocation _ul;
  bool _mapOn = false;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  initState() {
    requestLocation();
    super.initState();
  }

  requestLocation() async {
    UserLocation ul = await new UserLocation();
    this._ul = ul;
  }

  Future<Map<dynamic, dynamic>> sendData(imageSourceUrl) async {
    final title = titleController.text;
    final body = bodyController.text;
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;
    var endpoint = '/tk?_format=json';
    final basicAuth =
        "Basic ${base64.encode(utf8.encode('$username:$password'))}";
    dynamic res;
    var result = {};

    try {
      http.Response res = await http.post(
        Uri.parse('$host$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuth
        },
        body: json.encode([
          {
            "nodetype": "met_tk",
            "label": title,
            "description": body,
            "image": imageSourceUrl,
            "indicator": _indicators_field_value,
            "lat": this._photo_lat,
            "lng": this._photo_lng,
            "date": this._photo_date.toString()
          }
        ]),
      );

      result = {
        'status_code': res.statusCode,
      };
    } catch (e, backtrace) {
      print(e);
      print(backtrace);
    }

    return result;
  }

  void clearFields() {
    titleController.text = '';
    bodyController.text = '';
    _selectedPhoto = File('');
  }

  Future<List<TkIndicatorModel>> getTkIndicators() async {
    return this._memoizer.runOnce(() async {
      var username = AppConfig.userName;
      var password = AppConfig.password;
      var host = AppConfig.baseUrl;
      String endpoint = '/tk/ind?_format=json';
      List<TkIndicatorModel> data = [];

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
          return loaded_data
              .map((json) => TkIndicatorModel.fromJson(json))
              .toList();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        const snackBar = SnackBar(
          content: Text(
              'Error: Unable to load traditional knowledge indicator data.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print(e);
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Indicator'),
        backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
        foregroundColor: Colors.white,
      ),
      body: builder(context),
    );
  }

  Widget getDropDownMenu() {
    return FutureBuilder(
        future: getTkIndicators(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the task is happening, show a loading spinner
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return DropdownButtonFormField(
              alignment: Alignment.centerLeft,
              isDense: false,
              isExpanded: true,
              focusColor: Colors.red,
              validator: (value) {
                if (value == 0) {
                  return 'Please choose an indicator from the list';
                }
                return null;
              },
              hint: Text('Select which indicator you reporting'),
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              value: _indicators_field_value,
              items: snapshot.data.map<DropdownMenuItem<int>>((map) {
                return DropdownMenuItem<int>(
                  child: Container(
                    child: ListTile(
                      leading: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: new Container(
                          decoration: new BoxDecoration(
                              image: new DecorationImage(
                            fit: BoxFit.fitWidth,
                            alignment: FractionalOffset.centerLeft,
                            image: new NetworkImage(map.photo),
                          )),
                        ),
                      ),
                      shape: Border(
                          bottom: BorderSide(
                              color: const Color.fromARGB(255, 154, 153, 153))),
                      tileColor: Color.fromARGB(255, 225, 225, 225),
                      title: Text(
                        map.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        map.desc,
                      ),
                    ),
                  ),
                  value: map.id,
                );
              }).toList(),
              onChanged: (v) {
                this._indicators_field_value = v!;
              },
            );
          }
        });
  }

  Widget builder(index) {
    return SingleChildScrollView(
      child: Form(
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
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Select an indicator from the list below',
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 10.0,
              ),
              getDropDownMenu(),
              const SizedBox(height: 20),
              ImageInput(
                onTakePhoto: (selectedPhoto) async {
                  _selectedPhoto = selectedPhoto;

                  //retrieve the meta tag from the photo
                  final exif = await Exif.fromPath(selectedPhoto.path);
                  final latLong = await exif.getLatLong();
                  final imageDate = await exif.getOriginalDate();
                  await exif.close();
                  if (latLong != null) {
                    this._photo_lat = latLong.latitude;
                    this._photo_lng = latLong.longitude;
                  } else {
                    //try to get the location from geolocator
                    if (this._ul.currentPosition != null) {
                      this._photo_lat = this._ul.currentPosition!.latitude;
                      this._photo_lng = this._ul.currentPosition!.longitude;
                    } else {
                      setState(() {
                        _mapOn = true;
                      });
                    }
                  }
                  if (imageDate != null) {
                    _photo_date = imageDate;
                  }
                },
                onChooseImage: (selectedPhoto) async {
                  _selectedPhoto = selectedPhoto;

                  //retrieve the meta tag from the photo
                  final exif = await Exif.fromPath(selectedPhoto.path);
                  final latLong = await exif.getLatLong();
                  final imageDate = await exif.getOriginalDate();

                  await exif.close();
                  if (latLong != null) {
                    this._photo_lat = latLong.latitude;
                    this._photo_lng = latLong.longitude;
                  } else {
                    setState(() {
                      _mapOn = true;
                    });
                  }

                  if (imageDate != null) {
                    _photo_date = imageDate;
                  }
                },
              ),
              const SizedBox(height: 5),
              if (this._mapOn)
                Column(children: [
                  Text('On the map, point to where you took this photo.'),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 400,
                    child: FlutterLocationPicker(
                      initZoom: 11,
                      minZoomLevel: 5,
                      maxZoomLevel: 16,
                      trackMyPosition: true,
                      initPosition: LatLong(-21.178986, -175.198242),
                      showLocationController:
                          _ul.currentPosition != null ? true : false,
                      onChanged: (pickedData) {
                        _photo_lat = pickedData.latLong.latitude;
                        _photo_lng = pickedData.latLong.longitude;
                      },
                      onPicked: (pickedData) {},
                      showSelectLocationButton: false,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ]),
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
                  _isInProgress
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          child: const Text('Submit'),
                          onPressed: () async {
                            setState(() {
                              _isInProgress = true;
                            });

                            final isValid = _formKey.currentState!.validate();

                            if (_selectedPhoto == null) {
                              Flushbar(
                                title: "Error",
                                message: 'Please add the indicator photo',
                                duration: Duration(seconds: 3),
                              ).show(context);

                              return;
                            }

                            if (!isValid) {
                              return;
                            }
                            _formKey.currentState!.save();

                            GetImageUrl imageUrl = GetImageUrl();
                            if (_selectedPhoto != null) {
                              String fileExtension =
                                  p.extension(_selectedPhoto.path);
                              await imageUrl.call(fileExtension);

                              if (imageUrl.success) {
                                await uploadFile(context, imageUrl.uploadUrl,
                                    File(_selectedPhoto.path));
                              }
                            }

                            Future<Map<dynamic, dynamic>> res =
                                sendData(imageUrl.downloadUrl);

                            res.then((response) {
                              if (response['status_code'] == 201) {
                                setState(() {
                                  clearFields();
                                  _isInProgress = false;
                                });

                                Flushbar(
                                  title: "Success",
                                  message:
                                      'Your indicator report has been received. Thank you!',
                                  duration: Duration(seconds: 3),
                                ).show(context).then(
                                      (value) => Navigator.pop(context),
                                    );
                              } else {
                                Flushbar(
                                  title: "Error",
                                  message: 'Please try again later.',
                                  duration: Duration(seconds: 3),
                                );
                              }
                            });
                          }),
                ],
              ),
            ],
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
}
