import 'package:flutter/material.dart';
import 'package:humanitarian_icons/humanitarian_icons.dart';
import 'package:macres/models/event_model.dart';
import 'package:macres/models/settings_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:macres/screens/forms/feel_earthquake_form.dart';
import 'package:macres/screens/forms/impact_report_form.dart';
import 'package:macres/screens/forms/request_assistance_form.dart';
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
              color: Color.fromARGB(255, 235, 235, 234),
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
                Text(
                  eventTypeLabel[widget.eventModel.type].toString() +
                      " " +
                      widget.eventModel.name.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    roundContent(
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        Text(widget.eventModel.date.toString()),
                        Colors.blue),
                    roundContent(
                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        Text(widget.eventModel.time.toString()),
                        Color.fromARGB(255, 124, 169, 40)),
                    if (widget.eventModel.type == EventType.cyclone)
                      roundContent(
                        const Icon(
                          Icons.wind_power,
                          color: Colors.white,
                        ),
                        Text(
                            "Cat. weve${widget.eventModel.category.toString()}"),
                        Colors.green,
                      ),
                    if (widget.eventModel.type == EventType.earthquake)
                      roundContent(
                        const Icon(
                          HumanitarianIcons.earthquake,
                          color: Colors.white,
                        ),
                        Text("${widget.eventModel.magnitude.toString()} Mag"),
                        Colors.orange,
                      ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                if (widget.eventModel.type == EventType.earthquake)
                  styleLabel('Tsunami Warning', 'NO'),
                const SizedBox(height: 15),
                if (widget.eventModel.type == EventType.earthquake)
                  styleLabel('Felt', "Tongatapu, Ha'apai, Vava'u, 'Eua"),
                const SizedBox(height: 15),
                if (widget.eventModel.type == EventType.cyclone)
                  styleLabel('Affecting', "Tongatapu, Ha'apai, Vava'u, 'Eua"),
                const SizedBox(height: 50),
                if (widget.eventModel.type == EventType.earthquake)
                  ElevatedButton.icon(
                      icon: Icon(HumanitarianIcons.affected_population),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeelEarthquakeForm()),
                        );
                      },
                      label: Text('Did you feel it?')),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    icon: Icon(Icons.draw),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImpactReportForm(
                                eventId: widget.eventModel.id)),
                      );
                    },
                    label: Text('Create Impact Report')),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    icon: Icon(Icons.assistant),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestAssistanceForm(
                                eventId: widget.eventModel.id)),
                      );
                    },
                    label: Text('Request Assistance')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget styleLabel(String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue,
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color.fromARGB(255, 170, 236, 178),
          child: Text(
            value,
            style: const TextStyle(
                color: Color.fromARGB(255, 104, 103, 103),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget roundContent(Icon theIcon, Text theLabel, Color theColor) {
    return ClipOval(
      child: DefaultTextStyle.merge(
        child: Container(
          width: 95,
          height: 95,
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
