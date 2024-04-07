import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

final formatter = DateFormat.yMd();

enum Language { en, to }

enum Location { tongatapu, haapai, vavau, niuafoou, niuatoputapu, eua }

extension LocationExtension on Location {
  static Location? fromName(String? name) {
    return Location.values.firstWhereOrNull((e) => e.name == name);
  }
}

extension LanguageExtension on Language {
  static Language? fromName(String? name) {
    return Language.values.firstWhereOrNull((e) => e.name == name);
  }
}

const locationLabel = {
  Location.tongatapu: "Tongatapu",
  Location.haapai: "Ha'apai",
  Location.vavau: "Vava'u",
  Location.niuafoou: "Niuafo'ou",
  Location.niuatoputapu: "Niuatoputapu",
  Location.eua: "'Eua",
};

//Map the main region to it's Drupal taxonomy term ID
const locationIds = {
  Location.tongatapu: 14,
  Location.haapai: 16,
  Location.vavau: 15,
  Location.niuafoou: 18,
  Location.niuatoputapu: 19,
  Location.eua: 17,
};

const locationColor = {
  Location.tongatapu: Color.fromARGB(255, 130, 155, 118),
  Location.haapai: Color.fromARGB(255, 113, 138, 156),
  Location.vavau: Color.fromARGB(255, 157, 163, 105),
  Location.niuafoou: Color.fromARGB(255, 183, 103, 148),
  Location.niuatoputapu: Color.fromARGB(255, 79, 167, 180),
  Location.eua: Color.fromARGB(255, 126, 74, 125),
};

const languageLabel = {
  Language.en: "English",
  Language.to: "Tongan",
};

enum Credential { host, username, password }
