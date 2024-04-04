class TkModel {
  String? title;
  String? image;
  double? lat;
  double? lon;
  int? id;
  String? time;
  String? date;
  String? timestamp;
  TkIndicatorModel? indicator;
  String? author;
  String? author_photo;
  String? author_name;

  TkModel(
      {this.title,
      this.image,
      this.lat,
      this.lon,
      this.id,
      this.time,
      this.date,
      this.timestamp,
      this.indicator,
      this.author_name,
      this.author_photo}) {}

  TkModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    time = json['time'];
    date = json['date'];
    lat = json['lat'] != '' ? double.parse(json['lat'].toString()) : 0.0;
    lon = json['lon'] != '' ? double.parse(json['lon'].toString()) : 0.0;
    timestamp = json['timestamp'];
    image = json['photo'];
    indicator = TkIndicatorModel.fromJson(json['indicator']);
    author_name = json['author_name'];
    author_photo = json['author_image'];
  }
}

class TkIndicatorModel {
  String? name;
  String? desc;
  String? photo;
  int? id;
  int? weight;

  TkIndicatorModel({this.name, this.desc, this.photo, this.id, this.weight}) {}

  TkIndicatorModel.fromJson(dynamic json) {
    name = json['name'];
    desc = json['desc'];
    photo = json['photo'];
    id = json['id'];
    weight = json['weight'];
  }
}
