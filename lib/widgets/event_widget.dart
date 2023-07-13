import 'package:flutter/material.dart';
import 'package:macres/models/event_model.dart';

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
                  child: Text(event.body),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ],
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
