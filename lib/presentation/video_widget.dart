import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final double aspectRatio;

  final VideoPlayerController controller;

  VideoWidget({Key? key, required this.controller, required this.aspectRatio})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: widget.aspectRatio, child: VideoPlayer(widget.controller));
}
