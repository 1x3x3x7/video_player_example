import 'package:video_player_example/domain/api_response.dart';
import 'package:video_player_example/domain/workout_response.dart';

class SessionLoadAction {
  final int id;

  SessionLoadAction(this.id);
}

class SessionLoadedAction {
  final ApiResponse<WorkoutResponse> data;

  SessionLoadedAction(this.data);
}
