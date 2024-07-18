import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class Throttler {
  Throttler({required this.milliSeconds});

  final int milliSeconds;

  int? lastActionTime;

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      action();
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! >
          (milliSeconds)) {
        action();
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}

class FaceScan extends StatefulWidget {
  const FaceScan({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<FaceScan> createState() => FaceScanState();
}

class FaceScanState extends State<FaceScan> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late Throttler throttler;
  late StreamSubscription<int> timer;

  @override
  void initState() {
    super.initState();
    throttler = Throttler(milliSeconds: 500);
    _controller = CameraController(widget.camera, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888 // support iOS only
        );
    _initializeControllerFuture = _controller.initialize();
    faceVerification();
  }

  Future<void> faceVerification() async {
    await _initializeControllerFuture;
    if (!mounted) {
      return;
    }

    // setState(() {});
    Future.delayed(const Duration(milliseconds: 500));
    
    timer = Stream.periodic(const Duration(milliseconds: 500), (v) => v).listen((count) async {
      throttler.run(() async {
        _controller.startImageStream((image) async {
          // TODO: stream image to backend
        });

        Future.delayed(const Duration(milliseconds: 50), () async {
          await _controller.stopImageStream();
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Face Scan'),
        ),
        child: Center(
          // widthFactor: MediaQuery.of(context).size.width,
          // heightFactor: MediaQuery.of(context).size.height,
          child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) =>
                  (snapshot.connectionState == ConnectionState.done)
                      ? CameraPreview(_controller)
                      : const Center(child: CupertinoActivityIndicator())),
        ));
  }
}
