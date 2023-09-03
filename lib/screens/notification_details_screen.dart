import 'package:flutter/material.dart';
import 'package:macres/models/notification_model.dart';

class NotificationDetailsScreen extends StatefulWidget {
  const NotificationDetailsScreen({super.key, required this.notificationModel});

  final NotificationModel notificationModel;

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Text(widget.notificationModel.title.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Text(widget.notificationModel.body.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
