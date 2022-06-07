import '../Utils/global_variables.dart';
import '../Utils/weather_data_utils.dart';

import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({Key? key}) : super(key: key);

  // TODO
  @override
  Widget build(BuildContext context) {
    return (TextButton(
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
          child: const Text('Refresh ⟳'))
    );
  }
}