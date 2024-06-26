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
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Color.fromARGB(255, 222, 223, 223)),
      ),
      margin: EdgeInsets.only(bottom: 10.0),
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
            ),
            Container(
              padding: EdgeInsets.all(8),
              width: mWidth,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      warning.title.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform(
                        transform: new Matrix4.identity()..scale(0.8),
                        child: Chip(
                          avatar: Icon(Icons.lock_clock),
                          label: Text(
                            warning.date.toString(),
                          ),
                        ),
                      ),
                      Transform(
                        transform: new Matrix4.identity()..scale(0.8),
                        child: new Chip(
                          avatar: Icon(Icons.calendar_today),
                          label: Text(
                            warning.time.toString(),
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
