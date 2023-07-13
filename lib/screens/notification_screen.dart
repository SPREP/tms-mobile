import 'package:flutter/material.dart';
import 'package:macres/models/notification_model.dart';
import 'package:macres/widgets/notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 140),
        child: Column(
          children: [
            NotificationWidget(
              notification: NotificationModel(
                  1, "Lorem ipsum dolor sit amet consectetur. Amet rhoncus"),
            ),
            SizedBox(height: 5),
            NotificationWidget(
              notification:
                  NotificationModel(3, 'Notification critical warning'),
            ),
            SizedBox(height: 5),
            NotificationWidget(
              notification: NotificationModel(2,
                  "Lorem ipsum dolor sit amet consectetur. Amet rhoncus blandit "),
            ),
            SizedBox(height: 5),
            NotificationWidget(
              notification: NotificationModel(1,
                  "Lorem ipsum dolor sit amet consectetur. Amet rhoncus blandit "),
            ),
            SizedBox(height: 5),
            NotificationWidget(
              notification: NotificationModel(3,
                  "Lorem ipsum dolor sit amet consectetur. Amet rhoncus blandit "),
            ),
            SizedBox(height: 5),
            NotificationWidget(
              notification: NotificationModel(2,
                  "Lorem ipsum dolor sit amet consectetur. Amet rhoncus blandit "),
            ),
            SizedBox(height: 5),
            NotificationWidget(
              notification: NotificationModel(1,
                  "Lorem ipsum dolor sit amet consectetur. Amet rhoncus blandit "),
            ),
            SizedBox(height: 5),
            NotificationWidget(
              notification: NotificationModel(1,
                  "Lorem ipsum dolor sit amet consectetur. Amet rhoncus blandit "),
            ),
          ],
        ),
      ),
    );
  }
}
