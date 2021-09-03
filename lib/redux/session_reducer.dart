import 'package:redux/redux.dart';
import 'package:video_player_example/redux/session_actions.dart';
import 'package:video_player_example/redux/session_state.dart';

final sessionReducer = combineReducers<SessionState>([
  TypedReducer<SessionState, SessionStartInitializingAction>(_onInitializing),
  TypedReducer<SessionState, SessionErrorAction>(_onError),
  TypedReducer<SessionState, SessionInitializedAction>(_onInitialized),
  TypedReducer<SessionState, SessionInitNextAction>(_onNextInitializing),
  TypedReducer<SessionState, SessionNextInitializedAction>(_onNextInitialized),
  TypedReducer<SessionState, SessionPlayAction>(_onPlay),
  TypedReducer<SessionState, SessionPauseAction>(_onPause),
  TypedReducer<SessionState, SessionEndAction>(_onEnd),
  TypedReducer<SessionState, SessionTickAction>(_onTick),
]);

SessionState _onInitializing(
        SessionState state, SessionStartInitializingAction action) =>
    SessionLoading();

SessionState _onError(SessionState state, SessionErrorAction action) =>
    SessionError();

SessionState _onInitialized(
    SessionState state, SessionInitializedAction action) {
  SessionState _state = SessionLoaded(
      exercises: action.exercises,
      controller: action.controller,
      countdownTime: action.exercises[0].duration.toDouble(),
      delayTime: action.exercises[0].delay.toDouble(),
      playing: false);

  return _state;
}

SessionState _onNextInitializing(
        SessionState state, SessionInitNextAction action) =>
    state is SessionLoaded ? state.copyWith() : state;

SessionState _onNextInitialized(
        SessionState state, SessionNextInitializedAction action) =>
    state is SessionLoaded
        ? state.copyWith(
            controller: action.controller,
            playingIndex: action.playingIndex,
            countdownTime:
                state.exercises[action.playingIndex].duration.toDouble(),
            delayTime: state.exercises[action.playingIndex].delay.toDouble(),
            playing: false,
            started: false)
        : state;

SessionState _onPlay(SessionState state, SessionPlayAction action) =>
    state is SessionLoaded ? state.copyWith(playing: true) : state;

SessionState _onPause(SessionState state, SessionPauseAction action) =>
    state is SessionLoaded ? state.copyWith(playing: false) : state;

SessionState _onEnd(SessionState state, SessionEndAction action) =>
    SessionEnd(action.seconds);

SessionState _onTick(SessionState state, SessionTickAction action) {
  if (state is SessionLoaded) {
    print(state.delayTime);
    return state.copyWith(
        delayTime:
            !state.started ? state.delayTime - action.seconds : state.delayTime,
        countdownTime: state.started
            ? state.countdownTime - action.seconds
            : state.countdownTime,
        stopwatchTime: state.stopwatchTime + action.seconds,
        started: state.delayTime < 0.1 ? true : false);
  } else
    return state;
}
