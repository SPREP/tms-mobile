import 'package:flutter/material.dart';
import 'package:macres/screens/weather_forcast/weather_forcast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() {
    return _OnboardingPageState();
  }
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 1;
            });
          },
          children: [
            Container(
              color: Colors.red,
              child: const Center(
                child: Text('Page 1'),
              ),
            ),
            Container(
              color: Colors.indigo,
              child: const Center(
                child: Text('Page 2'),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal.shade700,
                minimumSize: const Size.fromHeight(80),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showOnboarding', false);

                //Navigate to home page
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const WeatherForcast();
                }));
              },
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(''),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 2,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: Colors.teal.shade700,
                      ),
                      onDotClicked: (index) {
                        controller.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: const Text('NEXT'),
                  ),
                ],
              )),
    );
  }
}
