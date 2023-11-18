import 'package:macres/models/user_model.dart';
import 'package:macres/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("userId", user.userId!);
    prefs.setString("name", user.name!);
    prefs.setString("email", user.email!);
    prefs.setString("token", user.token!);
    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("userId");
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? token = prefs.getString("token");

    var user = UserModel(
      userId: userId,
      name: name,
      email: email,
      token: token,
    );

    var isLogin;
    if (token != null) {
      isLogin = await AuthProvider().isLogin(user);
      if (isLogin == false) {
        user.token = null;
      }
    }

    return user;
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("userId");
    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("token");
  }
}
