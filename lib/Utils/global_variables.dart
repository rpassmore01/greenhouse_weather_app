// Default values, Overwritten on app load. If fail, use 1080p screen dimensions
import 'package:flutter/material.dart';

double displayHeight = 1920;
double displayWidth = 1080;

ValueNotifier<LoadState> currLoadState = ValueNotifier(LoadState.loading);
var weatherDataJson = [];

enum LoadState {
  loading,
  loaded,
  error,
}