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
