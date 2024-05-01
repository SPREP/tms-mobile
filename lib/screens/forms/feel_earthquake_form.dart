import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/earthquake_rate_model.dart';
import 'package:macres/models/settings_model.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macres/util/user_location.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:macres/util/magnifier.dart' as Mag;

class FeelEarthquakeForm extends StatefulWidget {
  FeelEarthquakeForm({super.key, required this.eventId});
  final eventId;
  final userLocation = new UserLocation();

  @override
  State<FeelEarthquakeForm> createState() => _FeelEarthquakeFormState();
}

class _FeelEarthquakeFormState extends State<FeelEarthquakeForm> {
  final _formKey = GlobalKey<FormState>();
  Location? _selectedLocation;
  String? _selectedRating;
  bool _isInProgress = false;
  bool visibility = false;
  num _rate_field_value = 1;
  bool _inWaitingPeriod = false;

  @override
  Widget build(BuildContext context) {
    return Mag.Magnifier(
      size: Size(250.0, 250.0),
      enabled: visibility ? true : false,
      child: Scaffold(
        body: Padding(padding: EdgeInsets.all(20), child: getForm(context)),
        appBar: AppBar(
          title: Text('Feel the earthquake?'),
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
      ),
    );
  }

  @override
  void initState() {
    // Set default value to match Location settings.
    _loadSelectedLocation();
    widget.userLocation.getCurrentPosition();
    //prevent multiple submission
    //_getWaitingPeriod();
    super.initState();
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

  Future<Map<String, dynamic>> sendData() async {
    String username = AppConfig.userName;
    String password = AppConfig.password;
    String host = AppConfig.baseUrl;
    String endpoint = '/feel-earthquake?_format=json';
    double lat = 0;
    double lon = 0;

    if (widget.userLocation.currentPosition != null) {
      lat = widget.userLocation.currentPosition!.latitude;
      lon = widget.userLocation.currentPosition!.longitude;
    }

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
            "location": _selectedLocation!.name,
            "rate_earthquake": _rate_field_value,
            "lat": lat,
            "lng": lon
          }
        ]),
      );
    } catch (e) {
      log(e.toString());
    }

    if (res.statusCode == 201) {
      return {'status_code': 201};
    } else {
      return {'status_code': res.statusCode};
    }
  }

  Widget _getRateDropdown() {
    List<EarthquakeRateModel> rates = [];

    rates.add(
      EarthquakeRateModel(
        name: 'Weak',
        desc: "Feel the Virations",
        id: 1,
        image: 'assets/images/earthquake/2.jpg',
      ),
    );

    rates.add(
      EarthquakeRateModel(
        name: 'Light',
        desc: "Light swing",
        id: 2,
        image: 'assets/images/earthquake/3.jpg',
      ),
    );

    rates.add(
      EarthquakeRateModel(
        name: 'Moderate',
        desc: "Windows rattle or break, light damage",
        id: 3,
        image: 'assets/images/earthquake/4.jpg',
      ),
    );

    rates.add(
      EarthquakeRateModel(
        name: 'Strong',
        desc: "Crack in buildings, falling branches",
        id: 4,
        image: 'assets/images/earthquake/5.jpg',
      ),
    );

    rates.add(
      EarthquakeRateModel(
        name: 'Major',
        desc: "Building collapse, landslides",
        id: 5,
        image: 'assets/images/earthquake/6.jpg',
      ),
    );

    rates.add(
      EarthquakeRateModel(
        name: 'Severe',
        desc: "Devastation, many deaths",
        id: 6,
        image: 'assets/images/earthquake/7.jpg',
      ),
    );

    return DropdownButtonFormField(
      alignment: Alignment.centerLeft,
      isDense: false,
      isExpanded: true,
      validator: (value) {
        if (value == 0) {
          return 'Please rate the earthquake';
        }
        return null;
      },
      hint: Text('Rate the earthquake'),
      style: TextStyle(color: Theme.of(context).hintColor),
      decoration: const InputDecoration(
        labelText: 'Rate the earthquake',
        border: OutlineInputBorder(),
      ),
      value: _rate_field_value,
      items: rates.map<DropdownMenuItem<int>>((map) {
        return DropdownMenuItem<int>(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 180, 179, 179),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 140,
                  height: 150,
                  child: Image.asset(
                    map.image.toString(),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        map.name.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        map.desc.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 12.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          value: map.id,
        );
      }).toList(),
      onChanged: (v) {
        this._rate_field_value = v!;
      },
    );
  }

  Widget getForm(context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Text(
            'Fill in the following fields to let us know.',
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
            style: TextStyle(color: Theme.of(context).hintColor),
            decoration: const InputDecoration(
              labelText: 'Choose your location',
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
          const SizedBox(height: 20),
          _getRateDropdown(),
          const SizedBox(height: 50),
          if (_isInProgress) const CircularProgressIndicator(),
          if (!_isInProgress && !_inWaitingPeriod)
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
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isInProgress = true;
                      });

                      final Map<String, dynamic> response = await sendData();

                      if (response['status_code'] == 201) {
                        setState(() {
                          _selectedRating = null;
                          _selectedLocation = null;
                          _isInProgress = false;
                        });

                        //now hide the submit button for 1 hour
                        _startWaitingPeriod();

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
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          if (_inWaitingPeriod)
            Text(
                'Please wait for 15 minutes before you allow to submit again.'),
        ],
      ),
    );
  }

  showAlertDialog(context) {
    //Button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Status"),
      content: const Text("Your message has been received.  Thank you."),
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

  void _startWaitingPeriod() async {
    _inWaitingPeriod = true;
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString(
        'feel_earthquake_waiting_timestamp', now.toIso8601String());
  }

  Future _getWaitingPeriod() async {
    final prefs = await SharedPreferences.getInstance();
    final waitingTimestamp =
        prefs.getString('feel_earthquake_waiting_timestamp');

    if (waitingTimestamp != null) {
      final timestamp = DateTime.parse(waitingTimestamp);
      final currentTime = DateTime.now();
      final waitingDuration = currentTime.difference(timestamp);

      const Duration waitingExpirationDuration = Duration(minutes: 15);

      if (waitingDuration <= waitingExpirationDuration) {
        _inWaitingPeriod = true;
      } else {
        _inWaitingPeriod = false;
      }
    }
  }
}
