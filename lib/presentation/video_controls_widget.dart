import 'package:flutter/material.dart';
import 'package:video_player_example/common/extensions.dart';

class VideoControlsWidget extends StatelessWidget {
  final bool playing;
  final Function onPause;
  final Function onPlay;
  final Function onNext;
  final double stopwatchTime;

  const VideoControlsWidget({
    Key? key,
    required this.playing,
    required this.stopwatchTime,
    required this.onPause,
    required this.onPlay,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(stopwatchTime.toInt().stopwatch(),
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
          IconButton(
              onPressed: () => playing ? onPause() : onPlay(),
              icon: Icon(playing ? Icons.pause : Icons.play_arrow)),
          playing
              ? Container()
              : MaterialButton(
                  child: Text('next'),
                  onPressed: () => onNext(),
                )
        ],
      );
}
