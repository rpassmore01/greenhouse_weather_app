import 'package:greenhouse_weather_app/Utils/weather_data_utils.dart';

import '../Utils/global_variables.dart';

import 'package:flutter/material.dart';

class HighLow extends StatefulWidget {
  const HighLow({Key? key}) : super(key: key);

  @override
  _HighLow createState() => _HighLow();
}

class _HighLow extends State {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Scaffold(
        body: Column(children: <Widget>[

          //TODO ADD A COOL TITLE HERE

          SizedBox(height: displayHeight * .1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SingleInfoBox(
                  color: Colors.green, width: .85, height: 50, data: "Highs/Lows\nOvertime"),
              SingleInfoBox(
                  color: Colors.green,
                  width: .85,
                  height: 50,
                  data: "Temperature"),
              SingleInfoBox(
                  color: Colors.green, width: .85, height: 50, data: "Humidity")
            ],
          ),

          const InfoGroup(title: "Last 24h:", dayUnits: DayUnits.day),
          const InfoGroup(title: "Last Week:", dayUnits: DayUnits.week),
          const InfoGroup(title: "Last Month:", dayUnits: DayUnits.month),
          const InfoGroup(title: "Last Year:", dayUnits: DayUnits.year),
          const InfoGroup(title: "All Time:", dayUnits: DayUnits.allTime),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )

        ]))]);
  }
}

String getDataPoint(DayUnits dayUnits, WeatherUnits weatherUnits) {
  final Duration duration = getDurationFromDayUnits(dayUnits);
  final String units = weatherUnits == WeatherUnits.temperature ? "°C" : "%";
  int currHigh = -1000; // start low
  int currLow = 1000; // start high

  for (var i = 0; i < weatherDataJson.length; i++) {
    final today = DateTime.now();
    final DateTime currDateTime =
        DateTime.parse(weatherDataJson[i]['created_on']);

    if (today.subtract(duration).isBefore(currDateTime) ||
        duration.inDays == 0) {
      final int currValue = weatherDataJson[i][weatherUnits.name];

      if (currHigh < currValue) {
        currHigh = currValue;
      }

      if (currLow > currValue) {
        currLow = currValue;
      }
    }
  }
  return "$currLow$units - $currHigh$units";
}

class InfoGroup extends StatelessWidget {
  const InfoGroup({Key? key, required this.title, required this.dayUnits})
      : super(key: key);

  final String title;
  final DayUnits dayUnits;

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      SizedBox(height: displayHeight * .03),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SingleInfoBox(color: Colors.red, width: .85, height: 50, data: title),
          SingleInfoBox(
              color: Colors.blue,
              width: .85,
              height: 50,
              data: getDataPoint(dayUnits, WeatherUnits.temperature)),
          SingleInfoBox(
              color: Colors.blue,
              width: .85,
              height: 50,
              data: getDataPoint(dayUnits, WeatherUnits.humidity))
        ],
      )
    ]);
  }
}

class SingleInfoBox extends StatelessWidget {
  const SingleInfoBox(
      {Key? key,
      required this.color,
      required this.width,
      required this.height,
      required this.data})
      : super(key: key);

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
            child: Text(data,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 17.5, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}
