import 'package:flutter/material.dart';
import 'package:humanitarian_icons/humanitarian_icons.dart';

enum Category { hospital, fire, police, ambulance }

const categoryLabel = {
  Category.hospital: "Hospital",
  Category.fire: "Fire Service",
  Category.police: "Police",
  Category.ambulance: "Ambulance",
};

const categoryIcon = {
  Category.hospital: Icon(Icons.local_hospital),
  Category.fire: Icon(Icons.fire_truck),
  Category.police: Icon(Icons.local_police),
  Category.ambulance: Icon(HumanitarianIcons.ambulance),
};
