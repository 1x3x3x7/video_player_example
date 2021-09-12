import 'package:flutter/material.dart';

extension IntExtensions on int {
  String stopwatch() {
    String minutes = (this ~/ 60).toString().padLeft(2, '0');
    String seconds = (this % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

extension WidgetExtension on Widget {
  buildRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => this,
    );
  }
}
