import 'package:flutter/material.dart';
import 'package:video_player_example/common/extensions.dart';

class VideoOverlayWidget extends StatelessWidget {
  VideoOverlayWidget(
      {Key? key,
      required this.countdownTime,
      required this.title,
      required this.onEnd})
      : super(key: key);

  final double countdownTime;
  final String title;
  final Function onEnd;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0x01000000),
      margin: EdgeInsets.all(8),
      child: Container(
        margin: EdgeInsets.all(4),
        height: 68,
        width: 86,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              countdownTime < 0.1 ? end() : coundown(),
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String end() {
    onEnd();
    return 'end';
  }

  String coundown() {
    debugPrint('countdownTime = $countdownTime');
    return countdownTime.toInt().stopwatch();
  }
}
