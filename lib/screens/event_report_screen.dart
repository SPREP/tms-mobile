import 'package:flutter/material.dart';

class EventReportScreen extends StatefulWidget {
  const EventReportScreen({super.key});

  @override
  State<EventReportScreen> createState() => _EventReportScreenState();
}

class _EventReportScreenState extends State<EventReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Event Report',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Fill in the following fields, to report an event from your location. For exmaple:  If you see a fire, you can report it here.  If you see a smoke coming out from a Vocano.",
            style: TextStyle(fontSize: 13),
          ),
          const TextField(
            maxLength: 50,
            decoration: InputDecoration(
              label: Text('Title'),
            ),
          ),
          const TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            decoration: InputDecoration(
              label: Text('Enter the event details here'),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
