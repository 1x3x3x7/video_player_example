import 'package:flutter/material.dart';

class ThumbnailWidget extends StatelessWidget {
  final double aspectRatio;
  final String url;

  const ThumbnailWidget(
      {Key? key, required this.aspectRatio, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      AspectRatio(aspectRatio: aspectRatio, child: Image.network(url));
}
