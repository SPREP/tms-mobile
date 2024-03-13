import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/event_model.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class EvacuationMapScreen extends StatefulWidget {
  const EvacuationMapScreen({super.key});

  @override
  State<EvacuationMapScreen> createState() => _EvacuationMapScreen();
}

class _EvacuationMapScreen extends State<EvacuationMapScreen> {
  List<EventModel> apiData = [];
  bool isLoading = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    setState(() {
      // isLoading = true;
      // getEvents();
    });
  }

  /**
   * Get user current position
   */
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  /**
   * Handle user location permission request
   */
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Evacuation Map'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        initialCenter: LatLng(-21.178986, -175.198242),
                        initialZoom: 10,
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
                            (_currentPosition?.latitude != null &&
                                    _currentPosition?.longitude != null)
                                ? Marker(
                                    point: LatLng(_currentPosition!.latitude,
                                        _currentPosition!.longitude),
                                    width: 50,
                                    height: 50,
                                    child: getMarker(
                                        'https://source.unsplash.com/random/200x200?sig=1'),
                                  )
                                : Marker(
                                    point: LatLng(-21.178986, -175.198242),
                                    width: 50,
                                    height: 50,
                                    child: getMarker(
                                        'https://source.unsplash.com/random/200x200?sig=1'),
                                  ),
                            Marker(
                              point: LatLng(-21.149379, -175.292833),
                              width: 50,
                              height: 50,
                              child: getMarker(
                                  'https://source.unsplash.com/random/200x200?sig=2'),
                            ),
                            Marker(
                              point: LatLng(-21.077545, -175.333798),
                              width: 50,
                              height: 50,
                              child: getMarker(
                                  'https://source.unsplash.com/random/200x200?sig=3'),
                            ),
                            Marker(
                              point: LatLng(-21.400836, -174.905030),
                              width: 50,
                              height: 50,
                              child: getMarker(
                                  'https://source.unsplash.com/random/200x200?sig=4'),
                            ),
                            Marker(
                              point: LatLng(-21.067089, -175.330512),
                              width: 50,
                              height: 50,
                              child: getMarker(
                                  'https://source.unsplash.com/random/200x200?sig=5'),
                            ),
                            Marker(
                              point: LatLng(-19.753643, -175.087173),
                              width: 50,
                              height: 50,
                              child: getMarker(
                                  'https://source.unsplash.com/random/200x200?sig=6'),
                            ),
                            Marker(
                              point: LatLng(-19.647035, -174.293453),
                              width: 50,
                              height: 50,
                              child: getMarker(
                                  'https://source.unsplash.com/random/200x200?sig=7'),
                            ),
                            Marker(
                              point: LatLng(-20.251629, -174.805178),
                              width: 50,
                              height: 50,
                              child: getMarker(
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
      onTap: () {},
    );
  }
}
