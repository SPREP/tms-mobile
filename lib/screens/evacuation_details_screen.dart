import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:macres/models/evacuation_model.dart';
import 'package:maps_launcher/maps_launcher.dart';

class EvacuationDetailsScreen extends StatefulWidget {
  EvacuationDetailsScreen({super.key, required this.model});
  final EvacuationModel model;

  @override
  State<EvacuationDetailsScreen> createState() =>
      _EvacuationDetailsScreenState();
}

class _EvacuationDetailsScreenState extends State<EvacuationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evacuation Details'),
        elevation: 0,
        backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.model.title!,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(20.0),
              maxScale: 5.1,
              child: CachedNetworkImage(
                imageUrl: widget.model.image_large!,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                onPressed: () {
                  MapsLauncher.launchCoordinates(
                      widget.model.lat!, widget.model.lon!);
                },
                label: const Text('Get Direction')),
          ],
        ),
      ),
    );
  }
}
