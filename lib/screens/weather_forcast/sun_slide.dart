import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macres/models/sun_model.dart';
import 'package:macres/models/tide_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather_icons/weather_icons.dart';

class SunSlide extends StatefulWidget {
  SunSlide({super.key, required this.sunData});

  final sunData;

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  State<SunSlide> createState() => _SunSlideState();
}

class _SunSlideState extends State<SunSlide> {
  List<double> xTitles = [];

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
      case 4:
        text = Text('4am', style: style);
        break;
      case 5:
        text = Text('5am', style: style);
        break;
      case 6:
        text = Text('6am', style: style);
        break;
      case 7:
        text = Text('7am', style: style);
        break;
      case 8:
        text = Text('8am', style: style);
        break;
      case 10:
        text = Text('10am', style: style);
        break;
      case 11:
        text = Text('11am', style: style);
        break;
      case 12:
        text = Text('12pm', style: style);
        break;
      case 13:
        text = Text('1pm', style: style);
        break;
      case 14:
        text = Text('2pm', style: style);
        break;
      case 15:
        text = Text('3pm', style: style);
        break;
      case 16:
        text = Text('4pm', style: style);
        break;
      case 18:
        text = Text('6pm', style: style);
        break;
      case 19:
        text = Text('7pm', style: style);
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
          showTitles: false,
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

  Widget getLineChart(double minx, double maxx) {
    //Calculate the sun position on the chart
    double maxy = 2.0;
    double miny = 0;

    double rangex = maxx - minx;
    double middlex = rangex / 2;
    double yunit = maxy / middlex;
    double middlexTime = double.parse((middlex + minx).toStringAsFixed(2));

    //get the current time
    var now = DateTime.now();
    String strNow = DateFormat('HH:mm').format(now);
    double currentTime = double.parse(strNow.replaceAll(':', '.'));

    return Stack(children: [
      AspectRatio(
        aspectRatio: 1.70,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 6,
          ),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(touchTooltipData:
                  LineTouchTooltipData(getTooltipItems: (value) {
                return value
                    .map(
                      (e) => LineTooltipItem(
                        DateFormat("hh:mma")
                            .format(DateFormat("HH.mm").parse(e.x.toString())),
                        TextStyle(fontSize: 14.0),
                      ),
                    )
                    .toList();
              })),
              minX: minx, // sunrise
              maxX: maxx, //sunset
              minY: miny,
              maxY: maxy,
              titlesData: getTitleData(),
              borderData: FlBorderData(
                  show: true,
                  border: Border(bottom: BorderSide(color: Colors.white))),
              extraLinesData: ExtraLinesData(
                verticalLines: getTimeLine(),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(minx, miny),
                    FlSpot(middlexTime, maxy),
                    FlSpot(maxx, miny)
                  ],
                  isCurved: false,
                  dotData: FlDotData(
                    show: false,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      color: Colors.white,
                      strokeWidth: 5,
                      strokeColor: Colors.white,
                    ),
                  ),
                ),
                LineChartBarData(
                  spots: getSunPos(minx, maxx, middlexTime, yunit),
                  isCurved: true,
                  dotData: FlDotData(
                    show: (currentTime >= minx && currentTime <= maxx)
                        ? true
                        : false,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 7,
                      color: Colors.yellow,
                      strokeWidth: 4,
                      strokeColor: Colors.grey,
                    ),
                  ),
                  belowBarData: BarAreaData(show: false),
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
    SunModel sunToday = SunModel();
    //SunModel sunTomorrow = SunModel();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    for (SunModel item in widget.sunData) {
      //compare current time to the time we got from API
      DateTime dt1 = DateTime.parse(item.date!);
      DateTime dt2 = DateTime.now();

      //if (dt2.isBefore(dt1) && !DateUtils.isSameDay(dt1, dt2)) {
      //  sunTomorrow = item;
      //}

      if (DateUtils.isSameDay(dt1, dt2)) {
        sunToday = item;
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
              Text(localizations.sunTitle),
              //Text('SUNRISE & SUNSET'),
              Spacer(),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20),
            child: Container(
              child: sunToday.rise != null
                  ? getLineChart(sunToday.convertTo24(sunToday.rise!),
                      sunToday.convertTo24(sunToday.set!))
                  : null,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(localizations.today.toUpperCase()),
          //Text('Today'),
          Row(
            children: [
              Icon(
                WeatherIcons.sunrise,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 10,
              ),
              Text(localizations.sunRise),
              //Text('Sunrise:'),
              SizedBox(
                width: 5,
              ),
              Text('${sunToday.rise}'),
              Spacer(),
              Icon(
                WeatherIcons.sunset,
                color: Colors.red,
              ),
              SizedBox(
                width: 6,
              ),
              Text(localizations.sunSet),
              //Text('Sunset:'),
              SizedBox(
                width: 5,
              ),
              Text('${sunToday.set}'),
            ],
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          /*
          Text('Tommorow'),
          Row(
            children: [
              Icon(
                WeatherIcons.sunrise,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Sunrise:'),
              SizedBox(
                width: 10,
              ),
              Text('${sunTomorrow.rise}'),
              Spacer(),
              Icon(
                WeatherIcons.sunset,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Sunset:'),
              SizedBox(
                width: 10,
              ),
              Text('${sunTomorrow.set}'),
            ],
          ),
          */
        ],
      ),
    );
  }

  getSunPos(double minx, double maxx, double middlexTime, double yunit) {
    var now = DateTime.now();
    String strNow = DateFormat('HH:mm').format(now);
    double xpoint = double.parse(strNow.replaceAll(':', '.'));

    //calculate the y-position of the sun
    double ypos = 0.0;

    if (xpoint > middlexTime) {
      ypos = (maxx - xpoint).abs() * yunit;
    } else {
      ypos = (minx - xpoint).abs() * yunit;
    }

    return [FlSpot(xpoint, ypos)];
  }
}
