import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RadarSlide extends StatefulWidget {
  const RadarSlide({super.key, required this.data});

  final data;

  @override
  State<RadarSlide> createState() => _RadarSlideState();
}

class _RadarSlideState extends State<RadarSlide> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(children: [
      Row(
        children: [
          SizedBox(
            width: 30,
          ),
          Spacer(),
          Text(
              //localizations.threeHoursTitle,
              'Radar Images'),
          Spacer(),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      const SizedBox(
        height: 40,
      ),
    ]);
  }
}
