import 'package:flutter/material.dart';
import 'package:macres/models/notification_model.dart';
import 'package:macres/screens/notification_details_screen.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.notification});
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width * 0.8;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 222, 223, 223)),
      ),
      margin: EdgeInsets.all(3.0),
      child: InkWell(
        child: Row(
          children: [
            Container(
              color: notification.getColor(),
              height: 150.0,
              width: 42.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    notification.getIcon(),
                    Text(
                      notification.getLevelText(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 8),
                    )
                  ]),
              padding: EdgeInsets.only(left: 3.0, right: 3.0),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: mWidth,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      notification.title.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform(
                        transform: new Matrix4.identity()..scale(0.8),
                        child: Chip(
                          avatar: Icon(Icons.lock_clock),
                          backgroundColor: Color.fromARGB(255, 234, 233, 233),
                          label: Text(
                            notification.date.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Transform(
                        transform: new Matrix4.identity()..scale(0.8),
                        child: new Chip(
                          avatar: Icon(Icons.calendar_today),
                          padding: EdgeInsets.all(2.0),
                          backgroundColor: Color.fromARGB(255, 234, 233, 233),
                          label: Text(
                            notification.time.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotificationDetailsScreen(
                notificationModel: notification,
              ),
            ),
          );
        },
      ),
    );
  }
}
