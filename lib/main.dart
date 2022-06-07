import 'Utils/global_variables.dart';
import 'Utils/weather_data_utils.dart';

import 'elements/info_boxes.dart';
import 'elements/graph_with_dropdown.dart';
import 'elements/bottom_buttons.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void fetchWeatherData() {
    loadWeatherData().then((value) {
      setState(() {
        if (value.isEmpty) {
          currLoadState.value = LoadState.error;
        } else {
          weatherDataJson = value;
          currLoadState.value = LoadState.loaded;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    //final double width = MediaQuery.of(context).size;
    return MaterialApp(
      home: Home(),
      title: "Greenhouse Weather",
    );
  }
}

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State {
  @override
  Widget build(BuildContext context) {
    setScreenSize(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Greenhouse Weather"),
        ),
        body: Column(
          children: <Widget>[
            //InfoBoxes
            SizedBox(height: displayWidth * .03),
            const InfoBoxes(),
            SizedBox(height: displayHeight * .05),

            // Graph
            const GraphWithDropdowns(),

            const RefreshButton(),

          ],
        ));
  }
}

void setScreenSize(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  displayHeight = size.height;
  displayWidth = size.width;
}
