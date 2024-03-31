import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:macres/screens/weather_forcast/weather_forcast_screen.dart';
import 'package:weather_icons/weather_icons.dart';

enum EventType {
  earthquake,
  cyclone,
  tornado,
  volcano,
  tsunami,
  flood,
  fire,
  bushfile
}

extension EventTypeExtension on EventType {
  static EventType? fromName(String? name) {
    return EventType.values.firstWhereOrNull((e) => e.name == name);
  }
}

const eventTypeLabel = {
  EventType.earthquake: 'Earthquake',
  EventType.cyclone: 'Cyclone',
  EventType.tornado: 'Tornado',
  EventType.volcano: 'Volcano Eruption',
  EventType.tsunami: 'TSunami',
  EventType.fire: 'Fire',
  EventType.flood: 'Flood',
  EventType.bushfile: 'Bush Fire',
};

class EventModel {
  String? body;
  EventType? type;
  String? time;
  String? date;
  num? category;
  num? km;
  String? depth;
  double? magnitude;
  String? location;
  bool? evacuate;
  double lat;
  double lon;
  num? id;
  String? name;
  Feel? feel = Feel();
  String? tsunami;

  EventModel(
      {this.body,
      required this.type,
      this.time,
      this.date,
      this.category,
      this.km,
      this.depth,
      this.tsunami,
      this.magnitude,
      this.location,
      this.evacuate,
      this.lat = 0,
      this.lon = 0,
      this.id,
      this.name,
      this.feel});

  Icon getIcon(double size, Color colour) {
    switch (type) {
      case EventType.tsunami:
        return Icon(WeatherIcons.tsunami, color: colour, size: size);
      case EventType.earthquake:
        return Icon(WeatherIcons.earthquake, color: colour, size: size);
      case EventType.cyclone:
        return Icon(Icons.cyclone, color: colour, size: size);
      case EventType.volcano:
        return Icon(WeatherIcons.volcano, color: colour, size: size);
      case EventType.fire:
        return Icon(WeatherIcons.fire, color: colour, size: size);
      case EventType.flood:
        return Icon(WeatherIcons.flood, color: colour, size: size);
      case EventType.tornado:
        return Icon(WeatherIcons.tornado, color: colour, size: size);
      case EventType.bushfile:
        return Icon(WeatherIcons.fire, color: colour, size: size);
      default:
        return Icon(Icons.info, color: colour, size: size);
    }
  }

  Color getColor() {
    switch (type) {
      case EventType.earthquake:
      case EventType.volcano:
        return const Color.fromARGB(255, 131, 149, 234);
      case EventType.cyclone:
      case EventType.fire:
      case EventType.bushfile:
        return Color.fromARGB(255, 197, 106, 182);
      case EventType.tsunami:
      case EventType.tornado:
        return Color.fromARGB(255, 179, 157, 90);
    }
    return const Color.fromARGB(255, 131, 149, 234);
  }
}

class Feel {
  int? tongatapu;
  int? vavau;
  int? eua;
  int? haapai;
  int? niuafoou;
  int? niuatoputapu;

  Feel(
      {this.tongatapu,
      this.vavau,
      this.eua,
      this.haapai,
      this.niuafoou,
      this.niuatoputapu}) {}

  factory Feel.fromJson(Map<String, dynamic> json) {
    return Feel(
        tongatapu: json['tongatapu'],
        vavau: json['vavau'],
        eua: json['eua'],
        haapai: json['haapai'],
        niuafoou: json['niuafoou'],
        niuatoputapu: json['niuatoputapu']);
  }
}
