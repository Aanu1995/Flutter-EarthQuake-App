import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ApiData extends Equatable {
  final List<EarthQuake> earthQuake;

  ApiData({this.earthQuake});

  factory ApiData.fromJson(Map<String, dynamic> map) {
    List feature = map["features"];
    List<EarthQuake> list = [];
    feature.forEach((result) {
      var properties = result["properties"];
      var magnitude =
          properties["mag"] == null ? "0.0" : properties["mag"].toString();
      var color = magnitudeColor(magnitude);
      var place =
          properties["place"] != null ? properties["place"].toString() : "";
      var time =
          properties["time"] != null ? properties["time"].toString() : "";
      list.add(EarthQuake(magnitude, place, time, color));
    });
    return ApiData(earthQuake: list);
  }

  static Color magnitudeColor(var value) {
    var mag = double.parse(value);
    if (mag >= 4.5) {
      return Colors.red;
    }
    return Colors.blue;
  }

  @override
  List<Object> get props => [earthQuake];
}

class EarthQuake extends Equatable {
  final String magnitude;
  final String place;
  final String time;
  final MaterialColor color;

  EarthQuake(this.magnitude, this.place, this.time, this.color);

  @override
  List<Object> get props => [magnitude, place, time, color];
}
