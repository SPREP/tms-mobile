import 'package:flutter/material.dart';
import 'package:macres/screens/event_report_screen.dart';
import 'package:macres/screens/forms/feel_earthquake_form.dart';
import 'package:macres/screens/national_number_screen.dart';
import 'package:macres/screens/tk_front_screen.dart';
import 'package:macres/screens/tk_map_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                child: Container(
                  height: 8.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: options(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget options() {
    double width = MediaQuery.of(context).size.width;
    double boxWidth = 90;
    double fontSize = 12;
    double boxHeight = 80;

    if (width <= 300) {
      boxWidth = 100;
    }

    return SizedBox(
      child: Column(
        children: [
          const Text('Select a report you would like to submit to us.'),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventReportScreen(),
                    ),
                  );
                },
                child: Container(
                  height: boxHeight,
                  width: boxWidth,
                  child: Column(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                            color: Color.fromARGB(255, 209, 207, 207)),
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Event Report',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeelEarthquakeForm(eventId: 0),
                    ),
                  );
                },
                child: Container(
                  height: boxHeight,
                  width: 100.0,
                  child: Column(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                            color: Color.fromARGB(255, 209, 207, 207)),
                      ),
                      child: const Icon(
                        Icons.accessibility_new_outlined,
                        size: 30,
                        color: Color.fromARGB(255, 91, 91, 92),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Earthquake Felt',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          Divider(),
          const SizedBox(
            height: 1.0,
          ),
          const Text('Other places'),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NationalNumberScreen(),
                    ),
                  );
                },
                child: Container(
                  height: boxHeight,
                  width: 100,
                  child: Column(children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                            color: Color.fromARGB(255, 209, 207, 207)),
                      ),
                      child: const Icon(
                        Icons.phone,
                        size: 30,
                        color: Color.fromARGB(255, 170, 89, 23),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'National Number',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TkFrontScreen(),
                    ),
                  );
                },
                child: Container(
                  height: boxHeight,
                  width: 150.0,
                  child: Column(children: [
                    Container(
                      width: 150.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                            color: Color.fromARGB(255, 209, 207, 207)),
                      ),
                      child: ImageIcon(
                        AssetImage('assets/images/bird_icon.png'),
                        size: 10.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Traditional Knowledge',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
