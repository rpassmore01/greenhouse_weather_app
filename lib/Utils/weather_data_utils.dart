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

enum WeatherUnits {
  temperature,
  humidity
}

enum DayUnits {
  day,
  week,
  month,
  year,
  allTime
}

DayUnits parseDayUnits(String unit){
  for(DayUnits parsedUnit in DayUnits.values){
    if(parsedUnit.name == unit){
      return parsedUnit;
    }
  }
  return DayUnits.day;
}

Duration getDurationFromDayUnits(DayUnits units){

  switch (units) {
    case DayUnits.day:
      return const Duration(days: 1);
    case DayUnits.week:
      return const Duration(days: 7);
    case DayUnits.month:
      return const Duration(days: 30);
    case DayUnits.year:
      return const Duration(days: 365);
    case DayUnits.allTime:
      break;
  }

  return const Duration(days: 0);
}