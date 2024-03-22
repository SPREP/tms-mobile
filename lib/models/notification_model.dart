import 'package:flutter/material.dart';

class NotificationModel {
  num? id;
  num? level;
  String? body;
  String? time;
  String? date;
  String? title;
  String? location;

  NotificationModel({
    this.level,
    this.body,
    this.time,
    this.date,
    this.title,
    this.location,
    this.id,
  });

  Icon getIcon() {
    switch (level) {
      case 0:
        return const Icon(
          Icons.info,
          color: Colors.white,
          size: 30,
        );
      case 1:
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

  getLevelText() {
    String levelLabel = '';
    switch (level) {
      case 1:
        levelLabel = 'LOW';
        break;
      case 2:
        levelLabel = 'MEDIUM';
        break;
      case 3:
        levelLabel = 'HIGH';
        break;
      default:
    }
    return levelLabel;
  }

  Color getColor() {
    switch (level) {
      case 0:
        return const Color.fromRGBO(153, 204, 51, 0.4);
      case 1:
        return const Color.fromRGBO(250, 212, 62, 1.0); //255, 204, 0
      case 2:
        return const Color.fromRGBO(252, 168, 126, 1.0); // 255, 153, 102,
      case 3:
        return const Color.fromRGBO(207, 92, 54, 1.0); // 204, 51, 0
    }
    return const Color.fromRGBO(255, 204, 0, 1.0);
  }
}
