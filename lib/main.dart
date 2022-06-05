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

class Graph extends StatelessWidget{
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;

  const Graph(this.seriesList, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

}

class GenericTimeSeries {
  final DateTime time;
  final int dataPoint;

  GenericTimeSeries(this.time, this.dataPoint);
}

class GraphWithDropdown extends StatefulWidget{
  @override
  _GraphWithDropdown createState() => _GraphWithDropdown();
}

class _GraphWithDropdown extends State{
  String selectedDate = "day";
  String selectedMode = "temperature";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          value: selectedMode,
          items: modeSelectorItems,
          onChanged: (String? newValue){
            setState(() {
              selectedMode = newValue!;
              _createSampleData();
            });
          },
        ),
        Container(
          height: 200,
          child: Graph(_createSampleData(), animate: false),
        ),
        DropdownButton(
        value: selectedDate,
        items: dateSelectorItems,
      onChanged: (String? newValue){
          setState(() {
            selectedDate = newValue!;
            _createSampleData();
          });
      },
    ),
      ]
    );
  }

   List<charts.Series<GenericTimeSeries, DateTime>> _createSampleData() {
    final List<GenericTimeSeries> data = [];
    Duration duration = const Duration(days: 0);

    switch(selectedDate){
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

    for(var i = 0; i < _weatherDataJson.length; i++){
      final today = DateTime.now();
      DateTime currDateTime = DateTime.parse(_weatherDataJson[i]['created_on']);

      if(today.subtract(duration).isBefore(currDateTime) || duration.inDays == 0){
        data.add(GenericTimeSeries(currDateTime, _weatherDataJson[i][selectedMode]));
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
      const DropdownMenuItem(value: "day",child: Text("1 day"),),
      const DropdownMenuItem(value: "week",child: Text("1 week"),),
      const DropdownMenuItem(value: "month",child: Text("1 month"),),
      const DropdownMenuItem(value: "year",child: Text("1 year"),),
      const DropdownMenuItem(value: "all",child: Text("All time"),),
    ];

    return menuItems;
  }

  List<DropdownMenuItem<String>> get modeSelectorItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "temperature",child: Text("temperature"),),
      const DropdownMenuItem(value: "humidity",child: Text("humidity"),),
    ];

    return menuItems;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final url = "https://greenhouse.russellpassmore.me";

  void fetchWeatherData() async {
    try {
      final weatherData = await get(Uri.parse(url));
      final jsonWeatherData = jsonDecode(weatherData.body) as Map;
      List<dynamic> data = jsonWeatherData["data"];

      print(data);

      setState(() {
        _weatherDataJson = data;
        isLoaded = true;
      });
    } catch (err) {
      print("Error: ${err}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Greenhouse Weather"),
            ),
            body: Column(
              children: <Widget>[
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoBox(
                        color: Colors.blue,
                        width: .85,
                        height: 90,
                        data: getInfo("temperature", "Temperature:\n", "°C")),
                    InfoBox(
                        color: Colors.red,
                        width: .85,
                        height: 90,
                        data: getInfo("humidity", "Humidity:\n", "%"))
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoBox(
                        color: Colors.green,
                        width: .5,
                        height: 90,
                        data: getInfo("created_on", "Recorded At:\n", ""))
                  ],
                ),
                const SizedBox(height: 15),
                GraphWithDropdown(),
              ],
            )));
  }
}

String getInfo(String infoId, String prefix, String suffix){
  if(!isLoaded) {
    return "Loading...";
  }

  if(infoId == "created_on"){
    return "$prefix${formatDate(_weatherDataJson[_weatherDataJson.length - 1][infoId])}$suffix";
  }

  return "$prefix${_weatherDataJson[_weatherDataJson.length - 1][infoId].toString()}$suffix";
}

class InfoBox extends StatelessWidget {
  const InfoBox({Key? key,
    required this.color,
    required this.width,
    required this.height,
    required this.data
  }) : super(key: key);

  final Color color;
  final double width;
  final double height;
  final String data;

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
            child: Center(
              child: Text(data, textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
            ),
          )),
    );
  }
}
