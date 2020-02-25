import 'package:flutter_earthquake/model/earthquake.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class ApiService {
// gets data from API server
  static Future<List<EarthQuake>> getEarthQuakeData() async {
    final _url =
        "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
    try {
      http.Response _response = await http.get(_url);
      if (_response.statusCode == HttpStatus.ok) {
        var jsonData = json.decode(_response.body);
        final result = ApiData.fromJson(jsonData);
        return result.earthQuake;
      }
      return throw Exception();
    } catch (e) {
      return throw Exception();
    }
  }
}
