import 'package:flutter/material.dart';

class DelayWidget extends StatelessWidget {
  final double delayTime;
  const DelayWidget({Key? key, required this.delayTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      delayTime < 0.1 ? "START" : delayTime.toStringAsFixed(0),
      style: TextStyle(
          fontSize: 92, color: Colors.blueGrey, fontWeight: FontWeight.w900),
    ));
  }
}
