import 'package:flutter/material.dart';
import 'package:macres/screens/event_report_screen.dart';
import 'package:macres/screens/forms/feel_earthquake_form.dart';
import 'package:macres/screens/forms/impact_report_form.dart';
import 'package:macres/screens/forms/request_assistance_form.dart';
import 'package:macres/screens/user/islogin_screen.dart';

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
          color: const Color.fromARGB(255, 237, 235, 235),
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
                padding: const EdgeInsets.all(15.0),
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
    double boxWidth = 151;
    double fontSize = 15;

    if (width <= 300) {
      boxWidth = 100;
      fontSize = 10;
    }

    return SizedBox(
      child: Column(
        children: [
          const Text(
              'You can send us a report by choose from the options below.'),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EventReportScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromARGB(255, 122, 121, 121),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.trending_up_rounded,
                          size: 40,
                          color: Colors.blue,
                        ),
                        Text(
                          'Event Report',
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ]),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const FeelEarthquakeForm(eventId: 0),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromARGB(255, 122, 121, 121),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.accessibility_new_outlined,
                          size: 40,
                        ),
                        Text(
                          'Feel Earthquake',
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ]),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30.0,
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
                      builder: (context) => IsLogin(next: 'assitance'),
                      //const RequestAssistanceForm(eventId: 0),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromARGB(255, 122, 121, 121),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.donut_large_outlined,
                          size: 40,
                          color: Colors.orange,
                        ),
                        Text(
                          'Assistance Request',
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ]),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IsLogin(next: 'impact'),
                      //const ImpactReportForm(eventId: 0),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromARGB(255, 122, 121, 121),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_circle_up_outlined,
                          size: 40,
                          color: Colors.green,
                        ),
                        Text(
                          'Impact Report',
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ]),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
