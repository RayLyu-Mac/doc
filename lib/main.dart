import 'dart:async';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:doc/main_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'hive/file_class.dart';

void main() async {
  final appDocumentDir = Directory.current;
  print(appDocumentDir);
  Hive.init(appDocumentDir.path + "/data");
  Hive.registerAdapter(monitoringdocAdapter());
  Hive.registerAdapter(rdAdapter());
  runApp(MyApp());
}

Future openBox() async {
  await Hive.openBox('monitor_name');
  await Hive.openBox("risk_name");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Tutorial',
      home: FutureBuilder(
        future: openBox(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return HomePage();
          }
          // Although opening a Box takes a very short time,
          // we still need to return something before the Future completes.
          else
            return Scaffold();
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
  }
}
