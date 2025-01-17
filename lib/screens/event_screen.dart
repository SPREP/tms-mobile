import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/widgets/event_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreen();
}

class _EventScreen extends State<EventScreen> {
  List<EventModel> apiData = [];
  bool isLoading = false;

  @override
  void initState() {
    _clearCounter();
    setState(() {
      isLoading = true;
      _getEvents();
    });
    super.initState();
  }

  void _clearCounter() async {
    //save values
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('total_new_events', 0);
    setState(() {});
  }

  Future _getEvents() async {
    String username = AppConfig.userName;
    String password = AppConfig.password;
    String host = AppConfig.baseUrl;
    String endpoint = '/event?_format=json';

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
        final List<EventModel> loadedItems = [];

        for (final item in listData.entries) {
          var magnitude = 0.0;
          var lat = 0.0;
          var lon = 0.0;

          if (item.value['field_magnitude'] == null) {
            magnitude = 0.0;
          } else {
            magnitude = double.parse(item.value['field_magnitude']);
          }

          if (item.value['field_location'] != null) {
            var location = item.value['field_location'].split(',');
            lat = double.parse(location[0]);
            lon = double.parse(location[1]);
          }

          loadedItems.add(EventModel(
            type: EventTypeExtension.fromName(item.value['type']),
            id: int.parse(item.value['id']),
            date: item.value['date'],
            time: item.value['time'],
            magnitude: magnitude,
            depth: item.value['field_depth'],
            lat: lat,
            lon: lon,
            category: int.parse(item.value['field_category'] ?? '0'),
            name: item.value['field_name'] ?? '',
            feel: item.value['feel'] != null
                ? Feel.fromJson(item.value['feel'])
                : null,
            location: item.value['field_region'] ?? '',
            body: item.value['body'] ?? '',
          ));
        }

        setState(() {
          apiData = loadedItems;
          isLoading = false;
        });

        return loadedItems;
      }
    } catch (e) {
      /*
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text('Unable to load events.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      */
      print(e);
    }
  }

  Future<bool> hasInternet() async {
    try {
      final response = await http.head(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getEvents,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : apiData.isEmpty
                  ? const Center(
                      child: Text('No events at this time'),
                    )
                  : Column(
                      children: apiData.map<Widget>((eventObject) {
                      return EventWidget(event: eventObject);
                    }).toList()),
        ),
      ),
    );
  }
}
