extension IntExtensions on int {
  String stopwatch() {
    String minutes = (this ~/ 60).toString().padLeft(2, '0');
    String seconds = (this % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
