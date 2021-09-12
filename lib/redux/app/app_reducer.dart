import 'package:video_player_example/redux/session/session_reducer.dart';
import 'package:video_player_example/redux/session/workout/workout_reducer.dart';

import 'app_state.dart';

AppState appReducer(AppState state, action) {
  return AppState(
      sessionState: sessionReducer(
          state.sessionState.copyWith(
              workoutState:
                  workoutReducer(state.sessionState.workoutState, action)),
          action));
}
