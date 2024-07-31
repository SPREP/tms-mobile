import 'package:flutter/material.dart';
import 'package:macres/models/event_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:macres/screens/event_details_screen.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key, required this.event});
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width * 0.7;
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 222, 223, 223)),
      ),
      margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: InkWell(
        child: Row(
          children: [
            Container(
              width: 50.0,
              height: 120.0,
              child: event.getIcon(
                  40.0,
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color.fromARGB(255, 86, 85, 85)),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: mWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.getLabel(context),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (event.name != null && event.name != "")
                    Text("${localizations.name}: ${event.name.toString()}"),
                  if (event.time != null)
                    Text("${localizations.time}: ${event.time.toString()}"),
                  if (event.date != null)
                    Text("${localizations.date}: ${event.date.toString()}"),
                  if (event.magnitude != null && event.magnitude != 0.0)
                    Text(
                        "${localizations.magnitude}: ${event.magnitude.toString()}"),
                  if (event.category != null && event.category != 0)
                    Text(
                        "${localizations.category}: ${event.category.toString()}"),
                  if (event.location != '')
                    Text(
                        "${localizations.location}: ${event.location.toString()}"),
                  if (event.evacuate != null)
                    Text("${localizations.evacuation}: ${event.evacuate}"),
                  if (event.km != null)
                    Text("${localizations.kilometer}: ${event.km.toString()}"),
                  if (event.depth != null)
                    Text("${localizations.depth}: ${event.depth.toString()}"),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(eventModel: event),
            ),
          );
        },
      ),
    );
  }
}
