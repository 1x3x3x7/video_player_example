import 'package:redux/redux.dart';
import 'package:video_player_example/data/workout_repository.dart';
import 'package:video_player_example/domain/api_response.dart';
import 'package:video_player_example/redux/session/session_actions.dart';
import 'package:video_player_example/redux/session/session_state.dart';

class SessionMiddleware implements MiddlewareClass<SessionState> {
  final WorkoutRepository workoutRepository;

  const SessionMiddleware(this.workoutRepository);

  @override
  call(Store store, action, NextDispatcher next) async {
    if (action is SessionLoadAction) {
      store.dispatch(SessionLoadedAction(ApiResponse.loading('loading')));
      try {
        final data = await workoutRepository.loadWorkout(action.id);
        store.dispatch(SessionLoadedAction(ApiResponse.completed(data)));
      } catch (e) {
        store.dispatch(SessionLoadedAction(ApiResponse.error(e.toString())));
      }
    }

    next(action);
  }
}
