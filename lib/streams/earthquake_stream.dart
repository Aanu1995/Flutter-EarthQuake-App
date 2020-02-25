import 'dart:async';

import 'package:flutter_earthquake/model/earthquake.dart';
import 'package:flutter_earthquake/service/api_service.dart';

class EarthQuakeStream {
  StreamController earthQuakeStream = StreamController();

  fetchData() async {
    try {
      List<EarthQuake> data = await ApiService.getEarthQuakeData();
      earthQuakeStream.add(data);
    } catch (e) {
      print(e);
    }
  }

  dispose() {
    earthQuakeStream.close();
  }
}
