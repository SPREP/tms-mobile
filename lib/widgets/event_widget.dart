import 'package:flutter/material.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/screens/event_details_screen.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key, required this.event});
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width * 0.8;

    return Column(
      children: [
        InkWell(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                Container(
                  color: event.getColor(),
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: const Text(''),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: mWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventTypeLabel[event.type].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (event.name != null)
                        Text("Name: ${event.name.toString()}"),
                      if (event.time != null)
                        Text("Time: ${event.time.toString()}"),
                      if (event.date != null)
                        Text("Date: ${event.date.toString()}"),
                      if (event.magnitude != null && event.magnitude != 0.0)
                        Text("Magnitude: ${event.magnitude.toString()}"),
                      if (event.category != null && event.category != 0)
                        Text("Category: ${event.category.toString()}"),
                      if (event.location != null)
                        Text("Location: ${event.location.toString()}"),
                      if (event.evacuate != null)
                        Text("Evacuation: ${event.evacuate}"),
                      if (event.km != null)
                        Text("Kilometer: ${event.km.toString()}"),
                      if (event.depth != null)
                        Text("Depth: ${event.depth.toString()}"),
                      if (event.lon != null && event.lon != 0.0)
                        Text("Longitude: ${event.lon.toString()}"),
                      if (event.lat != null && event.lat != 0.0)
                        Text("Latitude: ${event.lat.toString()}"),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EventDetailsScreen(eventModel: event),
              ),
            );
          },
        ),
      ],
    );
  }
}
