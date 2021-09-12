import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_example/common/app_routes.dart';
import 'package:video_player_example/common/extensions.dart';
import 'package:video_player_example/common/tts_controller.dart';
import 'package:video_player_example/data/ticker_repository.dart';
import 'package:video_player_example/data/workout_repository.dart';
import 'package:video_player_example/redux/app/app_state.dart';
import 'package:video_player_example/redux/session/workout/workout_actions.dart';
import 'package:video_player_example/redux/session/workout/workout_state.dart';

class WorkoutMiddleware implements MiddlewareClass<WorkoutState> {
  final WorkoutRepository workoutRepository;
  final TickerRepository tickerRepository;
  final TtsController ttsController;

  const WorkoutMiddleware(
      this.tickerRepository, this.workoutRepository, this.ttsController);

  @override
  call(Store store, action, NextDispatcher next) async {
    final state = (store.state as AppState).sessionState.workoutState;

    if (action is WorkoutInitAction) {
      store.dispatch(WorkoutStartInitializingAction());
      try {
        if (action.exercises.isEmpty) {
          store.dispatch(WorkoutEmptyAction());
        } else {
          final nextExerciseUrl = action.exercises[0].url;
          final VideoPlayerController controller =
              nextExerciseUrl.startsWith('assets')
                  ? VideoPlayerController.asset(nextExerciseUrl)
                  : VideoPlayerController.network(nextExerciseUrl);
          await controller.initialize();
          await controller.setLooping(true);

          store
              .dispatch(WorkoutInitializedAction(controller, action.exercises));

          store.dispatch(WorkoutPlayAction());
        }
      } catch (e) {
        store.dispatch(WorkoutErrorAction(e));
      }
    }
    if (action is WorkoutPlayAction) {
      if (state is WorkoutLoaded) {
        assert(state.controller.value.isInitialized);
        await state.controller.play();
        tickerRepository.start(Duration(seconds: 1),
            (event) => store.dispatch(WorkoutTickAction(1)));
      }
    }
    if (action is WorkoutPauseAction) {
      if (state is WorkoutLoaded) {
        assert(state.controller.value.isInitialized);
        await state.controller.pause();
        await tickerRepository.stop();
      }
    }
    if (action is WorkoutInitNextAction) {
      if (state is WorkoutLoaded) {
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
            store.dispatch(WorkoutNextInitializedAction(controller, nextIndex));

            store.dispatch(WorkoutPlayAction());
          } catch (e) {
            store.dispatch(WorkoutErrorAction(e));
          }
        } else {
          workoutRepository.doneWorkout();
          tickerRepository.stop();
          store.dispatch(NavigateToAction.replace(AppRoutes.session_end_screen,
              arguments: state.stopwatchTime.toInt().stopwatch()));
        }
      }
    }
    if (action is WorkoutTickAction) {
      if (state is WorkoutLoaded) {
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
        if (state.countdownTime.toInt() == 1)
          store.dispatch(WorkoutInitNextAction());
      }
    }

    next(action);
  }
}
