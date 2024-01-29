import 'package:flutter/material.dart';
import 'waiters_page.dart';
import 'onboarding_page.dart';
import 'package:rive/rive.dart';
import '../functions/functions.dart';


class SplashScreen extends StatefulWidget {
  final bool showHome;
  const SplashScreen({super.key, required this.showHome});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String vApiUrl ='$vApiUrlI/logos';

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
    return Scaffold(
      body: Center(
        child: RiveAnimation.network(
          '$vApiUrl/splash_logo.riv',
        ),
      ),
    );
  }
}