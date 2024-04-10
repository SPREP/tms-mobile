import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:macres/models/settings_model.dart';
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
  Language? _selectedLanguage = Language.en;

  final _userLocationKey = GlobalKey<FormState>();
  late FirebaseMessaging fcmInstance;

  bool isError = false;

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    fcmInstance = fcm;
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  void _selectedUserLocation(String value) {
    _selectedLocation = value;
  }

  void _selectedUserLanguage(Language value) {
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
        prefs.setString('user_language', _selectedLanguage!.name.toString());

        //Push notification subscribe user
        fcmInstance.subscribeToTopic('tonga'.toString());
        fcmInstance.subscribeToTopic(_selectedLanguage!.name.toString());
        fcmInstance.subscribeToTopic(_selectedLocation.toLowerCase());
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
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0),
      ),
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
              validateLanguage: _selectedUserLanguage,
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
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size.fromHeight(80),
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Spacer(),
                Text(
                  localizations.onBoardingGetStartedButton,
                  style: const TextStyle(fontSize: 24),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                const Spacer(),
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
              color: Theme.of(context).colorScheme.primary,
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
                          localizations.onBoardingNextButton,
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
