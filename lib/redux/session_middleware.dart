import 'package:redux/redux.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_example/common/tts_controller.dart';
import 'package:video_player_example/data/ticker_repository.dart';
import 'package:video_player_example/data/workout_repository.dart';
import 'package:video_player_example/redux/app_state.dart';
import 'package:video_player_example/redux/session_actions.dart';
import 'package:video_player_example/redux/session_state.dart';

class SessionMiddleware implements MiddlewareClass<SessionState> {
  final WorkoutRepository workoutRepository;
  final TickerRepository tickerRepository;
  final TtsController ttsController;

  const SessionMiddleware(
      this.tickerRepository, this.workoutRepository, this.ttsController);

  @override
  call(Store store, action, NextDispatcher next) async {
    final state = (store.state as AppState).sessionState;

    if (action is SessionInitAction) {
      store.dispatch(SessionStartInitializingAction());
      try {
        final exercises = await workoutRepository.loadWorkout(action.id);
        if (exercises.isEmpty) {
          store.dispatch(SessionEmptyAction());
        } else {
          final nextExerciseUrl = exercises[0].url;
          final VideoPlayerController controller =
              nextExerciseUrl.startsWith('assets')
                  ? VideoPlayerController.asset(nextExerciseUrl)
                  : VideoPlayerController.network(nextExerciseUrl);
          await controller.initialize();
          await controller.setLooping(true);

          store.dispatch(SessionInitializedAction(controller, exercises));

          store.dispatch(SessionPlayAction());
        }
      } catch (e) {
        store.dispatch(SessionErrorAction(e));
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
            final nextExerciseUrl = state.exercises[nextIndex].url;
            final VideoPlayerController controller =
                nextExerciseUrl.startsWith('assets')
                    ? VideoPlayerController.asset(nextExerciseUrl)
                    : VideoPlayerController.network(nextExerciseUrl);

            await state.controller.pause();
            await controller.initialize();
            await controller.setLooping(true);
            store.dispatch(SessionNextInitializedAction(controller, nextIndex));

            store.dispatch(SessionPlayAction());
          } catch (e) {
            store.dispatch(SessionErrorAction(e));
          }
        } else {
          workoutRepository.doneWorkout();
          tickerRepository.stop();
          store.dispatch(SessionEndAction(state.stopwatchTime));
        }
      }
    }

    if (action is SessionTickAction) {
      if (state is SessionLoaded) {
        if (state.delayTime.toInt() ==
                state.exercises[state.playingIndex].delay &&
            state.countdownTime.toInt() ==
                state.exercises[state.playingIndex].duration) {
          ttsController.speak(state.exercises[state.playingIndex].title);
        }
        if (state.delayTime == 1.0) ttsController.speak('start');
        if (state.countdownTime.toInt() <= 4 &&
            state.countdownTime.toInt() > 1) {
          ttsController.speak((state.countdownTime.toInt() - 1).toString());
        }
      }
    }

    next(action);
  }
}
