import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RadarSlide extends StatefulWidget {
  const RadarSlide({super.key, required this.data});

  final data;

  @override
  State<RadarSlide> createState() => _RadarSlideState();
}

class _RadarSlideState extends State<RadarSlide> {
  WebViewController _controller = WebViewController();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://app.rainradar.to/simple'));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(children: [
      Row(
        children: [
          SizedBox(
            width: 30,
          ),
          Spacer(),
          Text(
              //localizations.threeHoursTitle,
              'RADAR IMAGES'),
          Spacer(),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      SizedBox(
        height: 520,
        child: WebViewWidget(controller: _controller),
      )
    ]);
  }
}
