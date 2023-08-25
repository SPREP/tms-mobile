import 'package:flutter/material.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/widgets/event_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    super.initState();
    setState(() {
      isLoading = true;
    });
    getEvents();
  }

  getEvents() async {
    const username = 'mobile_app';
    const password = 'intel13!';
    final basicAuth =
        "Basic ${base64.encode(utf8.encode('$username:$password'))}";
    dynamic response;

    response = await http.get(
      Uri.parse('http://met-api.lndo.site/api/v1/event?_format=json'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': basicAuth
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = jsonDecode(response.body);
      final List<EventModel> _loadedItems = [];
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

        _loadedItems.add(EventModel(
          type: EventTypeExtension.fromName(item.value['type']),
          id: int.parse(item.value['id']),
          date: item.value['field_date'],
          magnitude: magnitude,
          depth: item.value['field_depth'],
          lat: lat,
          lon: lon,
          category: int.parse(item.value['field_category'] ?? '0'),
          name: item.value['field_name'],
        ));
      }

      setState(() {
        apiData = _loadedItems;
        isLoading = false;
      });

      return _loadedItems;
    } else {
      throw Exception('Failed to load event');
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
            : Column(
                children: apiData.map<Widget>((eventObject) {
                return EventWidget(event: eventObject);
              }).toList()),
      ),
    );
  }
}
