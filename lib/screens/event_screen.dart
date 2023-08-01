import 'package:flutter/material.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/widgets/event_widget.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreen();
}

class _EventScreen extends State<EventScreen> {
  List<Map> poolEvents = [
    {
      'type': EventType.earthquake,
      'time': '12:20PM',
      'date': 'Today',
      'magnitude': 3.6,
      'level': 1,
      'lat': 0.0,
      'lon': 0.0,
    },
    {
      'type': EventType.earthquake,
      'time': '12:20PM',
      'date': 'Today',
      'magnitude': 3.6,
      'level': 2,
      'category': 6,
      'lat': -21.178989,
      'lon': -177.198242,
    },
    {
      'type': EventType.volcano,
      'time': '8:07AM',
      'date': 'Wednesday',
      'location': 'Tofua',
      'level': 3,
      'lat': -21.178989,
      'lon': -177.198242,
    },
    {
      'type': EventType.earthquake,
      'time': '12:20PM',
      'date': 'Today',
      'magnitude': 3.6,
      'level': 2,
      'depth': 12,
      'lat': 0.0,
      'lon': 0.0,
    },
    {
      'type': EventType.cyclone,
      'time': '10:10PM',
      'date': 'Yesterday',
      'location': "Niuafo'ou",
      'level': 1,
      'category': 5,
      'lat': -21.178989,
      'lon': -177.198242,
      'km': 135,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            for (var item in poolEvents)
              EventWidget(
                event: EventModel(
                  level: item['level'],
                  type: item['type'],
                  date: item['date'],
                  time: item['time'],
                  location: item['location'],
                  category: item['category'],
                  evacuate: item['evacuation'],
                  magnitude: item['magnitude'],
                  depth: item['depth'],
                  lat: item['lat'],
                  lon: item['lon'],
                  km: item['km'],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
