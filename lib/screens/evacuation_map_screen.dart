import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/evacuation_model.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:macres/models/event_model.dart';
import 'package:macres/screens/evacuation_details_screen.dart';
import 'package:provider/provider.dart';

class EvacuationMapScreen extends StatefulWidget {
  const EvacuationMapScreen({super.key});

  @override
  State<EvacuationMapScreen> createState() => _EvacuationMapScreen();
}

class _EvacuationMapScreen extends State<EvacuationMapScreen> {
  bool isLoading = false;
  Position? _currentPosition;
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    initEvacuation();
    setState(() {
      isLoading = true;
    });
  }

  initEvacuation() async {
    //return await getEvacuation();
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

  Future<List<EvacuationModel>> getEvacuation() async {
    var username = AppConfig.userName;
    var password = AppConfig.password;
    var host = AppConfig.baseUrl;
    List<EvacuationModel> data = [];
    String endpoint = '/evacuation?_format=json';

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
          return [];
        }

        final loaded_data = json.decode(response.body) as List<dynamic>;
        return loaded_data
            .map((json) => EvacuationModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text('Error: Unable to load evacuation data.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    double lat = -21.178986;
    double lon = -175.198242;

    if (_currentPosition != null) {
      lat = _currentPosition!.latitude;
      lon = _currentPosition!.longitude;
    }

    return FutureBuilder<List<EvacuationModel>>(
        future: getEvacuation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the task is happening, show a loading spinner
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
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
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter: LatLng(lat, lon),
                              initialZoom: 12,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              CurrentLocationLayer(),
                              SuperclusterLayer.immutable(
                                indexBuilder: IndexBuilders.rootIsolate,
                                builder: (context, position, markerCount,
                                        extraClusterData) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Color.fromARGB(255, 223, 110, 34),
                                  ),
                                  child: Center(
                                    child: Text(
                                      markerCount.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                initialMarkers: getMarkers(snapshot.data),
                              ),
                              Stack(children: [
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: FloatingActionButton(
                                      tooltip: 'Nearest',
                                      child: const Icon(
                                        Icons.near_me,
                                      ),
                                      onPressed: () {
                                        EvacuationModel evm =
                                            getNearest(snapshot.data);

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EvacuationDetailsScreen(
                                                    model: evm),
                                          ),
                                        );
                                      }),
                                ),
                              ]),
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
        });
  }

  getMarkers(data) {
    var markers = <Marker>[];

    for (var item in data) {
      markers.add(
        Marker(
          point: LatLng(item.lat, item.lon),
          width: 50,
          height: 50,
          child: getMarker(item.image_thumbnail, item),
        ),
      );
    }
    return markers;
  }

  void displose() {
    mapController.dispose();
    super.dispose();
  }

  getNearest(data) {
    EvacuationModel evacuationPoint = EvacuationModel();
    final Distance distance = Distance();
    double km = 0;
    double currentKm = 0;
    double totalKm = 0;

    if (_currentPosition != null) {
      for (var item in data) {
        km = distance.as(
          LengthUnit.Kilometer,
          new LatLng(item.lat, item.lon),
          new LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        );

        totalKm += km;

        if (currentKm == 0) {
          currentKm = km;
        }

        if (km < currentKm) {
          currentKm = km;
          evacuationPoint = item;
        }
      }
    }

    evacuationPoint.nearestKm = totalKm;

    return evacuationPoint;
  }

  getMarker(String image, EvacuationModel model) {
    return InkWell(
      child: Stack(
        children: [
          Icon(
            Icons.add_location,
            color: Color.fromARGB(255, 6, 124, 45),
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
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: Colors.white,
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
            builder: (context) => EvacuationDetailsScreen(model: model),
          ),
        );
      },
    );
  }
}
