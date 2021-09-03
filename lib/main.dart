import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:video_player_example/data/ticker_repository.dart';
import 'package:video_player_example/data/workout_repository.dart';
import 'package:video_player_example/presentation/video_screen.dart';
import 'package:video_player_example/redux/app_reducer.dart';
import 'package:video_player_example/redux/app_state.dart';
import 'package:video_player_example/redux/session_middleware.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final theme = ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class MyApp extends StatelessWidget {
  final tickerRepository = TickerRepository();
  final workoutRepository = WorkoutRepository();
  late final store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [SessionMiddleware(tickerRepository, workoutRepository)]);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Video Player',
        theme: theme,
        home: VideoScreen(),
      ),
    );
  }
}
