import '../Utils/global_variables.dart';
import '../Utils/weather_data_utils.dart';

import 'package:flutter/material.dart';

import 'high_low.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({Key? key}) : super(key: key);

  // TODO
  @override
  Widget build(BuildContext context) {
    return (Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        TextButton(
          onPressed: () {
            // Reset to defaults, and set state to show loading
            currLoadState.value = LoadState.loading;
            weatherDataJson = [];

            loadWeatherData().then((value) {
              if (value.isEmpty) {
                currLoadState.value = LoadState.error;
              } else {
                weatherDataJson = value;
                currLoadState.value = LoadState.loaded;
              }
            });
          },
          child: const Text('Refresh ⟳')),
          TextButton(
              onPressed: (){
                Navigator.of(context).push(_createRoute());
              },
              child: const Text('Highs and Lows'))
    ]
    )
    );
  }

  Route _createRoute(){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HighLow(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        }
    );
  }
}