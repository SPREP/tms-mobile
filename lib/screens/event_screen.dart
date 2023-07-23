import 'package:flutter/material.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/models/settings_model.dart';
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
    },
    {
      'type': EventType.earthquake,
      'time': '12:20PM',
      'date': 'Today',
      'magnitude': 3.6,
      'level': 2,
    },
    {
      'type': EventType.volcano,
      'time': '8:07AM',
      'date': 'Wednesday',
      'location': 'Tofua',
      'level': 3,
    },
    {
      'type': EventType.earthquake,
      'time': '12:20PM',
      'date': 'Today',
      'magnitude': 3.6,
      'level': 2,
    },
    {
      'type': EventType.cyclone,
      'time': '10:10PM',
      'date': 'Yesterday',
      'location': "Niuafo'ou",
      'level': 1,
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
                  item['level'],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventTypeLabel[item['type']].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (item.containsKey('time'))
                        Text("Time: ${item['time']}"),
                      if (item.containsKey('date'))
                        Text("Date: ${item['date'].toString()}"),
                      if (item.containsKey('magnitude'))
                        Text("Magnitude: ${item['magnitude'].toString()}"),
                      if (item.containsKey('category'))
                        Text("Category: ${item['category'].toString()}"),
                      if (item.containsKey('location'))
                        Text("Location: ${item['location'].toString()}"),
                      if (item.containsKey('evacuation'))
                        Text("Evacuation: ${item['evacuation'].toString()}"),
                    ],
                  ),
                  item['type'],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
