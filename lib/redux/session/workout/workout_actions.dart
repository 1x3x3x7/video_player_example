import 'package:video_player/video_player.dart';

import 'package:video_player_example/domain/exercise.dart';

class WorkoutInitAction {
  final List<Exercise> exercises;
  WorkoutInitAction(
    this.exercises,
  );
}

class WorkoutEmptyAction {}

class WorkoutErrorAction {
  final exception;

  WorkoutErrorAction(this.exception);
}

class WorkoutPlayAction {}

class WorkoutPauseAction {}

class WorkoutInitNextAction {}

class WorkoutTickAction {
  final double seconds;
  WorkoutTickAction(this.seconds);
}

class WorkoutStartInitializingAction {}

class WorkoutInitializedAction {
  final VideoPlayerController controller;
  final List<Exercise> exercises;
  WorkoutInitializedAction(this.controller, this.exercises);
}

class WorkoutNextInitializedAction {
  final VideoPlayerController controller;
  final int playingIndex;
  WorkoutNextInitializedAction(this.controller, this.playingIndex);
}
