import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/models/tk_model.dart';

class TkDetailsScreen extends StatefulWidget {
  const TkDetailsScreen({super.key, required this.tkModel});

  final TkModel tkModel;

  @override
  State<TkDetailsScreen> createState() => _TkDetailsScreenState();
}

class _TkDetailsScreenState extends State<TkDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    String photoTime = '';
    DateFormat dateFormat = DateFormat('dd-mm-yyyy HH:mm:ss');

    //09-09-2009 14:09:20

    if (widget.tkModel.date != null) {
      DateTime dateTime = dateFormat.parse(widget.tkModel.date!);
      photoTime = DateFormat('dd/mm/yyyy hh:mm a').format(dateTime);
    }

    //Reported by date
    var report_date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.tkModel.timestamp.toString()) * 1000);
    var output_date = DateFormat('MM/dd/yyyy').format(report_date);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
          foregroundColor: Colors.white,
          title: const Text('TK Indicator Details'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Image.network(
              widget.tkModel.image!,
              height: 300.0,
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${widget.tkModel.title}'),
                  Text('Photo Time: $photoTime'),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    color: const Color.fromARGB(255, 150, 150, 150),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text('Reported by'),
                      SizedBox(
                        width: 10.0,
                      ),
                      Image.network(
                        widget.tkModel.author_photo!,
                        width: 40.0,
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(widget.tkModel.author_name!),
                      SizedBox(
                        width: 5.0,
                      ),
                    ],
                  ),
                  Text('on $output_date'),
                ],
              ),
            ),
          ]),
        ));
  }
}
