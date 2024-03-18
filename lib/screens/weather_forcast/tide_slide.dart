import 'package:flutter/material.dart';
import 'package:macres/models/tide_model.dart';
import 'package:weather_icons/weather_icons.dart';

class TideSlide extends StatefulWidget {
  const TideSlide({super.key, required this.seaData, required this.tideData});

  final seaData;
  final tideData;

  @override
  State<TideSlide> createState() => _TideSlideState();
}

class _TideSlideState extends State<TideSlide> {
  @override
  Widget build(BuildContext context) {
    TideModel high = TideModel();
    TideModel low = TideModel();

    //Use for label if the time is in tomorrow
    String high_tomorrow_morning = 'today';
    String low_tomorrow_morning = 'today';

    for (TideModel item in widget.tideData) {
      //compare current time to the time we got from API
      DateTime dt1 = DateTime.parse(item.date!);
      DateTime dt2 = DateTime.now();

      if ((dt1.compareTo(dt2) > 0) &&
          item.status?.toLowerCase() == 'high' &&
          high.id == null) {
        high = item;
        if (!DateUtils.isSameDay(dt1, dt2)) {
          high_tomorrow_morning = 'tomorrow morning';
        }
        continue;
      }
      if ((dt1.compareTo(dt2) > 0) &&
          item.status?.toLowerCase() == 'low' &&
          low.id == null) {
        low = item;
        if (!DateUtils.isSameDay(dt1, dt2)) {
          low_tomorrow_morning = 'tomorrow morning';
        }
        continue;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Spacer(),
              Text('TIDE INFORMATION'),
              Spacer(),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          if (high.id != null)
            Row(children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Text(
                    'Next HIGH TIDE of ${high.level} is at ${high.time} ${high_tomorrow_morning}.'),
              ),
            ]),
          const SizedBox(height: 20.0),
          if (low.id != null)
            Row(
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: Text(
                      'Next LOW TIDE of ${low.level} is at ${low.time} ${low_tomorrow_morning}.'),
                ),
              ],
            ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Spacer(),
              Text('SEA INFORMATION'),
              Spacer(),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              children: [],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    WeatherIcons.thermometer,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Sea temperature '),
                  Spacer(),
                  Text('${widget.seaData.temp.toString()} degC'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.timeline,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Sea level '),
                  Spacer(),
                  Text('${widget.seaData.level.toString()} mm'),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Spacer(),
                  Text(
                    'Current condition at ${widget.seaData.getObservedTime()}',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 192, 190, 190),
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
