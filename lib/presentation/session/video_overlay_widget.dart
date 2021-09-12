import 'package:flutter/material.dart';
import 'package:video_player_example/common/extensions.dart';

class VideoOverlayWidget extends StatelessWidget {
  VideoOverlayWidget(
      {Key? key, required this.countdownTime, required this.title})
      : super(key: key);

  final double countdownTime;
  final String title;

  String get coundown {
    debugPrint('countdownTime = $countdownTime');
    return countdownTime.toInt().stopwatch();
  }

  @override
  Widget build(BuildContext context) => buildOverlay();

  Widget buildOverlay() => Wrap(children: [
        Card(
          color: Color(0x01000000),
          margin: EdgeInsets.all(8),
          child: Container(
            margin: EdgeInsets.all(4),
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
                  countdownTime < 0.0 ? '00:00' : coundown,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ]);
}
