import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:macres/models/warning_model.dart';
import 'package:macres/util/magnifier.dart' as Mag;

enum TtsState { playing, stopped, paused, continued }

class WarningDetailsScreen extends StatefulWidget {
  const WarningDetailsScreen({super.key, required this.warningModel});

  final WarningModel warningModel;

  @override
  State<WarningDetailsScreen> createState() => _WarningDetailsScreenState();
}

class _WarningDetailsScreenState extends State<WarningDetailsScreen> {
  late FlutterTts flutterTts;
  bool visibility = false;

  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;

  late String textOut;

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() async {
    flutterTts = FlutterTts();

    await flutterTts.setSharedInstance(true);
    await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback,
        [], IosTextToSpeechAudioMode.defaultMode);

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.setLanguage('to');

    var result = await flutterTts.speak(textOut);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  Widget build(BuildContext context) {
    textOut =
        '${widget.warningModel.title.toString()},${widget.warningModel.body.toString()}'
            .toLowerCase();

    return Mag.Magnifier(
      size: Size(250.0, 250.0),
      enabled: visibility ? true : false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Warning Details'),
          backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          actions: [
            IconButton(
              icon: isPlaying
                  ? const Icon(Icons.pause_circle_filled)
                  : isPaused
                      ? const Icon(Icons.play_circle_outline)
                      : isStopped
                          ? const Icon(Icons.play_circle_outline)
                          : const Icon(Icons.pause_circle_filled),
              iconSize: 35,
              onPressed: () => isPlaying
                  ? _pause()
                  : isPaused
                      ? _speak()
                      : isStopped
                          ? _speak()
                          : _pause(),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  visibility = !visibility;
                });
              },
              child: Icon(
                visibility ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.warning,
                          color: widget.warningModel.getColor(),
                          size: 40.0,
                        ),
                      ),
                      Flexible(
                          child: Text(widget.warningModel.title.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Chip(
                        padding: EdgeInsets.all(2.0),
                        backgroundColor: widget.warningModel.getColor(),
                        label: Text(
                          widget.warningModel.getLevelText(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Chip(
                        avatar: Icon(Icons.calendar_today),
                        padding: EdgeInsets.all(2.0),
                        backgroundColor: Color.fromARGB(255, 234, 233, 233),
                        label: Text(
                          widget.warningModel.time.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Chip(
                        avatar: Icon(Icons.lock_clock),
                        padding: EdgeInsets.all(2.0),
                        backgroundColor: Color.fromARGB(255, 234, 233, 233),
                        label: Text(
                          widget.warningModel.date.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(widget.warningModel.body.toString()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
