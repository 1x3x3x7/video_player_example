import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:video_player_example/domain/exercise.dart';
import 'package:video_player_example/presentation/session/delay_widget.dart';
import 'package:video_player_example/presentation/session/session_progress_widget.dart';
import 'package:video_player_example/presentation/session/thumbnail_widget.dart';
import 'package:video_player_example/presentation/session/video_controls_widget.dart';
import 'package:video_player_example/presentation/session/video_overlay_widget.dart';
import 'package:video_player_example/presentation/session/video_widget.dart';
import 'package:video_player_example/redux/app/app_state.dart';
import 'package:video_player_example/redux/session/workout/workout_actions.dart';
import 'package:video_player_example/redux/session/workout/workout_state.dart';

class WorkoutWidget extends StatelessWidget {
  final List<Exercise> exercises;
  const WorkoutWidget({Key? key, required this.exercises}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _WorkoutViewModel>(
      onInit: (store) => store.dispatch(WorkoutInitAction(exercises)),
      converter: (store) => _WorkoutViewModel.fromStore(store),
      builder: (context, vm) => _buildVisible(vm, context),
    );
  }

  Widget _buildVisible(_WorkoutViewModel vm, BuildContext context) {
    if (vm.state is WorkoutInitial) {
      return Container();
    } else if (vm.state is WorkoutEmpty) {
      return Center(
        child: Text('No Content'),
      );
    } else if (vm.state is WorkoutLoaded) {
      final state = vm.state as WorkoutLoaded;
      return Container(
        child: Column(
          children: [
            VideoControlsWidget(
              playing: vm.playing,
              stopwatchTime: vm.stopwatchTime,
              onPause: vm.onPause,
              onPlay: vm.onPlay,
              onNext: vm.onNext,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    VideoWidget(controller: state.controller, aspectRatio: 1),
                    if (!vm.playing)
                      ThumbnailWidget(aspectRatio: 1, url: vm.thumbnail),
                    if (!vm.started) DelayWidget(delayTime: vm.delayTime),
                    Align(
                        alignment: Alignment.topLeft,
                        child: VideoOverlayWidget(
                            countdownTime: vm.countdownTime,
                            title: vm.exerciseTitle))
                  ],
                )),
            SessionProgressWidget(
                index: vm.playingIndex, size: vm.exerciseCount)
          ],
        ),
      );
    } else if (vm.state is WorkoutError) {
      return Center(
        child: Text('Error: ${vm.error}'),
      );
    }
    throw ArgumentError('No view for state: ${vm.state}');
  }
}

class _WorkoutViewModel {
  final WorkoutState state;
  final void Function() onPlay;
  final void Function() onPause;
  final void Function() onNext;

  final playing;
  final started;
  final delayTime;
  final countdownTime;
  final double stopwatchTime;
  final exerciseTitle;
  final thumbnail;
  final playingIndex;
  final exerciseCount;
  final error;

  _WorkoutViewModel({
    required this.state,
    required this.playing,
    required this.started,
    required this.delayTime,
    required this.countdownTime,
    required this.stopwatchTime,
    required this.exerciseTitle,
    required this.thumbnail,
    required this.playingIndex,
    required this.exerciseCount,
    required this.error,
    required this.onPause,
    required this.onPlay,
    required this.onNext,
  });

  static _WorkoutViewModel fromStore(Store<AppState> store) {
    double _getStopwatchTimer(WorkoutState state) {
      if (state is WorkoutLoaded)
        return state.stopwatchTime;
      else
        return 0.0;
    }

    return _WorkoutViewModel(
      state: store.state.sessionState.workoutState,
      playing: store.state.sessionState.workoutState is WorkoutLoaded
          ? (store.state.sessionState.workoutState as WorkoutLoaded).playing
          : false,
      started: store.state.sessionState.workoutState is WorkoutLoaded
          ? (store.state.sessionState.workoutState as WorkoutLoaded).started
          : false,
      delayTime: store.state.sessionState.workoutState is WorkoutLoaded
          ? (store.state.sessionState.workoutState as WorkoutLoaded).delayTime
          : 0.0,
      countdownTime: store.state.sessionState.workoutState is WorkoutLoaded
          ? (store.state.sessionState.workoutState as WorkoutLoaded)
              .countdownTime
          : double.infinity,
      stopwatchTime: _getStopwatchTimer(store.state.sessionState.workoutState),
      exerciseTitle: store.state.sessionState.workoutState is WorkoutLoaded
          ? (store.state.sessionState.workoutState as WorkoutLoaded)
              .exercises[
                  (store.state.sessionState.workoutState as WorkoutLoaded)
                      .playingIndex]
              .title
          : "",
      thumbnail: store.state.sessionState.workoutState is WorkoutLoaded
          ? (store.state.sessionState.workoutState as WorkoutLoaded)
              .exercises[
                  (store.state.sessionState.workoutState as WorkoutLoaded)
                      .playingIndex]
              .thumbnail
          : "",
      playingIndex: store.state.sessionState.workoutState is WorkoutLoaded
          ? (store.state.sessionState.workoutState as WorkoutLoaded)
              .playingIndex
          : 0,
      exerciseCount: store.state.sessionState.workoutState is WorkoutLoaded
          ? (store.state.sessionState.workoutState as WorkoutLoaded)
              .exercises
              .length
          : 0,
      error: store.state.sessionState.workoutState is WorkoutError
          ? (store.state.sessionState.workoutState as WorkoutError)
              .error
              .toString()
          : "",
      onPlay: () => store.dispatch(WorkoutPlayAction()),
      onPause: () => store.dispatch(WorkoutPauseAction()),
      onNext: () => store.dispatch(WorkoutInitNextAction()),
    );
  }
}
