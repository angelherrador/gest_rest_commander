//import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:gest_rest/screens/waiters_page.dart';
import 'onboarding_page.dart';
//import 'package:lottie/lottie.dart';
//import 'package:page_transition/page_transition.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  final bool showHome;
  const SplashScreen({super.key, required this.showHome});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 5),(){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget.showHome ? const WaiterPage() : const OnBoardingPage(),
          ));
    });

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.network(
          'https://herradormartinez.es/gestrest/images/logos/splash_logo.riv',
          //animations: ['blink','5+'],
          //artBoard(''),
        ),
      ),
    );
  }
}




//   Widget build(BuildContext context) {
//     return AnimatedSplashScreen(
//         splash: Lottie.asset('assets/NikeSplashScreen.json'),
//         //splash: Lottie.asset('assets/DinnerResto.json'),
//         splashIconSize: 250,
//         backgroundColor: widget.showHome ? Colors.black: Colors.green,
//         pageTransitionType: PageTransitionType.fade,
//         nextScreen: widget.showHome ? const FamilyPage() : const OnBoardingPage());
//   }
// }

// @override
// Widget build(BuildContext context) {
//   return const Scaffold(
//     body: Center(
//       child: RiveAnimation.network(
//         'https://herradormartinez.es/gestrest/logos/splash_logo.riv',
//         //animations: ['blink','5+'],
//         //artBoard(''),
//       ),
//     ),
//   );
// }