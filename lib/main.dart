import 'dart:convert';

import 'package:greenhouse_weather_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
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
              ],
            )));
  }
}

String formatDate(String date){
  try{
    DateTime dateTime = DateTime(
        int.parse(date.substring(0, 4)),
        int.parse(date.substring(5, 7)),
        int.parse(date.substring(8, 10)),
        int.parse(date.substring(11, 13)),
        int.parse(date.substring(14, 16)));

    return "${getDayName(dateTime.weekday)} ${getDayMonth(dateTime.month)} ${dateTime.day}\n${dateTime.hour}:${dateTime.minute}";

  }catch(err) {
    return "ERROR";
  }
}

class InfoBox extends StatelessWidget {
  InfoBox(
      {required this.color,
      required this.width,
      required this.height,
      required this.data});

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
