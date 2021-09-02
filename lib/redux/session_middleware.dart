import 'dart:async';

import 'package:redux/redux.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_example/data/workout_repository.dart';
import 'package:video_player_example/redux/app_state.dart';
import 'package:video_player_example/redux/session_actions.dart';
import 'package:video_player_example/redux/session_state.dart';

class SessionMiddleware implements MiddlewareClass<SessionState> {
  Timer? sessionTicker;
  final workoutRepository = WorkoutRepository();

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
        startTimer(store as Store<AppState>);
      }
    }

    if (action is SessionPauseAction) {
      if (state is SessionLoaded) {
        assert(state.controller.value.isInitialized);
        await state.controller.pause();
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
          store.dispatch(SessionEndAction(state.stopwatchTime));
        }
      }
    }
    next(action);
  }

// TODO make timer more smoothly
  void startTimer(Store<AppState> store) {
    if ((sessionTicker != null && !sessionTicker!.isActive) ||
        sessionTicker == null) {
      sessionTicker?.cancel();
      sessionTicker = Timer.periodic(Duration(milliseconds: 300), (timer) {
        if (store.state.sessionState is SessionLoaded &&
            (store.state.sessionState as SessionLoaded).playing) {
          store.dispatch(SessionTickAction(0.3));
        } else {
          timer.cancel();
        }
      });
    }
  }
}
