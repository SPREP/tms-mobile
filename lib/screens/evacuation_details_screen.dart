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
      ),
      body: Column(
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
            child: Image.network(widget.model.image_large!),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              MapsLauncher.launchCoordinates(
                  widget.model.lat!, widget.model.lon!);
            },
            child: Text('Get Direction'),
          )
        ],
      ),
    );
  }
}
