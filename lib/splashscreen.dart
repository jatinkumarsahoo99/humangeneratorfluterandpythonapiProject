import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      title: const Text("Face Generator App",style: TextStyle( fontWeight: FontWeight.bold)),
      gradientBackground:const LinearGradient(begin: Alignment.topCenter, colors: [
        Color.fromRGBO(138, 35, 135, 1.0) ,Color.fromRGBO(255, 64, 87, 1.0),Color.fromRGBO(242, 133, 33, 1.0)
      ], end: Alignment.bottomCenter) ,

      loaderColor: Colors.white,
      navigateAfterSeconds: Home(),
    );
  }
}
