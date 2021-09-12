import 'package:redux/redux.dart';
import 'package:video_player_example/redux/session/workout/workout_actions.dart';
import 'package:video_player_example/redux/session/workout/workout_state.dart';

final workoutReducer = combineReducers<WorkoutState>([
  TypedReducer<WorkoutState, WorkoutStartInitializingAction>(_onInitializing),
  TypedReducer<WorkoutState, WorkoutEmptyAction>(_onEmpty),
  TypedReducer<WorkoutState, WorkoutErrorAction>(_onError),
  TypedReducer<WorkoutState, WorkoutInitializedAction>(_onInitialized),
  TypedReducer<WorkoutState, WorkoutInitNextAction>(_onNextInitializing),
  TypedReducer<WorkoutState, WorkoutNextInitializedAction>(_onNextInitialized),
  TypedReducer<WorkoutState, WorkoutPlayAction>(_onPlay),
  TypedReducer<WorkoutState, WorkoutPauseAction>(_onPause),
  TypedReducer<WorkoutState, WorkoutTickAction>(_onTick),
]);

WorkoutState _onInitializing(
        WorkoutState state, WorkoutStartInitializingAction action) =>
    state;

WorkoutState _onEmpty(WorkoutState state, WorkoutEmptyAction action) =>
    WorkoutEmpty();

WorkoutState _onError(WorkoutState state, WorkoutErrorAction action) =>
    WorkoutError(action.exception);

WorkoutState _onInitialized(
    WorkoutState state, WorkoutInitializedAction action) {
  WorkoutState _state = WorkoutLoaded(
      exercises: action.exercises,
      controller: action.controller,
      countdownTime: action.exercises[0].duration.toDouble(),
      delayTime: action.exercises[0].delay.toDouble(),
      playing: false,
      started: action.exercises[0].delay == 0 ? true : false);

  return _state;
}

WorkoutState _onNextInitializing(
        WorkoutState state, WorkoutInitNextAction action) =>
    state is WorkoutLoaded ? state.copyWith() : state;

WorkoutState _onNextInitialized(
        WorkoutState state, WorkoutNextInitializedAction action) =>
    state is WorkoutLoaded
        ? state.copyWith(
            controller: action.controller,
            playingIndex: action.playingIndex,
            countdownTime:
                state.exercises[action.playingIndex].duration.toDouble(),
            delayTime: state.exercises[action.playingIndex].delay.toDouble(),
            playing: false,
            started:
                state.exercises[action.playingIndex].delay == 0 ? true : false)
        : state;

WorkoutState _onPlay(WorkoutState state, WorkoutPlayAction action) =>
    state is WorkoutLoaded ? state.copyWith(playing: true) : state;

WorkoutState _onPause(WorkoutState state, WorkoutPauseAction action) =>
    state is WorkoutLoaded ? state.copyWith(playing: false) : state;

WorkoutState _onTick(WorkoutState state, WorkoutTickAction action) {
  if (state is WorkoutLoaded) {
    print(state.delayTime);
    var started = state.delayTime < 0.1 ? true : false;
    return state.copyWith(
        delayTime:
            !started ? state.delayTime - action.seconds : state.delayTime,
        countdownTime: started
            ? state.countdownTime - action.seconds
            : state.countdownTime,
        stopwatchTime: state.stopwatchTime + action.seconds,
        started: started);
  } else
    return state;
}
