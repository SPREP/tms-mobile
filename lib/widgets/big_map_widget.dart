import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:macres/util/theme_preference.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class BigMapWidget extends StatefulWidget {
  const BigMapWidget({super.key, required this.eventModel});

  final eventModel;

  @override
  State<BigMapWidget> createState() => _BigMapWidgetState();
}

class _BigMapWidgetState extends State<BigMapWidget> {
  final mapController = MapController();

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

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(widget.eventModel.lat, widget.eventModel.lon),
        initialZoom: 6,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          tileBuilder: (Theme.of(context).brightness == Brightness.dark)
              ? _darkModeTileBuilder
              : null,
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(widget.eventModel.lat, widget.eventModel.lon),
              width: 50,
              height: 50,
              child: getCentre(),
            ),
          ],
        ),
        Stack(
          children: [
            Positioned(
              right: 10,
              bottom: 60,
              child: FloatingActionButton(
                  tooltip: 'Close',
                  child: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
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
      ],
    );
  }
}
