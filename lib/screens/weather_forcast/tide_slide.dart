import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/models/tide_model.dart';
import 'package:weather_icons/weather_icons.dart';

class TideSlide extends StatefulWidget {
  TideSlide({super.key, required this.seaData, required this.tideData});

  final seaData;
  final tideData;

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  State<TideSlide> createState() => _TideSlideState();
}

class _TideSlideState extends State<TideSlide> {
  List<double> xTitles = [];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );
    String text;
    switch (value.toString()) {
      case '2.0':
        text = '2m';
        break;
      case '1.0':
        text = '1m';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );

    Widget text;

    switch (value.toInt()) {
      case 0:
        text = Text('12am', style: style);

        break;
      case 5:
        text = Text('5am', style: style);

        break;
      case 10:
        text = Text('10am', style: style);

        break;
      case 15:
        text = Text('3pm', style: style);

        break;
      case 20:
        text = Text('8pm', style: style);

        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  getTitleData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitlesWidget: leftTitleWidgets,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
    );
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();

    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  List<FlSpot> getPoints() {
    List<FlSpot> points = [];

    for (var item in widget.tideData) {
      //only process today data
      DateTime time = DateTime.parse(item.date);
      if (isToday(time)) {
        String timeOnly = DateFormat.Hm().format(time).replaceAll(':', '.');

        double x = double.parse(timeOnly);
        double y = double.parse(item.level.substring(0, 4));

        FlSpot spot = FlSpot(x, y);

        points.add(spot);
        xTitles.add(x);
      }
    }
    return points;
  }

  getTimeLine() {
    var now = DateTime.now();
    String strNow = DateFormat('HH:mm').format(now);
    double xpoint = double.parse(strNow.replaceAll(':', '.'));
    return [
      VerticalLine(
        x: xpoint,
        color: Colors.white,
        strokeWidth: 1,
        dashArray: [10, 5],
      ),
    ];
  }

  Widget getLineChart() {
    return Stack(children: [
      AspectRatio(
        aspectRatio: 1.70,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24,
            bottom: 12,
          ),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(touchTooltipData:
                  LineTouchTooltipData(getTooltipItems: (value) {
                return value
                    .map(
                      (e) => LineTooltipItem(
                        DateFormat("hh:mma").format(
                                DateFormat("HH.mm").parse(e.x.toString())) +
                            ' (${e.y}m)',
                        TextStyle(fontSize: 14.0),
                      ),
                    )
                    .toList();
              })),
              minX: 0,
              maxX: 24,
              minY: 0,
              maxY: 2,
              titlesData: getTitleData(),
              borderData: FlBorderData(
                  show: true, border: Border.all(color: Colors.white)),
              extraLinesData: ExtraLinesData(
                verticalLines: getTimeLine(),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: getPoints(),
                  isCurved: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      color: Colors.white,
                      strokeWidth: 1,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(show: true),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }

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
          high_tomorrow_morning = 'tomorrow';
        }
        continue;
      }
      if ((dt1.compareTo(dt2) > 0) &&
          item.status?.toLowerCase() == 'low' &&
          low.id == null) {
        low = item;
        if (!DateUtils.isSameDay(dt1, dt2)) {
          low_tomorrow_morning = 'tomorrow';
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
          Container(
            child: getLineChart(),
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
                  Text('${widget.seaData.temp.toString()} \u00B0C'),
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
                      color: Color.fromARGB(255, 219, 218, 218),
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
