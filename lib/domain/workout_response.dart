import 'package:video_player_example/domain/exercise.dart';

class WorkoutResponse {
  WorkoutResponse({
    required this.exercises,
  });

  List<Exercise> exercises;

  factory WorkoutResponse.fromJson(Map<String, dynamic> json) =>
      WorkoutResponse(
        exercises: List<Exercise>.from(
            json["exercises"].map((x) => Exercise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
      };
}
