import 'package:flutter/material.dart';

class WeatherProperty extends StatelessWidget {
  WeatherProperty({super.key, this.title, this.value, this.unit, this.icon});

  final String? title;
  final String? value;
  final String? unit;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      height: 120.0,
      width: 100.0,
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          icon!,
          Flexible(
              child: Text(
            title!,
            softWrap: true,
            textAlign: TextAlign.center,
          )),
          Text('${value} ${unit}'),
        ],
      ),
    );
  }
}
