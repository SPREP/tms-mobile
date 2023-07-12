import 'package:flutter/material.dart';
import 'package:macres/screens/onboarding/onboarding_first_screen.dart';
import 'package:macres/screens/onboarding/onboarding_second_screen.dart';
import 'package:macres/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String _selectedLocation = 'Select your location';
  String _selectedLanguage = 'English';
  final _userLocationKey = GlobalKey<FormState>();

  bool isError = false;

  void _selectedUserLocation(String value) {
    _selectedLocation = value;
  }

  void _selectedUserLanguage(String value) {
    _selectedLanguage = value;
  }

  void _submissionCallback() async {
    if (!isLastPage) {
      final validationStatus =
          _userLocationKey.currentState?.validate() ?? false;

      if (!validationStatus) {
        isError = true;
      } else {
        isError = false;

        //save values
        final prefs = await SharedPreferences.getInstance();

        prefs.setString('user_location', _selectedLocation);
        prefs.setString('user_language', _selectedLanguage);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void turnOnboardingOff() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showOnboarding', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 1;
              index = 0;
            });
          },
          //physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            OnboardingFirstScreen(
              validateLocation: _selectedUserLocation,
              userLocationKey: _userLocationKey,
            ),
            const OnboardingSecondScreen(),
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
                backgroundColor: const Color.fromARGB(255, 110, 107, 99),
                minimumSize: const Size.fromHeight(80),
              ),
              child: Row(children: [
                Text(
                  AppLocalizations.of(context).onBoardingGetStartedButton,
                  style: const TextStyle(fontSize: 24),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ]),
              onPressed: () {
                turnOnboardingOff();
                //Navigate to home page
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const TabsScreen();
                }));
              },
            )
          : Container(
              color: const Color.fromARGB(255, 110, 107, 99),
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
                      effect: const WormEffect(
                        spacing: 16,
                        dotColor: Color.fromARGB(255, 181, 179, 179),
                        activeDotColor: Colors.white,
                      ),
                      onDotClicked: (index) {
                        _submissionCallback();
                        if (isError) return;
                        controller.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _submissionCallback();
                      if (isError) return;
                      controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context).onBoardingNextButton,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
    );
  }
}
