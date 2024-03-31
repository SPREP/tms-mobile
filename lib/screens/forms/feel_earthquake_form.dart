import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
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

  @override
  Widget build(BuildContext context) {
    return Mag.Magnifier(
      size: Size(250.0, 250.0),
      enabled: visibility ? true : false,
      child: Scaffold(
        body: Padding(padding: EdgeInsets.all(20), child: getForm()),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
          foregroundColor: Colors.white,
          title: Text('Did you feel the earthquake?'),
          centerTitle: false,
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

  Future<http.Response> sendData() async {
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
            "rate_earthquake": _selectedRating!.toLowerCase(),
            "lat": lat,
            "lng": lon
          }
        ]),
      );
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Widget getForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Text(
            'Fill in the following fields to let us know.',
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
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
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Rate the earthquake',
              border: OutlineInputBorder(),
            ),
            hint: const Text('Rate the earthquake'),
            value: _selectedRating,
            items: <String>['Weak', 'Light', 'Moderate', 'Strong', 'Severe']
                .map<DropdownMenuItem<String>>((String value) {
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
                if (val != null || val!.isNotEmpty || val != '')
                  _selectedRating = val.toString();
              });
            },
            validator: (val) {
              if (val == null) {
                String errMsg = "Please rate the earthquake";
                return errMsg;
              }
              return null;
            },
          ),
          const SizedBox(height: 50),
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
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isInProgress = true;
                      });
                      await sendData();
                      showAlertDialog(context);
                      setState(() {
                        _selectedRating = null;
                        _selectedLocation = null;
                        _isInProgress = false;
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
        ],
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
}
