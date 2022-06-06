import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:greenhouse_weather_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

bool isLoaded = false;
var _weatherDataJson = [];

class Graph extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;
  final String graphMode;

  const Graph(this.seriesList,
      {required this.animate, required this.graphMode});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [
        charts.ChartTitle('time',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle(graphMode,
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
    );
  }
}

class GenericTimeSeries {
  final DateTime time;
  final int dataPoint;

  GenericTimeSeries(this.time, this.dataPoint);
}

class GraphWithDropdown extends StatefulWidget {
  @override
  _GraphWithDropdown createState() => _GraphWithDropdown();
}

class _GraphWithDropdown extends State {
  String selectedDate = "day";
  String selectedMode = "temperature";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(children: [
      DropdownButton(
        value: selectedMode,
        items: modeSelectorItems,
        onChanged: (String? newValue) {
          setState(() {
            selectedMode = newValue!;
            _createSampleData();
          });
        },
      ),
      SizedBox(
        height: size.height * .35, // Set size of graph here (35% of screen)
        child: Graph(
          _createSampleData(),
          animate: false,
          graphMode: selectedMode,
        ),
      ),
      DropdownButton(
        value: selectedDate,
        items: dateSelectorItems,
        onChanged: (String? newValue) {
          setState(() {
            selectedDate = newValue!;
            _createSampleData();
          });
        },
      ),
    ]);
  }

  List<charts.Series<GenericTimeSeries, DateTime>> _createSampleData() {
    final List<GenericTimeSeries> data = [];
    Duration duration = const Duration(days: 0);

    switch (selectedDate) {
      case "day":
        duration = const Duration(days: 1);
        break;
      case "week":
        duration = const Duration(days: 7);
        break;
      case "month":
        duration = const Duration(days: 28);
        break;
      case "year":
        duration = const Duration(days: 365);
        break;
    }

    for (var i = 0; i < _weatherDataJson.length; i++) {
      final today = DateTime.now();
      DateTime currDateTime = DateTime.parse(_weatherDataJson[i]['created_on']);

      if (today.subtract(duration).isBefore(currDateTime) ||
          duration.inDays == 0) {
        data.add(
            GenericTimeSeries(currDateTime, _weatherDataJson[i][selectedMode]));
      }
    }

    return [
      charts.Series<GenericTimeSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GenericTimeSeries weather, _) => weather.time,
        measureFn: (GenericTimeSeries weather, _) => weather.dataPoint,
        data: data,
      )
    ];
  }

  List<DropdownMenuItem<String>> get dateSelectorItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "day",
        child: Text("1 day"),
      ),
      const DropdownMenuItem(
        value: "week",
        child: Text("1 week"),
      ),
      const DropdownMenuItem(
        value: "month",
        child: Text("1 month"),
      ),
      const DropdownMenuItem(
        value: "year",
        child: Text("1 year"),
      ),
      const DropdownMenuItem(
        value: "all",
        child: Text("All time"),
      ),
    ];

    return menuItems;
  }

  List<DropdownMenuItem<String>> get modeSelectorItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "temperature",
        child: Text("temperature"),
      ),
      const DropdownMenuItem(
        value: "humidity",
        child: Text("humidity"),
      ),
    ];

    return menuItems;
  }
}

Future<List> loadWeatherData() async{
  const url = "https://greenhouse.russellpassmore.me";

  try {
    final weatherData = await get(Uri.parse(url));
    final jsonWeatherData = jsonDecode(weatherData.body) as Map;
    List<dynamic> data = jsonWeatherData["data"];

    print(data);

    return data;

  } catch (err) {
    print("Error: ${err}");
  }
  return [];
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void fetchWeatherData() {
    
    loadWeatherData().then((value) {
      setState(() {
        if(value.isEmpty) {
          isLoaded = false;
        }else{
          _weatherDataJson = value;
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Greenhouse Weather"),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: size.width * .03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoBox(
                    color: Colors.blue,
                    width: .85,
                    height: 90,
                    data: getInfo("temperature", "Temperature:", "°C")),
                InfoBox(
                    color: Colors.red,
                    width: .85,
                    height: 90,
                    data: getInfo("humidity", "Humidity:", "%"))
              ],
            ),
            SizedBox(height: size.width * .03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoBox(
                    color: Colors.green,
                    width: .5,
                    height: 90,
                    data: getInfo("created_on", "Recorded At:", ""))
              ],
            ),
            SizedBox(height: size.width * .05),

            // Graph
            GraphWithDropdown(),

            // Refresh Button
            TextButton(
              //TODO should we check if we are already refreshing before
                onPressed: () {
                  // Reset to defaults, and set state to show loading
                  isLoaded = false;
                  _weatherDataJson = [];
                  setState(() {});

                  loadWeatherData().then((value) {
                    setState(() {
                      if(value.isEmpty) {
                        isLoaded = false;
                      }else{
                        _weatherDataJson = value;
                        isLoaded = true;
                      }
                    });
                  });
                },
                child: const Text('Refresh ⟳'))
          ],
        ));
  }
}

List<Text> getInfo(String infoId, String prefix, String suffix) {
  if (!isLoaded) {
    return [
      const Text("Loading...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
    ];
  }

  if (infoId == "created_on") {
    return [
      Text(prefix,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w400)),
      Text(
          "${formatDate(_weatherDataJson[_weatherDataJson.length - 1][infoId])}$suffix",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
    ];
  }

  return [
    Text(prefix,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w400)),
    Text(
        "${_weatherDataJson[_weatherDataJson.length - 1][infoId].toString()}$suffix",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
  ];
}

class InfoBox extends StatelessWidget {
  const InfoBox(
      {Key? key,
      required this.color,
      required this.width,
      required this.height,
      required this.data})
      : super(key: key);

  final Color color;
  final double width;
  final double height;
  final List<Text> data;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
        widthFactor: width,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data,
          ),
        ),
      ),
    );
  }
}
