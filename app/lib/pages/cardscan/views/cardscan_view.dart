import 'package:app/pages/cardscan/controllers/cardscan_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardscanView extends GetView<CardscanController> {
  const CardscanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MaterialButton(
          onPressed: controller.takePicture,
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
                child: controller.obx(
                    (_) => CameraPreview(
                          controller.cameraController,
                          child: CustomPaint(
                            size: Size(Get.width, Get.height),
                            painter: _CardScope(),
                          ),
                        ),
                    onLoading:
                        const Center(child: CupertinoActivityIndicator())))));
  }
}

class _CardScope extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black54.withOpacity(0.25);

    Rect outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    RRect outerRRect =
        RRect.fromRectAndRadius(outerRect, const Radius.circular(0));

    Rect innerRect = Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.5),
        width: size.width * 0.65,
        height: size.height * 0.65);
    RRect innerRRect =
        RRect.fromRectAndRadius(innerRect, const Radius.circular(18));

    canvas.drawDRRect(outerRRect, innerRRect, paint);
  }

  @override
  bool shouldRepaint(_CardScope oldDelegate) {
    return false;
  }
}
