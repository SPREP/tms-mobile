import 'package:flutter/material.dart';
import 'package:macres/models/warning_model.dart';
import 'package:macres/screens/warning_details_screen.dart';

class WarningWidget extends StatelessWidget {
  const WarningWidget({super.key, required this.warning});
  final WarningModel warning;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width * 0.8;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 222, 223, 223)),
        color: Colors.white,
      ),
      margin: EdgeInsets.all(3.0),
      child: InkWell(
        child: Row(
          children: [
            Container(
              color: warning.getColor(),
              height: 150.0,
              width: 42.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    warning.getIcon(),
                    Text(
                      warning.getLevelText(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 8),
                    )
                  ]),
              padding: EdgeInsets.only(left: 3.0, right: 3.0),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: mWidth,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      warning.title.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform(
                        transform: new Matrix4.identity()..scale(0.8),
                        child: Chip(
                          avatar: Icon(Icons.lock_clock),
                          backgroundColor: Color.fromARGB(255, 234, 233, 233),
                          label: Text(
                            warning.date.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Transform(
                        transform: new Matrix4.identity()..scale(0.8),
                        child: new Chip(
                          avatar: Icon(Icons.calendar_today),
                          padding: EdgeInsets.all(2.0),
                          backgroundColor: Color.fromARGB(255, 234, 233, 233),
                          label: Text(
                            warning.time.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
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
              builder: (context) => WarningDetailsScreen(
                warningModel: warning,
              ),
            ),
          );
        },
      ),
    );
  }
}
