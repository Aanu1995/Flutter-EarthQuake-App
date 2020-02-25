import 'dart:async';
import 'package:connectivity/connectivity.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();
  ConnectivityService() {
    try {
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        connectionStatusController.add(_getStatusFromResult(result));
      });
    } catch (e) {}
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
