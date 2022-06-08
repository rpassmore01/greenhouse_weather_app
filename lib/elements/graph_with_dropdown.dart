import 'package:greenhouse_weather_app/Utils/weather_data_utils.dart';

import '../Utils/global_variables.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GraphWithDropdowns extends StatefulWidget {
  const GraphWithDropdowns({Key? key}) : super(key: key);

  @override
  _GraphWithDropdowns createState() => _GraphWithDropdowns();
}

class _GraphWithDropdowns extends State {
  String selectedDate = "day";
  String selectedMode = "temperature";

  @override
  Widget build(BuildContext context) {
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
          height: displayHeight * .35, // Set size of graph here (35% of screen)
          child: ValueListenableBuilder<LoadState>(
              valueListenable: currLoadState,

              builder: (context, value, child) {
                return Graph(
                  _createSampleData(),
                  animate: false,
                  graphMode: selectedMode,
                );
              }
          )
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
    final Duration duration = getDurationFromDayUnits(parseDayUnits(selectedDate));

    for (var i = 0; i < weatherDataJson.length; i++) {
      final today = DateTime.now();
      DateTime currDateTime = DateTime.parse(weatherDataJson[i]['created_on']);

      if (today.subtract(duration).isBefore(currDateTime) ||
          duration.inDays == 0) {
        data.add(
            GenericTimeSeries(currDateTime, weatherDataJson[i][selectedMode]));
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