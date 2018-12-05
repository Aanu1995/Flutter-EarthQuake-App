import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity/connectivity.dart';

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<EarthQuake> _list = [];
  String secondValue;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectivity();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quake Report"),
          elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
        ),
        body: new RefreshIndicator(
          key: refreshKey,
          child: _body(),
          onRefresh: () => _refresh(),
        ));
  }

  void _connectivity(){
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();
          print(_connectionStatus);
          if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
            setState(() {

            });
          }
        });
  }

  Future<Null> _refresh() async {
   try{
     refreshKey.currentState?.show();
     setState(() {
       _list.clear();
       return _body();
     });
     await Future.delayed(Duration(seconds: 3));
   }on Exception{
     print("Error 404");
   }
    return null;
  }

  Widget _body() {
    return Center(
      child: Container(
        child: FutureBuilder(
            future: _getEarthQuake(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text("No Internet Connection\n\nCould not fetch Data",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize:30, fontWeight: FontWeight.bold));
              } else if (snapshot.hasData) {
                return _quakeUI(snapshot);
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }

  Widget _quakeUI(AsyncSnapshot snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: snapshot.data[index].color,
                  foregroundColor: Colors.grey,
                  child: Text(
                    _magValue(snapshot.data[index].magnitude.toString()),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                title: Text(_polish(snapshot.data[index].place),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(secondValue,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                trailing: Text(
                  _getTime(snapshot.data[index].time),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        });
  }

  String _polish(String snapshot) {
    String value = snapshot.toLowerCase();
    var correct = value.indexOf("of");
    String firstvalue = (snapshot.substring(0, (correct + 2))).toUpperCase();
    secondValue = snapshot.substring((correct + 3), value.length);
    return "$firstvalue";
  }

  String _getTime(String value) {
    int timestamp = int.parse(value);
    var milli = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var date = DateFormat.yMMMd("en_US").format(milli).toString();
    var time = new DateFormat.jm().format(milli).toString();
    return "$date \n $time";
  }

  String _magValue(String value) {
    String _correct;
    if (value.length > 3) {
      _correct = value.substring(0, 3);
    } else {
      _correct = value;
    }
    return _correct;
  }

  Future<List<EarthQuake>> _getEarthQuake() async {
    var _url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
    http.Response _response = await http.get(_url);
    if (_response.statusCode == HttpStatus.ok) {
      var _jsonData = json.decode(_response.body);
      var _feature = _jsonData["features"];
      MaterialColor _color = Colors.blue;

      for (var _result in _feature) {
        var properties = _result["properties"];

        if (double.parse((properties["mag"]).toString()) >= 4.5) {
          _color = Colors.red;
        } else {
          _color = Colors.blue;
        }

        EarthQuake _earthQuake = EarthQuake(
            (properties["mag"]).toString(),
            (properties["place"]).toString(),
            (properties["time"]).toString(),
            _color);
        _list.add(_earthQuake);
      }
    }
    return _list;
  }
}

class EarthQuake {
  String magnitude;
  String place;
  String time;
  MaterialColor color;

  EarthQuake(this.magnitude, this.place, this.time, this.color);
}
