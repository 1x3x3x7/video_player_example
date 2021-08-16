import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_example/exercise.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final theme = ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player',
      theme: theme,
      home: VideoScreen(),
    );
  }
}

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video"),
      ),
      body: VideoWidget(),
    );
  }
}

class VideoWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoWidgetState();
  }
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _controller;
  var videoClips = exercises;
  Duration? _duration;
  Duration? _position;
  var _playingIndex = -1;
  var _disposed = false;
  var _playing = false;
  var _isEndOfClip = false;
  var _trainingSeconds = 0;
  PausableTimer? exerciseTimer;
  PausableTimer? trainingTimer;
  bool get _isPlaying {
    return _playing;
  }

  set _isPlaying(bool value) {
    _playing = value;
  }

  String get exerciseTimerText => exerciseTimer != null
      ? '${((exerciseTimer!.duration.inSeconds - exerciseTimer!.elapsed.inSeconds) ~/ 60).toString().padLeft(2, '0')}:${((exerciseTimer!.duration.inSeconds - exerciseTimer!.elapsed.inSeconds) % 60).toString().padLeft(2, '0')}'
      : "00:00";

  String get trainingTimerText =>
      '${((_trainingSeconds) ~/ 60).toString().padLeft(2, '0')}:${((_trainingSeconds) % 60).toString().padLeft(2, '0')}';

  @override
  void initState() {
    _initializeAndPlay(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTrainingTime(),
              _buildPlayButton(),
            ],
          ),
          _controller != null && _controller!.value.isInitialized
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      _buildPlayer(),
                      Align(
                          alignment: Alignment.topLeft, child: _buildOverplay())
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    return AspectRatio(
      aspectRatio: 1,
      child: VideoPlayer(_controller!),
    );
  }

  Widget _buildOverplay() {
    return Card(
      color: Color(0x01000000),
      margin: EdgeInsets.all(8),
      child: Container(
        margin: EdgeInsets.all(4),
        height: 68,
        width: 86,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              videoClips[_playingIndex].title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              exerciseTimerText,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingTime() => Text(
        trainingTimerText,
        style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
      );

  Widget _buildPlayButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          if (_controller != null && _controller!.value.isPlaying) {
            _controller!.pause();
            exerciseTimer?.pause();
            trainingTimer?.pause();
          } else {
            if (exerciseTimer != null && !exerciseTimer!.isExpired) {
              _controller!.play();
              exerciseTimer?.start();
              trainingTimer?.start();
            }
          }
        });
      },
      icon: Icon(
        _controller != null && _controller!.value.isPlaying
            ? Icons.pause
            : Icons.play_arrow,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
    _controller?.pause(); // mute instantly
    _controller?.dispose();
    _controller = null;
    exerciseTimer?.cancel();
    trainingTimer?.cancel();
  }

  void _initializeAndPlay(int index) async {
    print("_initializeAndPlay ---------> $index");
    final clip = videoClips[index];

    final controller = VideoPlayerController.network(clip.url);

    VideoPlayerController? old = _controller;
    _controller = controller;
    if (old != null) {
      old.removeListener(_onControllerUpdated);
      old.pause();
      debugPrint("---- old contoller paused.");
    }

    debugPrint("---- controller changed.");
    setState(() {});

    controller
      ..initialize().then((_) {
        debugPrint("---- controller initialized");
        old?.dispose();
        _playingIndex = index;
        _duration = null;
        _position = null;
        controller.addListener(_onControllerUpdated);
        controller.setLooping(true);
        Future.delayed(const Duration(seconds: 3), () {
          _play();
        });
      });
  }

  void _play() {
    _controller?.play();
    exerciseTimer?.cancel();
    exerciseTimer = PausableTimer(
        Duration(seconds: videoClips[_playingIndex].duration), () {
      final isComplete = _playingIndex == videoClips.length - 1;
      if (isComplete) {
        _controller?.pause();
        exerciseTimer?.cancel();
        trainingTimer?.cancel();
        print("played all2!!");
      } else {
        _initializeAndPlay(_playingIndex + 1);
      }
    })
      ..start();
    trainingTimer = PausableTimer(Duration(seconds: 1), () {
      _trainingSeconds++;
      trainingTimer!
        ..reset()
        ..start();
    })
      ..start();
    setState(() {});
  }

  var _updateProgressInterval = 0.0;
  void _onControllerUpdated() async {
    if (_disposed) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_updateProgressInterval > now) {
      return;
    }
    // Skip too many updates
    _updateProgressInterval = now + 150.0;
    setState(() {
      debugPrint("exerciseTimer elapsed = ${exerciseTimer?.elapsed}");
    });

    final controller = _controller;
    if (controller == null) return;
    if (!controller.value.isInitialized) return;
    if (_duration == null) {
      _duration = _controller!.value.duration;
    }
    var duration = _duration;
    if (duration == null) return;

    var position = await controller.position;
    _position = position;
    final playing = controller.value.isPlaying;
    final isEndOfClip = position!.inMilliseconds > 0 &&
        position.inSeconds + 1 >= duration.inSeconds;
    // handle clip end
    if (_isPlaying != playing || _isEndOfClip != isEndOfClip) {
      _isPlaying = playing;
      _isEndOfClip = isEndOfClip;
      debugPrint(
          "updated -----> isPlaying=$playing / isEndOfClip=$isEndOfClip");
      if (isEndOfClip && !playing) {
        debugPrint(
            "========================== End of Clip / Handle NEXT ========================== ");
        final isComplete = _playingIndex == videoClips.length - 1;
        if (isComplete) {
          print("played all!!");
        } else {
          // _initializeAndPlay(_playingIndex + 1);
        }
      }
    }
  }
}
