import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';

import 'package:macres/config/app_config.dart';
import 'package:macres/models/evacuation_model.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:macres/screens/evacuation_details_screen.dart';
import 'package:macres/util/user_location.dart';
import 'package:macres/widgets/evacuation_map_legend.dart';

class EvacuationMapScreen extends StatefulWidget {
  EvacuationMapScreen({super.key});
  final userLocation = new UserLocation();

  @override
  State<EvacuationMapScreen> createState() => _EvacuationMapScreen();
}

class _EvacuationMapScreen extends State<EvacuationMapScreen> {
  bool isLoading = false;

  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;
  bool _showLegends = false;
  double _mapheight = 0.0;

  @override
  void initState() {
    _alignPositionOnUpdate = AlignOnUpdate.never;
    _alignPositionStreamController = StreamController<double?>();
    super.initState();
  }

  void displose() {
    _alignPositionStreamController.close();
    super.dispose();
  }

  getMapHeight() {
    //calculate the map height
    final fullHeight = MediaQuery.of(context).size.height;
    final appBar = AppBar();
    final appBarHeight =
        appBar.preferredSize.height; // + MediaQuery.of(context).padding.top;
    final mapHeight = fullHeight - appBarHeight;
    return mapHeight;
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
      /*
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text('Error: Unable to load evacuation data.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      */
      print(e);
    }
    return data;
  }

  Widget drawUserLocationCircle() {
    return CircleLayer(circles: [
      CircleMarker(
          //radius marker
          point: LatLng(
            widget.userLocation.currentPosition!.latitude,
            widget.userLocation.currentPosition!.longitude,
          ),
          color: Colors.blue.withOpacity(0.9),
          borderStrokeWidth: 4.0,
          borderColor: Colors.white,
          radius: 30 //radius
          )
    ]);
  }

  Widget labelUserLocationCircle() {
    return MarkerLayer(
      markers: [
        Marker(
            width: 50.0,
            height: 50.0,
            point: LatLng(
              widget.userLocation.currentPosition!.latitude,
              widget.userLocation.currentPosition!.longitude,
            ),
            child: Container(
              child: Text(
                'You Are Here',
                style: TextStyle(color: Colors.white, height: 1.0),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double lat = -21.178986;
    double lon = -175.198242;
    final MapController _mapController = MapController();

    widget.userLocation.getCurrentPosition();

    if (widget.userLocation.currentPosition != null) {
      //lat = widget.userLocation.currentPosition!.latitude;
      //lon = widget.userLocation.currentPosition!.longitude;
    }

    _mapheight = getMapHeight();

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
                        height: this._mapheight,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(),
                          child: FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: LatLng(lat, lon),
                              initialZoom: 12,
                              keepAlive: true,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                                tileBuilder: (Theme.of(context).brightness ==
                                        Brightness.dark)
                                    ? _darkModeTileBuilder
                                    : null,
                              ),
                              /*
                              CurrentLocationLayer(
                                alignPositionStream:
                                    _alignPositionStreamController.stream,
                                alignPositionOnUpdate: _alignPositionOnUpdate,
                                style: LocationMarkerStyle(
                                  markerSize: Size.square(50),
                                  marker: DefaultLocationMarker(
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          'You are here',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              height: 0),
                                        )),
                                  ),
                                ),
                              ),
                              */
                              if (widget.userLocation.currentPosition != null)
                                drawUserLocationCircle(),
                              if (widget.userLocation.currentPosition != null)
                                labelUserLocationCircle(),
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
                                      heroTag: 'nearest',
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
                                Positioned(
                                  right: 10,
                                  top: 100,
                                  child: FloatingActionButton(
                                      tooltip: 'User Location',
                                      heroTag: 'userlocation',
                                      child: const Icon(
                                        Icons.my_location,
                                      ),
                                      onPressed: () {
                                        widget.userLocation
                                            .getCurrentPosition();
                                        if (widget
                                                .userLocation.currentPosition !=
                                            null) {
                                          drawUserLocationCircle();
                                          labelUserLocationCircle();
                                          _mapController.move(
                                              LatLng(
                                                widget.userLocation
                                                    .currentPosition!.latitude,
                                                widget.userLocation
                                                    .currentPosition!.longitude,
                                              ),
                                              13);
                                        }
                                      }),
                                ),
                              ]),
                              Stack(children: [
                                Positioned(
                                  left: 0,
                                  top: -375,
                                  child: EvacuationMapLegend(),
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

  //Build map dark mode
  Widget _darkModeTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        -0.2126,
        -0.7152,
        -0.0722,
        0,
        255,
        -0.2126,
        -0.7152,
        -0.0722,
        0,
        255,
        -0.2126,
        -0.7152,
        -0.0722,
        0,
        255,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: tileWidget,
    );
  }

  getNearest(data) {
    EvacuationModel evacuationPoint = EvacuationModel();
    final Distance distance = Distance();
    double km = 0;
    double currentKm = 0;
    double totalKm = 0;
    widget.userLocation.getCurrentPosition();
    if (widget.userLocation.currentPosition != null) {
      for (var item in data) {
        km = distance.as(
          LengthUnit.Kilometer,
          new LatLng(item.lat, item.lon),
          new LatLng(widget.userLocation.currentPosition!.latitude,
              widget.userLocation.currentPosition!.longitude),
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

  getCurrentPositionMarker() {
    return Stack(
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
    );
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
