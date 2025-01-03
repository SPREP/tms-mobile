import 'package:flutter/material.dart';

class WeatherProperty extends StatelessWidget {
  WeatherProperty(
      {super.key, this.title, this.value, this.unit, this.icon, this.bgColor});

  final String? title;
  final String? value;
  final String? unit;
  final Widget? icon;

  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      width: 100.0,
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: this.bgColor,
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
