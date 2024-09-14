import 'dart:async';

import 'package:flutter/cupertino.dart';

class StreamImage {
  Timer? _timer;
  Timer? _debounce;
  VoidCallback? onTimeout;
  Duration? timeout;
  Duration? debounce;

  StreamImage({
    this.onTimeout,
    this.debounce = const Duration(milliseconds: 500),
    this.timeout = const Duration(seconds: 6)
  });

  void start() {
    cancel();
    _timer = Timer(timeout!, () {
      if (onTimeout != null) onTimeout!();
      if (_isActive(_debounce)) _debounce?.cancel();
    });
  }

  void cancel() {
    if (_isActive(_timer)) _timer?.cancel();
    if (_isActive(_debounce)) _debounce?.cancel();
  }

  void stream(VoidCallback callback) {
    if (!_isActive(_timer) || _isActive(_debounce)) return;
    _debounce = Timer(debounce!, () {
      callback();
    });
  }

  bool _isActive(Timer? t) => t?.isActive ?? false;
}
