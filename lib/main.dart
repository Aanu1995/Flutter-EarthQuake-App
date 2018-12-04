import 'package:flutter/material.dart';
import 'package:flutter_earthquake/my_home.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "EarthQuake",
        theme: ThemeData(
            primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHome());
  }
}
