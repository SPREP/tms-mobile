import 'package:flutter/material.dart';

class NotificationModel {
  final int level;
  final String body;

  const NotificationModel(this.level, this.body);

  Icon getIcon() {
    switch (level) {
      case 1:
        return const Icon(
          Icons.info,
          color: Colors.white,
          size: 30,
        );
      case 2:
      case 3:
        return const Icon(
          Icons.warning,
          color: Colors.white,
          size: 30,
        );
    }
    return const Icon(Icons.abc);
  }

  Color getColor() {
    switch (level) {
      case 1:
        return const Color.fromARGB(255, 131, 149, 234);
      case 2:
        return const Color.fromARGB(255, 216, 193, 113);
      case 3:
        return const Color.fromARGB(255, 255, 126, 126);
    }
    return const Color.fromARGB(255, 131, 149, 234);
  }
}
