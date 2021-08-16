import 'dart:convert';

class Exercise {
  String title;
  String url;
  int duration;
  Exercise({required this.title, required this.url, required this.duration});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'duration': duration,
    };
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      title: map['title'],
      url: map['url'],
      duration: map['duration'],
    );
  }

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source));

  @override
  String toString() {
    return '${const JsonEncoder.withIndent(' ').convert(this)}';
  }
}

List<Exercise> exercises = [
  Exercise(
      title: 'Front lunge',
      url:
          'https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/front_lunge/playlist.m3u8',
      duration: 15),
  Exercise(
      title: 'Hip circles',
      url:
          'https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/hip_circles/playlist.m3u8',
      duration: 15),
  Exercise(
      title: 'Pike stretch',
      url:
          'https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/pike_stretch/playlist.m3u8',
      duration: 15),
];
