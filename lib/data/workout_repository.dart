import 'package:video_player_example/data/exercise.dart';

class WorkoutRepository {
  Future<List<Exercise>> loadWorkout(int id) async {
    return await Future.delayed(
        Duration(seconds: 1),
        () => [
              Exercise(
                  title: 'Front lunge',
                  url:
                      'https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/front_lunge/playlist.m3u8',
                  thumbnail:
                      'https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/front_lunge/thumbnail.jpg',
                  duration: 5,
                  delay: 3),
              Exercise(
                  title: 'Hip circles',
                  url:
                      'https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/hip_circles/playlist.m3u8',
                  thumbnail:
                      'https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/hip_circles/thumbnail.jpg',
                  duration: 5,
                  delay: 3),
              Exercise(
                  title: 'Pike stretch',
                  url:
                      'https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/pike_stretch/playlist.m3u8',
                  thumbnail:
                      'https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/pike_stretch/thumbnail.jpg',
                  duration: 5,
                  delay: 3)
            ]);
  }

  Future doneWorkout() => Future.wait<dynamic>([]);
}
