import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/custom_drawer.dart';
import 'package:flutter/services.dart';

import '../providers/global_translations_provider.dart';

class MyHomePage extends StatefulWidget {
  static const String routeName = "/homepage";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _data = '';
  bool _scanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translations.text('pageNames.home')),
      ),
      drawer: CustomDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Text(_data)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("ciao"),
            ),
          )
        ],
      ),
    );
  }
}
