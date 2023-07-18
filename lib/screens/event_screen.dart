import 'package:flutter/material.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/widgets/event_widget.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreen();
}

class _EventScreen extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            EventWidget(
              event: EventModel(1,
                  "Earthquake \n\nLorem ipsum dolor sit amet consectetur. Amet rhoncus"),
            ),
            EventWidget(
              event: EventModel(
                  3, 'TSunami Warning \n\nNotification critical warning'),
            ),
            EventWidget(
              event: EventModel(1,
                  "Flood \n\nLorem ipsum dolor sit amet consectetur. Amet rhoncus"),
            ),
            EventWidget(
              event: EventModel(
                  2, 'Cyclone Alert \n\n Notification critical warning'),
            ),
            EventWidget(
              event: EventModel(1,
                  "Earthquake \n\nLorem ipsum dolor sit amet consectetur. Amet rhoncus"),
            ),
            EventWidget(
              event:
                  EventModel(2, 'Earthquake \n\nNotification critical warning'),
            ),
          ],
        ),
      ),
    );
  }
}
