import 'package:flutter/material.dart';

class SessionEndScreen extends StatelessWidget {
  final String minutes;
  const SessionEndScreen({Key? key, required this.minutes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Session end"),
        ),
        body: Center(
          child: Text('You trained $minutes minutes!'),
        ));
  }
}
