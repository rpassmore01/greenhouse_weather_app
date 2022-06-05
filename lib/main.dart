import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:greenhouse_weather_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

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

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class GraphWithDropdown extends StatefulWidget{
  @override
  _GraphWithDropdown createState() => _GraphWithDropdown();
}

class _GraphWithDropdown extends State{
  String selectedValue = "day";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: Graph(_createSampleData(), animate: false),
        ),
        DropdownButton(
        value: selectedValue,
        items: dropdownItems,
      onChanged: (String? newValue){
          setState(() {
            selectedValue = newValue!;
          });
      },
    ),
      ]
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesSales(DateTime(2017, 9, 19), 5),
      TimeSeriesSales(DateTime(2017, 9, 26), 25),
      TimeSeriesSales(DateTime(2017, 10, 3), 100),
      TimeSeriesSales(DateTime(2017, 10, 10), 75),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "day",child: Text("1 day"),),
      const DropdownMenuItem(value: "week",child: Text("1 week"),),
      const DropdownMenuItem(value: "month",child: Text("1 month"),),
      const DropdownMenuItem(value: "year",child: Text("1 year"),),
      const DropdownMenuItem(value: "all",child: Text("All time"),),
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

  var _weatherDataJson = [];

  void fetchWeatherData() async {
    try {
      final weatherData = await get(Uri.parse(url));
      final jsonWeatherData = jsonDecode(weatherData.body) as Map;
      List<dynamic> data = jsonWeatherData["data"];

      print(data);

      setState(() {
        _weatherDataJson = data;
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
                        data:
                            "Temperature:\n ${_weatherDataJson[_weatherDataJson.length - 1]['temperature'].toString()}°C"),
                    InfoBox(
                        color: Colors.red,
                        width: .85,
                        height: 90,
                        data:
                            "Humidity:\n ${_weatherDataJson[_weatherDataJson.length - 1]['humidity'].toString()}%")
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
                        data:
                            "Recorded At:\n ${formatDate(_weatherDataJson[_weatherDataJson.length - 1]['created_on'].toString())}")
                  ],
                ),
                const SizedBox(height: 15),
                GraphWithDropdown(),
              ],
            )));
  }
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
