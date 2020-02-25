import 'package:flutter/material.dart';
import 'package:flutter_earthquake/my_home.dart';
import 'package:flutter_earthquake/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EarthQuake",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => MyHome(),
      },
      home: SplashScreen(),
    );
  }
}
