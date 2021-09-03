import 'dart:convert';

class Exercise {
  String title;
  String url;
  String thumbnail;
  int duration;
  int delay;

  Exercise(
      {required this.title,
      required this.url,
      required this.thumbnail,
      required this.duration,
      required this.delay});

  Map<String, dynamic> toMap() => {
        'title': title,
        'url': url,
        'thumbnail': thumbnail,
        'duration': duration,
        'delay': delay,
      };

  String toJson() => json.encode(toMap());

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
        title: map['title'],
        url: map['url'],
        thumbnail: map['thumbnail'],
        duration: map['duration'],
        delay: map['delay'],
      );

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source));

  @override
  String toString() => '${const JsonEncoder.withIndent(' ').convert(this)}';
}
