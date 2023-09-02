import 'package:flutter/material.dart';
import 'package:macres/models/settings_model.dart';

class FeelEarthquakeForm extends StatefulWidget {
  const FeelEarthquakeForm({super.key});

  @override
  State<FeelEarthquakeForm> createState() => _FeelEarthquakeFormState();
}

class _FeelEarthquakeFormState extends State<FeelEarthquakeForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(20), child: getForm()),
      appBar: AppBar(
        title: Text('Did you feel the earthquake?'),
      ),
    );
  }

  void _submitData() {
    //get the user GEO location to send together with form data
  }

  Widget getForm() {
    Location? _selectedLocation;
    String? _selectedRating;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Text(
            'Fill in the following fields to let us know.',
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
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
            hint: const Text('Rate the earthquake'),
            value: _selectedLocation,
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
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data ...')),
                    );
                    //Navigator.pop(context);
                    _submitData();
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
}
