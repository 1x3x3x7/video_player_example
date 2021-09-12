import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:video_player_example/domain/api_response.dart';
import 'package:video_player_example/domain/workout_response.dart';
import 'package:video_player_example/presentation/common/app_error_widget.dart';
import 'package:video_player_example/presentation/common/app_loading_widget.dart';
import 'package:video_player_example/presentation/session/workout_widget.dart';
import 'package:video_player_example/redux/app/app_state.dart';
import 'package:video_player_example/redux/session/session_actions.dart';

class SessionScreen extends StatelessWidget {
  SessionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SessionScreenViewModel>(
      onInit: (store) {
        store.dispatch(SessionLoadAction(1337));
      },
      converter: (store) => _SessionScreenViewModel.fromStore(store),
      builder: (context, vm) => Scaffold(
          appBar: AppBar(
            title: Text("Session"),
          ),
          body: buildWidget(vm)),
    );
  }

  buildWidget(_SessionScreenViewModel vm) {
    switch (vm.response.status) {
      case Status.LOADING:
        return Center(
            child: AppLoadingWidget(loadingMessage: vm.response.message));
      case Status.ERROR:
        return Center(
            child: AppErrorWidget(
                onRetryPressed: () => vm.onLoad(vm.id),
                errorMessage: vm.response.message));
      case Status.COMPLETED:
        return WorkoutWidget(exercises: vm.response.data?.exercises ?? []);
      default:
        throw ArgumentError('No argument ${vm.response.status}');
    }
  }
}

class _SessionScreenViewModel {
  final ApiResponse<WorkoutResponse> response;
  final Function onLoad;
  final int id;

  _SessionScreenViewModel(
      {required this.onLoad, required this.id, required this.response});

  static _SessionScreenViewModel fromStore(Store<AppState> store) {
    return _SessionScreenViewModel(
      onLoad: (id) => store.dispatch(SessionLoadAction(id)),
      id: store.state.sessionState.id,
      response: store.state.sessionState.response,
    );
  }
}
