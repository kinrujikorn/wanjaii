import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dating_app/screens/onboarding/onboarding_screens/create_screen.dart';
import 'package:flutter_dating_app/screens/onboarding/onbroading_screen.dart';
import 'package:flutter_dating_app/screens/screens.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SplashScreen(),
    );
  }
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            //builder: (_) => const Create(title: 'Homepage'),
            builder: (_) => Create(
                  title: '',
                )),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
              const Text(
                'WANJAI',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color.fromRGBO(187, 37, 74, 1),
                    fontSize: 36),
              )
            ],
          ),
        ),
      ),
    );
  }
}
