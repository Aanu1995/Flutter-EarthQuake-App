import 'package:flutter/material.dart';
import 'package:flutter_earthquake/components/functions.dart';
import 'package:flutter_earthquake/streams/earthquake_stream.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  EarthQuakeStream _earthQuakeStream = EarthQuakeStream();

  @override
  void initState() {
    super.initState();
    _earthQuakeStream.fetchData();
  }

  @override
  void dispose() {
    _earthQuakeStream.dispose();
    super.dispose();
  }

  Future<Null> _refresh() async {
    try {
      refreshKey.currentState?.show();
      await _earthQuakeStream.fetchData();
    } on Exception {
      print("Error 404");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Earth Quake Report"),
        elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
      ),
      body: new RefreshIndicator(
        key: refreshKey,
        child: Center(
          child: Container(
            child: StreamBuilder(
              stream: _earthQuakeStream.earthQuakeStream.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text("No Internet Connection\n\nCould not fetch Data",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
                } else if (snapshot.hasData) {
                  return _quakeUI(snapshot);
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
        onRefresh: () => _refresh(),
      ),
    );
  }

  Widget _quakeUI(AsyncSnapshot snapshot) {
    final textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: snapshot.data[index].color,
              foregroundColor: Colors.grey,
              radius: 20.0,
              child: Text(
                Functions.magValue(snapshot.data[index].magnitude.toString()),
                style: textTheme.subtitle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              Functions.polish(snapshot.data[index].place),
              style: textTheme.subtitle.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              Functions.secondValue,
              style: textTheme.subhead.copyWith(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(
              Functions.getTime(snapshot.data[index].time),
              style: textTheme.subtitle.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
