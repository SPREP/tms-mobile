import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/models/settings_model.dart';
import 'package:macres/screens/forms/tk_indicator_form.dart';
import 'package:macres/screens/tk_details_screen.dart';
import 'package:macres/widgets/event_widget.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class TkScreen extends StatefulWidget {
  const TkScreen({super.key});

  @override
  State<TkScreen> createState() => _TkScreen();
}

class _TkScreen extends State<TkScreen> {
  List<EventModel> apiData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      // isLoading = true;
      // getEvents();
    });
  }

  getEvents() async {
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;
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
            feel: item.value['feel'] ?? [],
          ));
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
            'Error: Unable to load events. Check your internet connection.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Color.fromARGB(255, 242, 240, 240),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TkIndicatorForm(),
                      ),
                    );
                  },
                  label: const Text(
                    "Add Indicator",
                  ),
                  icon: Icon(Icons.add),
                ),
                Spacer(),
                TextButton.icon(
                  onPressed: () {
                    print('Map view');
                  },
                  label: const Text(
                    "Map",
                  ),
                  icon: Icon(Icons.map),
                ),
                TextButton.icon(
                  onPressed: () {
                    print('List view');
                  },
                  label: const Text(
                    "List",
                  ),
                  icon: Icon(Icons.list),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(),
                  child: FlutterMap(
                    mapController: MapController(),
                    options: MapOptions(
                      center: LatLng(-21.178986, -175.198242),
                      zoom: 10,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      SuperclusterLayer.immutable(
                        indexBuilder: IndexBuilders.rootIsolate,
                        builder: (context, position, markerCount,
                                extraClusterData) =>
                            Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text(
                              markerCount.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        initialMarkers: [
                          Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            point: LatLng(-21.178986, -175.198242),
                            width: 50,
                            height: 50,
                            builder: (context) => getMarker(
                                'https://source.unsplash.com/random/200x200?sig=1'),
                          ),
                          Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            point: LatLng(-21.149379, -175.292833),
                            width: 50,
                            height: 50,
                            builder: (context) => getMarker(
                                'https://source.unsplash.com/random/200x200?sig=2'),
                          ),
                          Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            point: LatLng(-21.077545, -175.333798),
                            width: 50,
                            height: 50,
                            builder: (context) => getMarker(
                                'https://source.unsplash.com/random/200x200?sig=3'),
                          ),
                          Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            point: LatLng(-21.400836, -174.905030),
                            width: 50,
                            height: 50,
                            builder: (context) => getMarker(
                                'https://source.unsplash.com/random/200x200?sig=4'),
                          ),
                          Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            point: LatLng(-21.067089, -175.330512),
                            width: 50,
                            height: 50,
                            builder: (context) => getMarker(
                                'https://source.unsplash.com/random/200x200?sig=5'),
                          ),
                          Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            point: LatLng(-19.753643, -175.087173),
                            width: 50,
                            height: 50,
                            builder: (context) => getMarker(
                                'https://source.unsplash.com/random/200x200?sig=6'),
                          ),
                          Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            point: LatLng(-19.647035, -174.293453),
                            width: 50,
                            height: 50,
                            builder: (context) => getMarker(
                                'https://source.unsplash.com/random/200x200?sig=7'),
                          ),
                          Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            point: LatLng(-20.251629, -174.805178),
                            width: 50,
                            height: 50,
                            builder: (context) => getMarker(
                                'https://source.unsplash.com/random/200x200?sig=8'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getMarker(String image) {
    return InkWell(
      child: Stack(
        children: [
          Icon(
            Icons.add_location,
            color: Color.fromARGB(255, 215, 27, 27),
            size: 50,
          ),
          Positioned(
            left: 13,
            top: 8,
            child: Container(
              width: 24,
              height: 24,
              child: Center(
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundImage: NetworkImage(image),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TkDetailsScreen(),
          ),
        );
      },
    );
  }
}
