import 'dart:ffi';

import 'package:flutter/material.dart';

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
  final int level;
  Widget? body;
  final EventType type;
  String? time;
  String? date;
  num? category;
  num? km;
  num? depth;
  Bool? tsunami;
  num? magnitude;
  String? location;
  Bool? evacuate;
  double lat;
  double lon;

  EventModel({
    required this.level,
    this.body,
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
  });

  Icon getIcon() {
    switch (level) {
      case 1:
        return const Icon(Icons.info);
      case 2:
      case 3:
        return const Icon(Icons.warning);
    }
    return const Icon(Icons.abc);
  }

  Color getColor() {
    switch (level) {
      case 1:
        return const Color.fromARGB(255, 131, 149, 234);
      case 2:
        return const Color.fromARGB(255, 216, 193, 113);
      case 3:
        return const Color.fromARGB(255, 255, 126, 126);
    }
    return const Color.fromARGB(255, 131, 149, 234);
  }
}
