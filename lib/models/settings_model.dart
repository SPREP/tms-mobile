import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

enum Language { en, to }

enum Location { select, tongatapu, haapai, vavau, niuafoou, niuatoputapu, eua }

const locationLabel = {
  Location.select: "Select...",
  Location.tongatapu: "Tongatapu",
  Location.haapai: "Ha'apai",
  Location.vavau: "Vava'u",
  Location.niuafoou: "Niuafo'ou",
  Location.niuatoputapu: "Niuatoputapu",
  Location.eua: "'Eua",
};

const languageLabel = {
  Language.en: "English",
  Language.to: "Tongan",
};
