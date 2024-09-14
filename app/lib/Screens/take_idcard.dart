import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:app/States/register_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TakeIDCard extends StatefulWidget {
  const TakeIDCard({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<TakeIDCard> createState() => _TakeIDCardState();
}

class _TakeIDCardState extends State<TakeIDCard> {
  late CameraController _controller;
  late Future<void> _initializeController;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888 // support iOS only
        );
    _initializeController = _controller.initialize();
  }

  @override
  void dispose() async {
    _controller.dispose();
    super.dispose();
  }

  void _takePhoto() async {
    try {
      await _initializeController;

      XFile image = await _controller.takePicture();

      if (!mounted) return;

      RegisterForm form = Provider.of<RegisterForm>(context, listen: false);
      form.card = image;

      Navigator.pop(context, true);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MaterialButton(
          onPressed: _takePhoto,
          color: Colors.blue,
          textColor: Colors.white,
          padding: const EdgeInsets.all(18),
          shape: const CircleBorder(),
          child: const Icon(
            CupertinoIcons.camera,
            size: 44,
          ),
        ),
        body: CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('ID Card'),
            ),
            child: Center(
              widthFactor: double.infinity,
              heightFactor: double.infinity,
              child: FutureBuilder<void>(
                  future: _initializeController,
                  builder: (context, snapshot) {
                    // if (snapshot.hasError) {
                    //   return const Center(
                    //       child: Text(
                    //           "Somthing went wrong. Please try again later.",
                    //           style: TextStyle(
                    //               fontSize: 24.0,
                    //               fontWeight: FontWeight.bold)));
                    // }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_controller);
                    }
                    return const Center(child: CupertinoActivityIndicator());
                  }),
            )));
  }
}
