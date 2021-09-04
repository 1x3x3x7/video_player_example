import 'package:video_player/video_player.dart';
import 'package:video_player_example/data/exercise.dart';

class SessionInitAction {
  final int id;

  SessionInitAction(this.id);
}

class SessionErrorAction {
  final exception;

  SessionErrorAction(this.exception);
}

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
