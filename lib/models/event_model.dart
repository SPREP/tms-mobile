import 'package:collection/collection.dart';
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
  Widget? body;
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
  List? feel = [];
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

  Icon getIcon() {
    return const Icon(Icons.info);
  }

  Color getColor() {
    switch (type) {
      case EventType.earthquake:
      case EventType.volcano:
        return const Color.fromARGB(255, 131, 149, 234);
      case EventType.cyclone:
      case EventType.fire:
      case EventType.bushfile:
        return const Color.fromARGB(255, 216, 193, 113);
      case EventType.tsunami:
      case EventType.tornado:
        return const Color.fromARGB(255, 255, 126, 126);
    }
    return const Color.fromARGB(255, 131, 149, 234);
  }
}
