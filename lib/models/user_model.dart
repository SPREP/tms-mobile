class UserModel {
  String? userId;
  String? name;
  String? email;
  String? token;

  UserModel({this.userId, this.name, this.email, this.token});

  factory UserModel.fromJson(Map<String, dynamic> responseData) {
    return UserModel(
        userId: responseData['id'],
        name: responseData['name'],
        email: responseData['mail'],
        token: responseData['token']);
  }
}
