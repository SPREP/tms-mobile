import 'package:flutter/material.dart';
import 'package:macres/models/notification_model.dart';
import 'package:macres/screens/notification_details_screen.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.notification});
  final NotificationModel notification;

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
                  color: notification.getColor(),
                  padding: const EdgeInsets.all(10),
                  height: 120,
                  child: notification.getIcon(),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "${notification.body!.characters.take(100).toString()} ..."),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Text(
                            "Time: ${notification.time} ${notification.date}",
                            style: const TextStyle(
                              backgroundColor:
                                  Color.fromARGB(255, 250, 202, 165),
                            ),
                          ),
                        ),
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
      ],
    );
  }
}
