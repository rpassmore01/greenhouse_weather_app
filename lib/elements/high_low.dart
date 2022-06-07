import 'package:flutter/material.dart';

class HighLow extends StatefulWidget{
  const HighLow({Key? key}) : super(key: key);

  @override
  _HighLow createState() => _HighLow();
}

class _HighLow extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Column(
            children: const [
              Center(
                  child: Text('High Low Page.')
              ),
            ]
        )
    );
  }
}