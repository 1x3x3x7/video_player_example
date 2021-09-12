import 'package:video_player_example/domain/api_response.dart';
import 'package:video_player_example/domain/exercise.dart';

class SessionLoadAction {
  final int id;

  SessionLoadAction(this.id);
}

class SessionLoadedAction {
  final ApiResponse<List<Exercise>> data;

  SessionLoadedAction(this.data);
}
