import 'package:video_player_example/data/app_client.dart';
import 'package:video_player_example/domain/workout_response.dart';

class WorkoutRepository {
  final AppClient appClient;
  WorkoutRepository(
    this.appClient,
  );

  Future<WorkoutResponse> loadWorkout(int id) async =>
      WorkoutResponse.fromJson(await appClient.get('workout?id=$id'));

  Future doneWorkout() => Future.wait<dynamic>([]);
  Future loadWorkouts(type) => Future.wait<dynamic>([]);
  Future loadDetail(id) => Future.wait<dynamic>([]);
  Future loadActivity(date) => Future.wait<dynamic>([]);
  Future addActivity(data) => Future.wait<dynamic>([]);
}
