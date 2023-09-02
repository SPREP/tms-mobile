import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

enum Language { en, to }

enum Location { tongatapu, haapai, vavau, niuafoou, niuatoputapu, eua }

const locationLabel = {
  Location.tongatapu: "Tongatapu",
  Location.haapai: "Ha'apai",
  Location.vavau: "Vava'u",
  Location.niuafoou: "Niuafo'ou",
  Location.niuatoputapu: "Niuatoputapu",
  Location.eua: "'Eua",
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

const metapi = {
  // Credential.host:
  //  "https://d81f-2001-8003-474c-7400-250a-f61f-c861-fef7.ngrok-free.app/api/v1",
  Credential.host: "http://app.met.gov.to/api/v1",
  Credential.username: 'mobile_app',
  Credential.password: 'intel13!',
};
