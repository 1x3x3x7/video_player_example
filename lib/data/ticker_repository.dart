import 'dart:async';

class TickerRepository {
  StreamSubscription? _ticksSubscription;

  Future<void> start(duration, listen) async {
    await _ticksSubscription?.cancel();
    _ticksSubscription = _ticks(duration).listen(listen);
  }

  Future<void> stop() async {
    await _ticksSubscription?.cancel();
  }

  Stream<int> _ticks(Duration duration) async* {
    yield* Stream.periodic(duration, (_) => duration.inSeconds);
  }
}
