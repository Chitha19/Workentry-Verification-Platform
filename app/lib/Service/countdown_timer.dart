import 'dart:async';

import 'package:flutter/cupertino.dart';

class CountdownTimer {
  late Timer _timer;
  final Duration _countdownSeconds;
  final VoidCallback? _onFinished;

  CountdownTimer({
    required Duration seconds,
    Function()? onFinished,
  })  : _countdownSeconds = seconds,
        _onFinished = onFinished;

  void start() {
    _timer = Timer.periodic(_countdownSeconds, (timer) {
      if (_onFinished != null) {
        _onFinished();
      }
    });
  }

  void stop() {
    _timer.cancel();
  }

  void reset() {
    stop();
    start();
  }
}
