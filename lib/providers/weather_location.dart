import 'package:flutter/material.dart';
import 'package:macres/models/settings_model.dart';

class WeatherLocationProvider with ChangeNotifier {
  Location _selectedLocation = Location.tongatapu;
  Location get selectedLocation => _selectedLocation;

  void setLocation(Location selectLocation) {
    _selectedLocation = selectLocation;
    notifyListeners();
  }
}
