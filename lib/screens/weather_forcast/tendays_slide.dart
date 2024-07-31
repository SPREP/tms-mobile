import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TenDaysSlide extends StatefulWidget {
  const TenDaysSlide({super.key, required this.currentData});

  final currentData;

  @override
  State<TenDaysSlide> createState() => _TenDaysSlideState();
}

class _TenDaysSlideState extends State<TenDaysSlide> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Spacer(),
            Text(localizations.tenDaysTitle),
            Spacer(),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        for (final item in widget.currentData)
          Container(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color.fromARGB(255, 220, 218, 218)),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.getDay(context),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      item.getIconDefinition(context),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Spacer(),
                new Center(
                    child: Container(
                  height: 30.0,
                  width: 30.0,
                  child: item.getIcon(),
                )),
                SizedBox(
                  width: 30.0,
                ),
                Column(
                  children: [
                    Text('${item.maxTemp}\u00B0',
                        style: TextStyle(fontSize: 14.0, color: Colors.white)),
                    Text('${item.minTemp}\u00B0',
                        style: TextStyle(fontSize: 14.0, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
