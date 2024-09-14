import 'dart:async';
import 'package:app/Service/stream_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/Screens/error_page.dart';

class FaceScan extends StatefulWidget {
  const FaceScan({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<FaceScan> createState() => FaceScanState();
}

class FaceScanState extends State<FaceScan> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late StreamImage _stream;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888 // support iOS only
        );
    _initializeControllerFuture = _controller.initialize();
    _stream = StreamImage(
      onTimeout: invalidFaceVerification,
    );
    faceVerification();
  }

  Future<void> faceVerification() async {
    await _initializeControllerFuture;
    if (!mounted) {
      return;
    }

    _stream.start();
    print("========= start stream");
    _controller.startImageStream((image) async {
      _stream.stream(() {
        // TODO: stream image to backend
        print("========= stream");
      });
    });
  }

  void invalidFaceVerification() {
    print("========= invalid face scanning.");
    _controller
        .stopImageStream()
        .then((_) => Navigator.push(context, CupertinoPageRoute(builder: (_) {
              return const ErrorPage(
                  tabName: "Face Scan", message: "Invalid face scanning.");
            })));
  }

  @override
  void dispose() async {
    _controller.dispose();
    _stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Face Scan'),
        ),
        child: Center(
          widthFactor: double.infinity,
          heightFactor: double.infinity,
          child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) =>
                  (snapshot.connectionState == ConnectionState.done)
                      ? CameraPreview(_controller)
                      : const Center(child: CupertinoActivityIndicator())),
        ));
  }
}
