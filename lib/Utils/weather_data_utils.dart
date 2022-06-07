import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

Future<List> loadWeatherData() async{
  const url = "https://greenhouse.russellpassmore.me";

  try {
    final weatherData = await get(Uri.parse(url));
    final jsonWeatherData = jsonDecode(weatherData.body) as Map;
    List<dynamic> data = jsonWeatherData["data"];

    if (kDebugMode) {
      print(data);
    }

    return data;

  } catch (err) {
    if (kDebugMode) {
      print("Error: $err");
    }
  }
  return [];
}