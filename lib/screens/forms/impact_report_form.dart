import 'package:flutter/material.dart';
import 'package:macres/models/settings_model.dart';

enum YesNo { yes, no }

class ImpactReportForm extends StatefulWidget {
  const ImpactReportForm({super.key});

  @override
  State<ImpactReportForm> createState() => _ImpactReportFormState();
}

class _ImpactReportFormState extends State<ImpactReportForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impact Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: getForm(),
        ),
      ),
    );
  }

  void _submitData() {}

  Widget getForm() {
    Location? _selectedLocation;
    String? _selectedCategory;
    String? gender;
    YesNo? _anyoneMissing;

    bool waterTank = false;
    bool boat = false;
    bool noHouse = false;
    bool windows = false;
    bool electricity = false;
    bool gas = false;
    bool roofTop = false;
    bool walls = false;
    bool toilet = false;
    bool animals = false;
    bool telephoneLine = false;
    bool fuelOil = false;
    bool machinery = false;
    bool vehicles = false;
    bool plane = false;
    bool waterSupply = false;
    bool phoneMobile = false;
    bool internet = false;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Text(
            'Fill in the following fields to report the impact.',
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
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
                String errMsg = "Please rate the earthquake";
                return errMsg;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Select the impacted items from the list below.',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              getCheckbox(waterTank, 'Water tank', waterTank),
              getCheckbox(noHouse, 'No House', noHouse),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              getCheckbox(boat, 'Boat', boat),
              getCheckbox(windows, 'Windows', windows),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [
            getCheckbox(electricity, 'Electiricity', electricity),
            getCheckbox(gas, 'Gas', gas),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            getCheckbox(roofTop, 'Roof top', roofTop),
            getCheckbox(walls, 'Walls', walls),
          ]),
          const SizedBox(height: 20),
          Row(
            children: [
              getCheckbox(toilet, 'Toilet', toilet),
              getCheckbox(animals, 'Animals', animals),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              getCheckbox(telephoneLine, 'Telephone line', telephoneLine),
              getCheckbox(fuelOil, 'Fuel/Oil', fuelOil),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [
            getCheckbox(machinery, 'Machinery', machinery),
            getCheckbox(vehicles, 'Vehicles', vehicles),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            getCheckbox(plane, 'Plane', plane),
            getCheckbox(waterSupply, 'Water supply', waterSupply),
          ]),
          const SizedBox(height: 20),
          Row(
            children: [
              getCheckbox(phoneMobile, 'Phone mobile', phoneMobile),
              getCheckbox(internet, 'Internet', internet),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('Has anyone missing?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ListTileTheme(
                        horizontalTitleGap: 0,
                        child: SizedBox(
                          height: 100,
                          width: 90,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: const Text('Yes'),
                            leading: Radio<YesNo>(
                              value: YesNo.yes,
                              groupValue: _anyoneMissing,
                              onChanged: (YesNo? value) {
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
                            leading: Radio<YesNo>(
                              value: YesNo.no,
                              groupValue: _anyoneMissing,
                              onChanged: (YesNo? value) {
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
                ],
              ),
              Column(
                children: [
                  const Text('Has anyone passed away?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ListTileTheme(
                        horizontalTitleGap: 0,
                        child: SizedBox(
                          height: 100,
                          width: 85,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: const Text('Yes'),
                            leading: Radio<YesNo>(
                              value: YesNo.yes,
                              groupValue: _anyoneMissing,
                              onChanged: (YesNo? value) {
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
                          width: 85,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: const Text('No'),
                            leading: Radio<YesNo>(
                              value: YesNo.no,
                              groupValue: _anyoneMissing,
                              onChanged: (YesNo? value) {
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
                ],
              ),
            ],
          ),
          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter Message',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5),
          const SizedBox(height: 20),
          CheckboxListTile(
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

  Widget getCheckbox(bool value, String label, key) {
    return SizedBox(
      height: 20,
      width: 170,
      child: CheckboxListTile(
        value: value,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? value) {
          setState(() {
            key = value;
          });
        },
        title: Text(label),
      ),
    );
  }
}
