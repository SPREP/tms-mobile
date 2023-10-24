import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/notification_model.dart';
import 'package:macres/widgets/notification_widget.dart';
import 'package:macres/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  List<NotificationModel> apiData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      getEvents();
    });
  }

  getEvents() async {
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;

    var prefs = await SharedPreferences.getInstance();
    var lng = prefs.getString('user_language');

    String endpoint = '/notification/$lng?_format=json';

    final basicAuth =
        "Basic ${base64.encode(utf8.encode('$username:$password'))}";
    dynamic response;
    try {
      response = await http.get(
        Uri.parse('$host$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuth
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body).isEmpty) {
          setState(() {
            isLoading = false;
          });
          return [];
        }

        final Map<String, dynamic> listData = jsonDecode(response.body);
        final List<NotificationModel> loadedItems = [];

        for (final item in listData.entries) {
          loadedItems.add(NotificationModel(
              id: int.parse(item.value['id']),
              date: item.value['date'],
              time: item.value['time'],
              body: item.value['body'] ?? '',
              level: int.parse(item.value['level']),
              location: item.value['target_location'],
              title: item.value['title']));
        }

        setState(() {
          apiData = loadedItems;
          isLoading = false;
        });

        return loadedItems;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text(
            'Error: Unable to load notification. Check your internet connection.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : apiData.isEmpty
                ? const Center(
                    child: Text('No notification at this time'),
                  )
                : Column(
                    children: apiData.map<Widget>((notificationObject) {
                    return NotificationWidget(notification: notificationObject);
                  }).toList()),
      ),
    );
  }
}
