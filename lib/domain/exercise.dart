class Exercise {
  Exercise({
    required this.title,
    required this.url,
    required this.thumbnail,
    required this.duration,
    required this.delay,
  });

  String title;
  String url;
  String thumbnail;
  int duration;
  int delay;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        title: json["title"],
        url: json["url"],
        thumbnail: json["thumbnail"],
        duration: json["duration"],
        delay: json["delay"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "thumbnail": thumbnail,
        "duration": duration,
        "delay": delay,
      };
}
