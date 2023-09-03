import 'package:flutter/material.dart';
import 'package:macres/models/notification_model.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.notification});
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width * 0.8;

    return Column(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Container(
                color: notification.getColor(),
                padding: const EdgeInsets.all(10),
                height: 100,
                child: notification.getIcon(),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: mWidth,
                child: Text(notification.body.toString()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
