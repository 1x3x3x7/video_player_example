import 'package:redux/redux.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_example/redux/app_state.dart';
import 'package:video_player_example/redux/session_actions.dart';
import 'package:video_player_example/redux/session_state.dart';

class SessionMiddleware implements MiddlewareClass<SessionState> {
  final workoutRepository;
  final tickerRepository;

  const SessionMiddleware(this.tickerRepository, this.workoutRepository);

  @override
  call(Store store, action, NextDispatcher next) async {
    final state = (store.state as AppState).sessionState;

    if (action is SessionInitAction) {
      store.dispatch(SessionStartInitializingAction());
      try {
        final exercises = await workoutRepository.loadWorkout(action.id);
        final VideoPlayerController controller =
            VideoPlayerController.network(exercises[0].url);
        await controller.initialize();
        await controller.setLooping(true);

        store.dispatch(SessionInitializedAction(controller, exercises));

        store.dispatch(SessionPlayAction());
      } catch (error) {
        store.dispatch(SessionErrorAction());
      }
    }

    if (action is SessionPlayAction) {
      if (state is SessionLoaded) {
        assert(state.controller.value.isInitialized);
        await state.controller.play();
        tickerRepository.start(Duration(seconds: 1),
            (event) => store.dispatch(SessionTickAction(1)));
      }
    }

    if (action is SessionPauseAction) {
      if (state is SessionLoaded) {
        assert(state.controller.value.isInitialized);
        await state.controller.pause();
        await tickerRepository.stop();
      }
    }

    if (action is SessionInitNextAction) {
      if (state is SessionLoaded) {
        var nextIndex = state.playingIndex + 1;
        if (nextIndex < state.exercises.length) {
          try {
            final VideoPlayerController controller =
                VideoPlayerController.network(state.exercises[nextIndex].url);

            await state.controller.pause();
            await controller.initialize();
            await controller.setLooping(true);
// TODO need dispose old controller
            store.dispatch(SessionNextInitializedAction(controller, nextIndex));

            store.dispatch(SessionPlayAction());
          } catch (error) {
            store.dispatch(SessionErrorAction());
          }
        } else {
          workoutRepository.doneWorkout();
          tickerRepository.stop();
          store.dispatch(SessionEndAction(state.stopwatchTime));
        }
      }
    }
    next(action);
  }
}
