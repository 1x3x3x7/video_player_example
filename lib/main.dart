import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';
import 'package:video_player_example/common/app_routes.dart';
import 'package:video_player_example/common/extensions.dart';
import 'package:video_player_example/common/tts_controller.dart';
import 'package:video_player_example/data/ticker_repository.dart';
import 'package:video_player_example/data/workout_repository.dart';
import 'package:video_player_example/presentation/session/session_screen.dart';
import 'package:video_player_example/presentation/session_end/session_end_screen.dart';
import 'package:video_player_example/redux/app/app_reducer.dart';
import 'package:video_player_example/redux/app/app_state.dart';
import 'package:video_player_example/redux/session/session_middleware.dart';
import 'package:video_player_example/redux/session/workout/workout_middleware.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final theme = ThemeData(
  primarySwatch: Colors.blueGrey,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class MyApp extends StatelessWidget {
  final tickerRepository = TickerRepository();
  final workoutRepository = WorkoutRepository();
  final ttsController = TtsController();
  late final store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [
        const NavigationMiddleware<AppState>(),
        SessionMiddleware(workoutRepository),
        WorkoutMiddleware(tickerRepository, workoutRepository, ttsController)
      ]);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Video Player',
        theme: theme,
        navigatorKey: NavigatorHolder.navigatorKey,
        onGenerateRoute: _getRoute,
      ),
    );
  }

  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.session_screen:
        return SessionScreen().buildRoute(settings);
      case AppRoutes.session_end_screen:
        return SessionEndScreen(minutes: settings.arguments as String)
            .buildRoute(settings);
      default:
        throw ArgumentError('No agrument ${settings.name}');
    }
  }
}
