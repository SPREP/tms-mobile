import 'package:flutter/material.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/models/settings_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  Widget getCentre() {
    return const RippleAnimation(
      color: Colors.red,
      delay: Duration(milliseconds: 300),
      repeat: true,
      minRadius: 20,
      ripplesCount: 3,
      duration: Duration(milliseconds: 6 * 300),
      child: ClipOval(
        child: Icon(
          Icons.circle,
          color: Colors.red,
          size: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: ClipOval(
          child: Container(
            color: Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(40),
              ),
              border: Border.all(
                color: const Color.fromARGB(255, 148, 155, 167),
              ),
            ),
            height: 300,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(),
              child: widget.eventModel.lat == 0
                  ? const Center(child: Text('Map is not available'))
                  : FlutterMap(
                      mapController: MapController(),
                      options: MapOptions(
                        center: LatLng(
                            widget.eventModel.lat, widget.eventModel.lon),
                        zoom: 6,
                      ),
                      children: [
                        FloatingActionButton(
                            child: const Icon(
                              Icons.add,
                              color: Colors.red,
                            ),
                            onPressed: () {}),
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                  widget.eventModel.lat, widget.eventModel.lon),
                              width: 50,
                              height: 50,
                              builder: (context) => getCentre(),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 250),
            child: Column(
              children: [
                Row(
                  children: [
                    roundContent(
                        const Icon(
                          Icons.abc,
                          color: Colors.white,
                        ),
                        const Text('hello'),
                        Colors.blue),
                    const Spacer(),
                    roundContent(
                        const Icon(
                          Icons.abc,
                          color: Colors.white,
                        ),
                        const Text('hello'),
                        Colors.red),
                    const Spacer(),
                    roundContent(
                      const Icon(
                        Icons.abc,
                        color: Colors.white,
                      ),
                      const Text('hello'),
                      Colors.green,
                    ),
                    const Spacer(),
                    roundContent(
                        const Icon(
                          Icons.abc,
                          color: Colors.white,
                        ),
                        const Text('hello'),
                        Colors.orange),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Text('Tsunami Warning'),
                Text('Felt'),
                Text('Affecting'),
                SizedBox(
                  height: 50,
                ),
                Text('Create Impact Report'),
                SizedBox(
                  height: 20,
                ),
                Text('Request Assistance'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget roundContent(Icon theIcon, Text theLabel, Color theColor) {
    return ClipOval(
      child: DefaultTextStyle.merge(
        child: Container(
          width: 80,
          height: 80,
          color: theColor,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              theIcon,
              theLabel,
            ],
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
