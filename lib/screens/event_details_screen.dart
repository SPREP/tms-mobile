import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:humanitarian_icons/humanitarian_icons.dart';
import 'package:macres/models/event_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:macres/screens/forms/feel_earthquake_form.dart';
import 'package:macres/screens/user/islogin_screen.dart';
import 'package:macres/widgets/big_map_widget.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final mapController = MapController();

  Widget getCentre() {
    return const RippleAnimation(
      color: Colors.red,
      delay: Duration(milliseconds: 300),
      repeat: true,
      minRadius: 20,
      ripplesCount: 3,
      duration: Duration(milliseconds: 6 * 300),
      child: ClipOval(
        child: Icon(
          Icons.circle,
          color: Colors.red,
          size: 10,
        ),
      ),
    );
  }

  void _openMapOverlay() {
    showModalBottomSheet(
      useSafeArea: false,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => BigMapWidget(eventModel: widget.eventModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: ClipOval(
          child: Container(
            color: Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(40),
                ),
                border: Border.all(
                  color: const Color.fromARGB(255, 148, 155, 167),
                ),
                color: const Color.fromARGB(255, 235, 235, 234),
              ),
              height: 300,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(),
                child: widget.eventModel.lat == 0
                    ? const Center(
                        child: Text(
                        'Map is not available',
                        style:
                            TextStyle(color: Color.fromARGB(255, 47, 47, 47)),
                      ))
                    : FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: LatLng(
                              widget.eventModel.lat, widget.eventModel.lon),
                          initialZoom: 6,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(widget.eventModel.lat,
                                    widget.eventModel.lon),
                                width: 50,
                                height: 50,
                                child: getCentre(),
                              ),
                            ],
                          ),
                          Stack(children: [
                            Positioned(
                              right: 10,
                              bottom: 60,
                              child: FloatingActionButton(
                                  tooltip: 'View large map',
                                  child: const Icon(
                                    Icons.center_focus_weak_sharp,
                                  ),
                                  onPressed: () {
                                    _openMapOverlay();
                                  }),
                            ),
                          ]),
                        ],
                      ),
              ),
            ),
            Container(
              height: 830,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Theme.of(context).primaryColor,
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.only(top: 250),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.eventModel
                          .getIcon(50, const Color.fromARGB(255, 84, 83, 84)),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "${eventTypeLabel[widget.eventModel.type]} ${widget.eventModel.name}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      roundContent(
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          Text(widget.eventModel.date.toString()),
                          Colors.blue),
                      roundContent(
                          const Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                          Text(widget.eventModel.time.toString()),
                          const Color.fromARGB(255, 124, 169, 40)),
                      if (widget.eventModel.type == EventType.cyclone)
                        roundContent(
                          const Icon(
                            Icons.wind_power,
                            color: Colors.white,
                          ),
                          Text("Cat. ${widget.eventModel.category.toString()}"),
                          Colors.green,
                        ),
                      if (widget.eventModel.type == EventType.earthquake)
                        roundContent(
                          const Icon(
                            HumanitarianIcons.earthquake,
                            color: Colors.white,
                          ),
                          Text("${widget.eventModel.magnitude.toString()} Mag"),
                          Colors.orange,
                        ),
                    ],
                  ),
                  if (widget.eventModel.body != '' &&
                      widget.eventModel.body != null)
                    SizedBox(
                      height: 30.0,
                    ),
                  Flexible(
                    child: Text(
                      widget.eventModel.body.toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.eventModel.tsunami != null &&
                      widget.eventModel.tsunami != '')
                    styleLabel('Tsunami Warning',
                        widget.eventModel.tsunami.toString()),
                  if (widget.eventModel.type == EventType.earthquake &&
                      widget.eventModel.feel != null)
                    Column(
                      children: [
                        Text(
                          'Reported from Community',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Click on the button below [Did you feel it?] to report to us.',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          width: 300.0,
                          height: 200.0,
                          child: getBarChart(),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tt - Tongatapu'),
                              Text('Vv - Vavau'),
                              Text('Hp - Haapai'),
                              Text('Nfo - Niuafoou'),
                              Text('Ntt - Niuatoputapu'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 15),
                  if (widget.eventModel.type == EventType.cyclone)
                    // styleLabel('Affecting', "Tongatapu, Ha'apai, Vava'u, 'Eua"),
                    const SizedBox(height: 10),
                  if (widget.eventModel.type == EventType.earthquake)
                    SizedBox(
                      width: 300.0,
                      child: ElevatedButton.icon(
                          icon:
                              const Icon(HumanitarianIcons.affected_population),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeelEarthquakeForm(
                                      eventId: widget.eventModel.id)),
                            );
                          },
                          label: const Text('Did you feel it?')),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: 300.0,
                      child: ElevatedButton.icon(
                          icon: const Icon(Icons.draw),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new IsLogin(
                                    next: 'impact',
                                    eventId: widget.eventModel.id!),
                              ),
                            );
                          },
                          label: const Text('Create Impact Report'))),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: 300.0,
                      child: ElevatedButton.icon(
                          icon: const Icon(Icons.assistant),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new IsLogin(
                                    next: 'assistance',
                                    eventId: widget.eventModel.id!),
                              ),
                            );
                          },
                          label: const Text('Request Assistance'))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBarChart() {
    //find out the highest value
    double max = 0;

    List<int> item = [
      widget.eventModel.feel!.tongatapu ?? 0,
      widget.eventModel.feel!.vavau ?? 0,
      widget.eventModel.feel!.eua ?? 0,
      widget.eventModel.feel!.haapai ?? 0,
      widget.eventModel.feel!.niuafoou ?? 0,
      widget.eventModel.feel!.niuatoputapu ?? 0
    ];

    item.forEach((value) {
      if (value > max) max = double.parse(value.toString());
    });

    return BarChart(BarChartData(
      barTouchData: barTouchData,
      titlesData: titlesData,
      borderData: borderData,
      barGroups: barGroups,
      gridData: const FlGridData(show: false),
      alignment: BarChartAlignment.spaceAround,
      maxY: max + 1, // add 1 for space
    ));
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Tt';
        break;
      case 1:
        text = 'Hp';
        break;
      case 2:
        text = 'Vv';
        break;
      case 3:
        text = 'Ntt';
        break;
      case 4:
        text = 'Nfo';
        break;
      case 5:
        text = 'Eua';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.blue,
          Colors.red,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: widget.eventModel.feel!.tongatapu != null
                  ? double.parse(widget.eventModel.feel!.tongatapu.toString())
                  : 0,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: widget.eventModel.feel!.haapai != null
                  ? double.parse(widget.eventModel.feel!.haapai.toString())
                  : 0,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: widget.eventModel.feel!.vavau != null
                  ? double.parse(widget.eventModel.feel!.vavau.toString())
                  : 0,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: widget.eventModel.feel!.niuatoputapu != null
                  ? double.parse(
                      widget.eventModel.feel!.niuatoputapu.toString())
                  : 0,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: widget.eventModel.feel!.niuafoou != null
                  ? double.parse(widget.eventModel.feel!.niuafoou.toString())
                  : 0,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: widget.eventModel.feel!.eua != null
                  ? double.parse(widget.eventModel.feel!.eua.toString())
                  : 0,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  Widget styleLabel(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue,
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color.fromARGB(255, 170, 236, 178),
          child: Flexible(
            child: Text(
              value,
              style: const TextStyle(
                  color: Color.fromARGB(255, 104, 103, 103),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget roundContent(Icon theIcon, Text theLabel, Color theColor) {
    return ClipOval(
      child: DefaultTextStyle.merge(
        child: Container(
          width: 95,
          height: 95,
          color: theColor,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              theIcon,
              const SizedBox(
                height: 5,
              ),
              theLabel,
            ],
          ),
        ),
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
