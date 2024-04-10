import 'package:flutter/material.dart';

class EvacuationMapLegend extends StatefulWidget {
  const EvacuationMapLegend({super.key});

  @override
  State<EvacuationMapLegend> createState() => _EvacuationMapLegendState();
}

class _EvacuationMapLegendState extends State<EvacuationMapLegend>
    with SingleTickerProviderStateMixin {
  bool pos = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    reverseDuration: Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.7),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SlideTransition(
        position: _offsetAnimation,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: [
            TextButton(
              onPressed: () {
                pos == false
                    ? _controller.animateTo(15.0,
                        duration: Duration(seconds: 2))
                    : _controller.reverse();
                pos = !pos;
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(
                    top: 5.0, left: 5.0, bottom: 5.0, right: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    color: Theme.of(context).appBarTheme.backgroundColor),
                child: Row(children: [
                  Icon(
                    pos ? Icons.expand_more : Icons.expand_less,
                    color: Colors.white,
                  ),
                  Text(
                    'Map Legend',
                    style: TextStyle(color: Colors.white),
                  ),
                ]),
              ),
            ),
            Container(
              height: 300,
              width: 250,
              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                    color: Theme.of(context).appBarTheme.backgroundColor!),
              ),
              child: Column(
                children: [
                  Row(children: [
                    Icon(
                      Icons.location_pin,
                      color: Color.fromARGB(255, 6, 124, 45),
                      size: 30.0,
                    ),
                    Flexible(child: Text('TSunami evacuation safe zone.'))
                  ]),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(children: [
                    Icon(
                      Icons.circle,
                      color: Color.fromARGB(255, 223, 110, 34),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                        child:
                            Text('Multiple safe zone, zoom in to view more.'))
                  ]),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(children: [
                    Icon(Icons.near_me),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                        child: Text(
                            'Tap this button, to show your nearest TSunami safe zone.'))
                  ]),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(children: [
                    Icon(
                      Icons.circle,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('Your current location.')
                  ]),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
