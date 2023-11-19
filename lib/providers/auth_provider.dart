import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/user_model.dart';
import 'package:macres/providers/user_provider.dart';
import 'package:macres/util/user_preferences.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> forgot(String email) async {
    var result;
    final Map<String, dynamic> forgotData = {
      'user': {'mail': email}
    };

    Response response = await post(
      Uri.parse(AppConfig.forgotPasswordEndpoint),
      body: json.encode(forgotData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode < 500) {
      result = {
        'status_code': response.statusCode,
        'message': json.decode(response.body)['message']
      };
    } else {
      result = {
        'status_code': response.statusCode,
        'message': 'Please try again later',
      };
    }

    return result;
  }

  Future<bool> isLogin(UserModel user) async {
    Response response = await get(
      Uri.parse("${AppConfig.baseUrl}/user/${user.userId}?_format=json"),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': user.token.toString()
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      UserPreferences userp = new UserPreferences();
      userp.removeUser();
      return false;
    }
  }

  Future<bool> logout() async {
    UserPreferences userp = new UserPreferences();
    userp.removeUser();
    Response response = await post(
      Uri.parse(AppConfig.logoutEndpoint),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _loggedInStatus = Status.LoggedOut;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future getCsrfToken() async {
    Future<UserModel> getUser() => UserPreferences().getUser();
    final user = await getUser();

    Response response = await get(
      Uri.parse("${AppConfig.localUrl}/session/token"),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': user.token.toString()
      },
    );

    return response.body;
  }

  Future<Map<String, dynamic>> profileUpdate(List data) async {
    var result;

    Future<UserModel> getUser() => UserPreferences().getUser();
    final user = await getUser();

    //final Map<String, dynamic> updateData = {'user': data};

    //Get CSRF token
    final csrfToken = await getCsrfToken();

    Response response = await patch(
      Uri.parse("${AppConfig.baseUrl}/user/${user.userId}?_format=json"),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': user.token.toString(),
        'X-CSRF-Token': csrfToken,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      UserModel updatedUser = UserModel.fromJson(responseData);
      updatedUser.token = user.token; //<-- put back the token
      UserPreferences().saveUser(updatedUser);

      //notify there's an update to user
      UserProvider userProvider = new UserProvider();
      userProvider.setUser(updatedUser);
      userProvider.notifyListeners();

      result = {
        'status_code': response.statusCode,
        'message': 'Successful',
        'user': updatedUser
      };
    } else if (response.statusCode == 400) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status_code': response.statusCode,
        'message': json.decode(response.body)['message']
      };
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status_code': response.statusCode,
        'message': 'Please try again later',
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'user': {'mail': email, 'pass': password}
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(AppConfig.loginEndpoint),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      //get session cookie
      var header = response.headers;
      var userData = responseData;
      UserModel authUser = UserModel.fromJson(userData);

      var cookiesJar = header['set-cookie']!.split(';');
      authUser.token = cookiesJar[0];
      UserPreferences().saveUser(authUser);
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {
        'status_code': response.statusCode,
        'message': 'Successful',
        'user': authUser
      };
    } else if (response.statusCode == 400) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status_code': response.statusCode,
        'message': json.decode(response.body)['message']
      };
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status_code': response.statusCode,
        'message': 'Please try again later',
      };
    }

    return result;
  }

  Future<FutureOr> register(String mail, String pass, String name) async {
    final Map<String, dynamic> registrationData = {
      'name': name,
      'mail': mail,
      'pass': pass
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();

    return await post(Uri.parse(AppConfig.registerEndpoint),
            body: json.encode(registrationData),
            headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      result = {'status': true, 'message': 'Successfully registered'};
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
