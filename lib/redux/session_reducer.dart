import 'package:redux/redux.dart';
import 'package:video_player_example/redux/session_actions.dart';
import 'package:video_player_example/redux/session_state.dart';

final sessionReducer = combineReducers<SessionState>([
  TypedReducer<SessionState, SessionStartInitializingAction>(_onLoad),
  TypedReducer<SessionState, SessionErrorAction>(_onError),
  TypedReducer<SessionState, SessionInitializedAction>(_onResult),
  TypedReducer<SessionState, SessionInitNextAction>(_onNext),
  TypedReducer<SessionState, SessionNextInitializedAction>(_onNextInitialized),
  TypedReducer<SessionState, SessionPlayAction>(_onPlay),
  TypedReducer<SessionState, SessionPauseAction>(_onPause),
  TypedReducer<SessionState, SessionEndAction>(_onEnd),
  TypedReducer<SessionState, SessionTickAction>(_onTick),
]);

SessionState _onLoad(
        SessionState state, SessionStartInitializingAction action) =>
    SessionLoading();

SessionState _onError(SessionState state, SessionErrorAction action) =>
    SessionError();

SessionState _onResult(SessionState state, SessionInitializedAction action) {
  SessionState _state = SessionLoaded(
      exercises: action.exercises,
      controller: action.controller,
      countdownTime: action.exercises[0].duration.toDouble(),
      playing: true);

  return _state;
}

SessionState _onNext(SessionState state, SessionInitNextAction action) =>
    state is SessionLoaded ? state.copyWith() : state;

SessionState _onNextInitialized(
        SessionState state, SessionNextInitializedAction action) =>
    state is SessionLoaded
        ? state.copyWith(
            controller: action.controller,
            playingIndex: action.playingIndex,
            countdownTime:
                state.exercises[action.playingIndex].duration.toDouble(),
            playing: true)
        : state;

SessionState _onPlay(SessionState state, SessionPlayAction action) =>
    state is SessionLoaded ? state.copyWith(playing: true) : state;

SessionState _onPause(SessionState state, SessionPauseAction action) =>
    state is SessionLoaded ? state.copyWith(playing: false) : state;

SessionState _onEnd(SessionState state, SessionEndAction action) =>
    SessionEnd(action.seconds);

SessionState _onTick(SessionState state, SessionTickAction action) {
  if (state is SessionLoaded) {
    return state.copyWith(
        countdownTime: state.countdownTime - action.seconds,
        stopwatchTime: state.stopwatchTime + action.seconds);
  } else
    return state;
}
