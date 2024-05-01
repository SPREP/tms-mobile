import 'package:flutter/material.dart';

class EvacuationModel {
  String? body;
  String? title;
  String? image_large;
  String? image_thumbnail;
  double? lat;
  double? lon;
  num? id;

  double? nearestKm;

  EvacuationModel(
      {this.body,
      this.title,
      this.lat = 0,
      this.lon = 0,
      this.id,
      this.image_large,
      this.image_thumbnail});

  EvacuationModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    image_large = json['image_large'];
    image_thumbnail = json['image_small'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    map['lat'] = lat;
    map['lon'] = lon;
    map['image_large'] = image_large;
    map['image_small'] = image_thumbnail;
    return map;
  }
}
