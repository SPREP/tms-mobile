import 'package:flutter/material.dart';
import 'package:macres/models/weather_model.dart';
import 'package:macres/providers/ten_days_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class TenDaysSlide extends StatefulWidget {
  const TenDaysSlide({super.key});

  @override
  State<TenDaysSlide> createState() => _TenDaysSlideState();
}

class _TenDaysSlideState extends State<TenDaysSlide> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TenDaysProvider>(
      builder: (context, tenDaysProvider, child) => SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Spacer(),
                Text('10-DAYS FORECAST'),
                Spacer(),
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            for (final item in tenDaysProvider.currentTenDaysData)
              ListTile(
                contentPadding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 30.0, right: 30.0),
                dense: true,
                leading: item.getIcon(20, Colors.white),
                title: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(item.day.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
                trailing: Text(
                  '${item.maxTemp}\u00B0/${item.minTemp}\u00B0',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                shape: const Border(
                  bottom: BorderSide(color: Colors.white70),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
