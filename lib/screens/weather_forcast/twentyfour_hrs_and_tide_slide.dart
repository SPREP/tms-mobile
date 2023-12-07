import 'package:flutter/material.dart';
import 'package:macres/screens/weather_forcast/tide_slide.dart';
import 'package:macres/screens/weather_forcast/twentyfour_hrs_slide%20copy.dart';

class TwentyFourHoursAndTideSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TwentyFourHoursSlide(),
        TideSlide(),
      ],
    );
  }
}
