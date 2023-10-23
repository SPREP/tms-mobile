import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:macres/util/dark_theme_preference.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class BigMapWidget extends StatefulWidget {
  const BigMapWidget({super.key, required this.eventModel});

  final eventModel;

  @override
  State<BigMapWidget> createState() => _BigMapWidgetState();
}

class _BigMapWidgetState extends State<BigMapWidget> {
  DarkThemePreference darkTheme = new DarkThemePreference();

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
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        center: LatLng(widget.eventModel.lat, widget.eventModel.lon),
        zoom: 6,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          animationConfig: const ScaleRAWA(),
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
        Positioned(
          right: 10,
          bottom: 60,
          child: FloatingActionButton(
              tooltip: 'Close',
              child: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      ],
      children: [
        TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app'),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(widget.eventModel.lat, widget.eventModel.lon),
              width: 50,
              height: 50,
              builder: (context) => getCentre(),
            ),
          ],
        ),
      ],
    );
  }
}
