import 'package:flutter/material.dart';
import 'package:humanitarian_icons/humanitarian_icons.dart';

enum Category {
  hospital,
  fire,
  police,
  ambulance,
  wccc,
  majestyArmedForces,
  ndrmo,
}

const categoryLabel = {
  Category.hospital: "Hospital",
  Category.fire: "Fire Service",
  Category.police: "Police",
  Category.ambulance: "Ambulance",
  Category.wccc: 'Women Chrildrens Crisis Centre',
  Category.majestyArmedForces: 'Majesty Armed Forces',
  Category.ndrmo: "National Disaster Risk Management Office",
};

const categoryIcon = {
  Category.hospital: Icon(
    Icons.local_hospital,
    color: Color.fromARGB(255, 105, 130, 62),
  ),
  Category.fire: Icon(
    HumanitarianIcons.fire,
    color: Color.fromARGB(255, 206, 124, 64),
  ),
  Category.police: Icon(
    Icons.local_police,
    color: Colors.blue,
  ),
  Category.ambulance: Icon(
    HumanitarianIcons.ambulance,
    color: Color.fromARGB(255, 64, 160, 77),
  ),
  Category.wccc: Icon(
    HumanitarianIcons.children,
    color: Color.fromARGB(255, 64, 160, 77),
  ),
  Category.majestyArmedForces: Icon(
    HumanitarianIcons.national_army,
    color: Color.fromARGB(255, 64, 160, 77),
  ),
};
