import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:macres/models/tk_model.dart';
import 'package:latlong2/latlong.dart';

class TkDetailsScreen extends StatefulWidget {
  const TkDetailsScreen({super.key, required this.tkModel});

  final TkModel tkModel;

  @override
  State<TkDetailsScreen> createState() => _TkDetailsScreenState();
}

class _TkDetailsScreenState extends State<TkDetailsScreen> {
  Widget getMap(TkModel model) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150.0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(),
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: LatLng(model.lat!, model.lon!),
                initialZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [getMarker(model)],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getMarker(TkModel item) {
    return Marker(
      point: LatLng(item.lat!, item.lon!),
      width: 50,
      height: 50,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    String photoTime = '';
    DateFormat dateFormat = DateFormat('dd-mm-yyyy HH:mm:ss');

    //09-09-2009 14:09:20

    if (widget.tkModel.date != null) {
      DateTime dateTime = dateFormat.parse(widget.tkModel.date!);
      photoTime = DateFormat('dd/mm/yyyy hh:mm a').format(dateTime);
    }

    //Reported by date
    var report_date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.tkModel.timestamp.toString()) * 1000);
    var output_date = DateFormat('MM/dd/yyyy').format(report_date);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
          foregroundColor: Colors.white,
          title: const Text('TK Indicator Details'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            getMap(widget.tkModel),
            SizedBox(
              height: 10.0,
            ),
            Image.network(
              widget.tkModel.image!,
              height: 250.0,
              fit: BoxFit.contain,
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${widget.tkModel.title}'),
                  Text('Photo Time: $photoTime'),
                  Text(
                    'Indicator: ${widget.tkModel.indicator!.name}',
                    softWrap: true,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    color: const Color.fromARGB(255, 150, 150, 150),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text('Reported by'),
                      SizedBox(
                        width: 10.0,
                      ),
                      Image.network(
                        widget.tkModel.author_photo!,
                        width: 40.0,
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(widget.tkModel.author_name!),
                      SizedBox(
                        width: 5.0,
                      ),
                    ],
                  ),
                  Text('on $output_date'),
                ],
              ),
            ),
          ]),
        ));
  }
}
