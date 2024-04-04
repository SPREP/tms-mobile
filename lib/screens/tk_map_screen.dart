import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/models/tk_model.dart';
import 'package:macres/screens/forms/tk_indicator_form.dart';
import 'package:macres/screens/tk_details_screen.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class TkMapScreen extends StatefulWidget {
  const TkMapScreen({super.key});

  @override
  State<TkMapScreen> createState() => _TkMapScreen();
}

class _TkMapScreen extends State<TkMapScreen> {
  final mapController = new MapController();

  List<EventModel> apiData = [];
  bool isLoading = false;
  final AsyncMemoizer<List<TkModel>> _memoizer = AsyncMemoizer<List<TkModel>>();
  int _totalIndicatorReported = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<List<TkModel>> getTk() async {
    return this._memoizer.runOnce(() async {
      var username = AppConfig.userName;
      var password = AppConfig.password;
      var host = AppConfig.baseUrl;
      String endpoint = '/tk/tk?_format=json';
      List<TkModel> data = [];

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

          final loaded_data = json.decode(response.body) as List<dynamic>;
          var data = loaded_data.map((json) => TkModel.fromJson(json)).toList();
          this._totalIndicatorReported = data.length;

          return data;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        const snackBar = SnackBar(
          content: Text('Error: Unable to load traditional knowledge data.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print(e);
      }
      return data;
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
          child: getMarker(item),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traditional Knowledge'),
        backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
        foregroundColor: Colors.white,
      ),
      body: builder(),
    );
  }

  Widget builder() {
    return FutureBuilder<List<TkModel>>(
        future: getTk(),
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
                            "Report Indicator",
                          ),
                          icon: Icon(Icons.add),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            '$_totalIndicatorReported Reported',
                          ),
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
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter: LatLng(-21.178986, -175.198242),
                              initialZoom: 5,
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                initialMarkers: getMarkers(snapshot.data),
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
        });
  }

  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  getMarker(TkModel item) {
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
                    backgroundImage: NetworkImage(item.image!),
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
            builder: (context) => TkDetailsScreen(tkModel: item),
          ),
        );
      },
    );
  }
}
