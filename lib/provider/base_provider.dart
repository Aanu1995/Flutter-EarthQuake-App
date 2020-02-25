import 'package:flutter/material.dart';
import 'package:flutter_earthquake/streams/connectivity_service.dart';
import 'package:provider/provider.dart';

class BaseProvider extends StatelessWidget {
  final Widget child;
  const BaseProvider({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityStatus>(
          initialData: ConnectivityStatus.Cellular,
          create: (_) =>
              ConnectivityService().connectionStatusController.stream,
        ),
      ],
      child: child,
    );
  }
}
