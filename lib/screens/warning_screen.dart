import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/warning_model.dart';
import 'package:macres/widgets/warning_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreen();
}

class _WarningScreen extends State<WarningScreen> {
  List<WarningModel> apiData = [];
  bool isLoading = false;

  @override
  void initState() {
    _clearCounter();
    setState(() {
      isLoading = true;
      getEvents();
    });
    super.initState();
  }

  void _clearCounter() async {
    //save values
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('total_new_warnings', 0);
    setState(() {});
  }

  getEvents() async {
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;

    var prefs = await SharedPreferences.getInstance();
    // Set default in case its null or empty otherwise endpoint wont work.
    var lng = prefs.getString('user_language') ?? 'en';
    if (lng.isEmpty) {
      lng = 'en';
    }

    String endpoint = '/warning/$lng?_format=json';

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
        final List<WarningModel> loadedItems = [];

        for (final item in listData.entries) {
          loadedItems.add(WarningModel(
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
        content: Text('Error: Unable to load warnings.'),
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
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : apiData.isEmpty
                ? const Center(
                    child: Text('No warnings at this time'),
                  )
                : Column(
                    children: apiData.map<Widget>((warningObject) {
                    return WarningWidget(warning: warningObject);
                  }).toList()),
      ),
    );
  }
}
