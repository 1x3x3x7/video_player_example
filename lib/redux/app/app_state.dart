import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:video_player_example/domain/api_response.dart';
import 'package:video_player_example/redux/session/session_state.dart';
import 'package:video_player_example/redux/session/workout/workout_state.dart';

@immutable
class AppState {
  final SessionState sessionState;
  AppState({required this.sessionState});

  factory AppState.initial() {
    return AppState(
        sessionState: SessionState(
            response: ApiResponse.loading('loading'),
            workoutState: WorkoutInitial()));
  }
  AppState copyWith(SessionState? sessionState) {
    return AppState(sessionState: sessionState ?? this.sessionState);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          sessionState == other.sessionState;

  @override
  String toString() {
    return '${const JsonEncoder.withIndent(' ').convert(this)}';
  }

  @override
  int get hashCode => sessionState.hashCode;
}
