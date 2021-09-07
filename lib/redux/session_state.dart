import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_example/data/exercise.dart';

abstract class SessionState {}

class SessionInitial implements SessionState {}

class SessionError implements SessionState {
  final error;

  SessionError(this.error);
}

class SessionLoading implements SessionState {}

class SessionEmpty implements SessionState {}

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
      this.playing = false,
      this.started = false,
      this.playingIndex = 0,
      this.delayTime = 0,
      this.countdownTime = double.infinity,
      this.stopwatchTime = 0});

  final VideoPlayerController controller;
  final List<Exercise> exercises;
  final bool playing;
  final bool started;
  final int playingIndex;

  final double delayTime;
  final double countdownTime;
  final double stopwatchTime;

  @override
  String toString() {
    return '${const JsonEncoder.withIndent(' ').convert(this)}';
  }

  SessionLoaded copyWith({
    VideoPlayerController? controller,
    bool? playing,
    bool? started,
    int? playingIndex,
    double? delayTime,
    double? countdownTime,
    double? stopwatchTime,
    List<Exercise>? exercises,
  }) {
    if (controller != null)
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await this.controller.dispose();
      });
    return SessionLoaded(
      controller: controller ?? this.controller,
      playing: playing ?? this.playing,
      started: started ?? this.started,
      playingIndex: playingIndex ?? this.playingIndex,
      delayTime: delayTime ?? this.delayTime,
      countdownTime: countdownTime ?? this.countdownTime,
      stopwatchTime: stopwatchTime ?? this.stopwatchTime,
      exercises: exercises ?? this.exercises,
    );
  }
}
