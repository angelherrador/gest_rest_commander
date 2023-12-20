import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'onboarding_page.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  final bool showHome;
  const SplashScreen({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Lottie.asset('assets/NikeSplashScreen.json'),
        splashIconSize: 250,
        backgroundColor: showHome ? Colors.black: Colors.green,
        pageTransitionType: PageTransitionType.fade,
        nextScreen: showHome ? const HomePage() : const OnBoardingPage());
  }
}
