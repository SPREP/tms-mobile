class VillageModel {
  String? name;
  int? id;

  VillageModel({this.name, this.id}) {}

  VillageModel.fromJson(dynamic json) {
    name = json['name'];
    id = int.parse(json['id']);
  }
}
