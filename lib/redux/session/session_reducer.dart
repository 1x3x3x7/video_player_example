import 'package:redux/redux.dart';
import 'package:video_player_example/redux/session/session_actions.dart';
import 'package:video_player_example/redux/session/session_state.dart';

final sessionReducer = combineReducers<SessionState>([
  TypedReducer<SessionState, SessionLoadAction>(_onLoad),
  TypedReducer<SessionState, SessionLoadedAction>(_onLoaded),
]);

SessionState _onLoad(SessionState state, SessionLoadAction action) =>
    state.copyWith(id: action.id);

SessionState _onLoaded(SessionState state, SessionLoadedAction action) =>
    state.copyWith(response: action.data);
