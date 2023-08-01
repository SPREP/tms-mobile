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
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        Text(widget.eventModel.date.toString()),
                        Colors.blue),
                    const Spacer(),
                    roundContent(
                        const Icon(
                          Icons.lock_clock,
                          color: Colors.white,
                        ),
                        Text(widget.eventModel.time.toString()),
                        Color.fromARGB(255, 124, 169, 40)),
                    const Spacer(),
                    roundContent(
                      const Icon(
                        Icons.wind_power,
                        color: Colors.white,
                      ),
                      Text("${widget.eventModel.category.toString()} Cat..."),
                      Colors.green,
                    ),
                    const Spacer(),
                    roundContent(
                        const Icon(
                          Icons.deck,
                          color: Colors.white,
                        ),
                        Text("${widget.eventModel.km.toString()} KM"),
                        Colors.orange),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                styleLabel(Text('Tsunami Warning'), Text('value')),
                SizedBox(height: 15),
                styleLabel(Text('Felt'), Text('value')),
                SizedBox(height: 15),
                styleLabel(Text('Affecting'), Text('value')),
                const SizedBox(
                  height: 50,
                ),
                Text('Create Impact Report'),
                const SizedBox(
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

  Widget styleLabel(Text label, Text value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue,
          child: const Text(
            'label',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.amber,
          child: const Text(
            'label',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget roundContent(Icon theIcon, Text theLabel, Color theColor) {
    return ClipOval(
      child: DefaultTextStyle.merge(
        child: Container(
          width: 82,
          height: 82,
          color: theColor,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              theIcon,
              const SizedBox(
                height: 5,
              ),
              theLabel,
            ],
          ),
        ),
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
