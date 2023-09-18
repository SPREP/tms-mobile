import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:macres/models/notification_model.dart';

enum TtsState { playing, stopped, paused, continued }

class NotificationDetailsScreen extends StatefulWidget {
  const NotificationDetailsScreen({super.key, required this.notificationModel});

  final NotificationModel notificationModel;

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  late FlutterTts flutterTts;

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
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
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
        '${widget.notificationModel.title.toString()},${widget.notificationModel.body.toString()}'
            .toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: isPlaying
                  ? const Icon(Icons.pause_circle_filled)
                  : isPaused
                      ? const Icon(Icons.play_circle_outline)
                      : isStopped
                          ? const Icon(Icons.play_circle_outline)
                          : const Icon(Icons.pause_circle_filled),
              iconSize: 40,
              onPressed: () => isPlaying
                  ? _pause()
                  : isPaused
                      ? _speak()
                      : isStopped
                          ? _speak()
                          : _pause(),
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
                Text(widget.notificationModel.title.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Text(widget.notificationModel.body.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
