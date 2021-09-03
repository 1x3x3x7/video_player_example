import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:video_player_example/presentation/delay_widget.dart';
import 'package:video_player_example/presentation/thumbnail_widget.dart';
import 'package:video_player_example/presentation/video_controls_widget.dart';
import 'package:video_player_example/presentation/video_overlay_widget.dart';
import 'package:video_player_example/presentation/video_widget.dart';
import 'package:video_player_example/redux/app_state.dart';
import 'package:video_player_example/redux/session_actions.dart';
import 'package:video_player_example/redux/session_state.dart';
import 'package:video_player_example/common/extensions.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SessionScreenViewModel>(
      onInit: (store) {
        store.dispatch(SessionInitAction(0));
      },
      converter: (store) => _SessionScreenViewModel(
        state: store.state.sessionState,
        playing: store.state.sessionState is SessionLoaded
            ? (store.state.sessionState as SessionLoaded).playing
            : false,
        started: store.state.sessionState is SessionLoaded
            ? (store.state.sessionState as SessionLoaded).started
            : false,
        delayTime: store.state.sessionState is SessionLoaded
            ? (store.state.sessionState as SessionLoaded).delayTime
            : 0.0,
        countdownTime: store.state.sessionState is SessionLoaded
            ? (store.state.sessionState as SessionLoaded).countdownTime
            : double.infinity,
        stopwatchTime: _getStopwatchTimer(store.state.sessionState),
        exerciseTitle: store.state.sessionState is SessionLoaded
            ? (store.state.sessionState as SessionLoaded)
                .exercises[
                    (store.state.sessionState as SessionLoaded).playingIndex]
                .title
            : "",
        thumbnail: store.state.sessionState is SessionLoaded
            ? (store.state.sessionState as SessionLoaded)
                .exercises[
                    (store.state.sessionState as SessionLoaded).playingIndex]
                .thumbnail
            : "",
        onPlay: () => store.dispatch(SessionPlayAction()),
        onPause: () => store.dispatch(SessionPauseAction()),
        onNext: () => store.dispatch(SessionInitNextAction()),
      ),
      builder: (context, vm) => Scaffold(
          appBar: AppBar(
            title: Text("Video"),
          ),
          body: _buildVisible(vm)),
    );
  }

  double _getStopwatchTimer(SessionState state) {
    if (state is SessionLoaded)
      return state.stopwatchTime;
    else if (state is SessionEnd)
      return state.stopwatchTime;
    else
      return 0.0;
  }

  Widget _buildVisible(_SessionScreenViewModel vm) {
    if (vm.state is SessionInitial) {
      return Container();
    } else if (vm.state is SessionLoading) {
      return Container(
        alignment: FractionalOffset.center,
        child: CircularProgressIndicator(),
      );
    } else if (vm.state is SessionLoaded) {
      final state = vm.state as SessionLoaded;
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
                            title: vm.exerciseTitle,
                            onEnd: vm.onNext))
                  ],
                ))
          ],
        ),
      );
    } else if (vm.state is SessionError) {
      return Center(
        child: Text('ERROR'),
      );
    } else if (vm.state is SessionEnd) {
      final min = vm.stopwatchTime.toInt().stopwatch();
      return Center(
        child: Text('You trained $min minutes!'),
      );
    }
    throw ArgumentError('No view for state: ${vm.state}');
  }
}

class _SessionScreenViewModel {
  final SessionState state;
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

  _SessionScreenViewModel({
    required this.state,
    required this.playing,
    required this.started,
    required this.delayTime,
    required this.countdownTime,
    required this.stopwatchTime,
    required this.exerciseTitle,
    required this.thumbnail,
    required this.onPause,
    required this.onPlay,
    required this.onNext,
  });
}
