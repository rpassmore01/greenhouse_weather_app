import '../Utils/global_variables.dart';
import '../Utils/format_utils.dart';

import 'package:flutter/material.dart';

class InfoBoxes extends StatefulWidget {
  const InfoBoxes({Key? key}) : super(key: key);

  @override
  _InfoBoxes createState() => _InfoBoxes();
}

class _InfoBoxes extends State {

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SingleInfoBox(
                color: Colors.blue,
                width: .85,
                height: 90,
                data: getInfo("temperature", "Temperature:", "°C")),
            SingleInfoBox(
                color: Colors.red,
                width: .85,
                height: 90,
                data: getInfo("humidity", "Humidity:", "%"))
          ],
        ),

        SizedBox(height: displayHeight * 0.3),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleInfoBox(
                color: Colors.green,
                width: .5,
                height: 90,
                data: getInfo("created_on", "Recorded At:", ""))
          ],
        ),
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
          "${formatDate(weatherDataJson[weatherDataJson.length - 1][infoId])}$suffix",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
    ];
  }

  return [
    Text(prefix,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w400)),
    Text(
        "${weatherDataJson[weatherDataJson.length - 1][infoId].toString()}$suffix",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
  ];
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
