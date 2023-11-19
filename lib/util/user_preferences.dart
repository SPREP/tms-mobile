import 'package:macres/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("userId", user.userId!);
    prefs.setString("name", user.name!);
    prefs.setString("email", user.email!);
    prefs.setString("token", user.token!);
    prefs.setString("photo", user.photo!);

    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("userId");
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? token = prefs.getString("token");
    String? photo = prefs.getString("photo");

    var user = UserModel(
      userId: userId,
      name: name,
      email: email,
      token: token,
      photo: photo,
    );
    return user;
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("userId");
    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("token");
    prefs.remove("photo");
  }
}
