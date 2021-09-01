import 'package:video_player/video_player.dart';
import 'package:video_player_example/exercise.dart';

class SessionInitAction {
  final List<Exercise> args;

  SessionInitAction(this.args);
}

class SessionErrorAction {}

class SessionPlayAction {}

class SessionPauseAction {}

class SessionInitNextAction {}

class SessionTickAction {
  final double seconds;
  SessionTickAction(this.seconds);
}

class SessionStartInitializingAction {}

class SessionInitializedAction {
  final VideoPlayerController controller;
  final List<Exercise> exercises;
  SessionInitializedAction(this.controller, this.exercises);
}

class SessionNextInitializedAction {
  final VideoPlayerController controller;
  final int playingIndex;
  SessionNextInitializedAction(this.controller, this.playingIndex);
}

class SessionEndAction {
  final double seconds;
  SessionEndAction(this.seconds);
}
