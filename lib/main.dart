import 'Utils/global_variables.dart';
import 'Utils/weather_data_utils.dart';

import 'elements/info_boxes.dart';
import 'elements/graph_with_dropdown.dart';

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
          isLoaded = false;
        } else {
          weatherDataJson = value;
          isLoaded = true;
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

            // Refresh Button
            // TODO move to its own element class
            // NOTE: we need to find a new solution to reset state,
            // as refresh button will not be in the same class
            TextButton(
                onPressed: () {
                  // Reset to defaults, and set state to show loading
                  isLoaded = false;
                  weatherDataJson = [];
                  setState(() {});

                  loadWeatherData().then((value) {
                    setState(() {
                      if (value.isEmpty) {
                        isLoaded = false;
                      } else {
                        weatherDataJson = value;
                        isLoaded = true;
                      }
                    });
                  });
                },
                child: const Text('Refresh ⟳'))
          ],
        )
    );
  }
}

void setScreenSize(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  displayHeight = size.height;
  displayWidth = size.width;
}
