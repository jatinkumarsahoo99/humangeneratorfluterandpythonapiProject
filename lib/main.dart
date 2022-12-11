import 'package:flutter/material.dart';
import 'package:humagenerator1/splashscreen.dart';


void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Human Generator',
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),

    );
  }
}
