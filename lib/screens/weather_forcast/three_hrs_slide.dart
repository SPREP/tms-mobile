import 'package:flutter/material.dart';

class ThreeHoursSlide extends StatefulWidget {
  const ThreeHoursSlide({super.key, required this.currentData});

  final currentData;

  @override
  State<ThreeHoursSlide> createState() => _ThreeHoursSlideState();
}

class _ThreeHoursSlideState extends State<ThreeHoursSlide> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Spacer(),
            Text('3-HOURS FORECAST'),
            Spacer(),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "${widget.currentData.currentTemp}\u00B0",
            style: const TextStyle(fontSize: 30),
          ),
          const SizedBox(
            width: 40,
          ),
          Column(
            children: [
              Text(
                '${widget.currentData.caption}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              widget.currentData.getIcon(50.0, 50.0),
            ],
          ),
        ]),
        const SizedBox(
          height: 30,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.visibility_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      const Text('Visibility'),
                      Text('${widget.currentData.visibility} m'),
                    ]),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.explore,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(widget.currentData.windDirection.toString()),
                      Text('${widget.currentData.windSpeed.toString()} knts'),
                    ]),
              ),
            ]),
      ],
    );
  }
}
