import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
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
    }catch(err){
      print("Error: ${err}");
    }
  }

  @override
  void initState(){
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
            itemCount: _weatherDataJson.length,
            itemBuilder: (context, i) {
              final currWeatherData = _weatherDataJson[i];
              return Text("Temperature: ${currWeatherData["temperature"]}\n Humidity: ${currWeatherData["humidity"]}");
            }),
      )
    );
  }
}