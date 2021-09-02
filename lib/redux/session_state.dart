import 'dart:convert';

import 'package:video_player/video_player.dart';
import 'package:video_player_example/data/exercise.dart';

abstract class SessionState {}

class SessionInitial implements SessionState {}

class SessionError implements SessionState {}

class SessionLoading implements SessionState {}

class SessionEnd implements SessionState {
  final double stopwatchTime;

  SessionEnd(this.stopwatchTime);

  @override
  String toString() {
    return '${const JsonEncoder.withIndent(' ').convert(this)}';
  }
}

class SessionLoaded implements SessionState {
  SessionLoaded(
      {required this.exercises,
      required this.controller,
      this.playing = true,
      this.playingIndex = 0,
      this.countdownTime = 999,
      this.stopwatchTime = 0});

  final VideoPlayerController controller;
  final List<Exercise> exercises;
  final bool playing;
  final int playingIndex;

  final double countdownTime;
  final double stopwatchTime;

  @override
  String toString() {
    return '${const JsonEncoder.withIndent(' ').convert(this)}';
  }

  SessionLoaded copyWith({
    VideoPlayerController? controller,
    bool? playing,
    int? playingIndex,
    double? countdownTime,
    double? stopwatchTime,
    List<Exercise>? exercises,
  }) {
    return SessionLoaded(
      controller: controller ?? this.controller,
      playing: playing ?? this.playing,
      playingIndex: playingIndex ?? this.playingIndex,
      countdownTime: countdownTime ?? this.countdownTime,
      stopwatchTime: stopwatchTime ?? this.stopwatchTime,
      exercises: exercises ?? this.exercises,
    );
  }
}
