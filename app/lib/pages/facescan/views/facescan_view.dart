import 'package:app/pages/facescan/controllers/facescan_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FacescanView extends GetView<FacescanController> {
  const FacescanView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Face Scan'),
        ),
        child: Center(
            child: controller.obx(
                (_) => CameraPreview(controller.cameraController,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(Get.width, Get.height),
                          painter: _FaceScope(),
                        ),
                        Center(
                            child: ScaleTransition(
                          scale: controller.animation,
                          child: const Icon(
                            CupertinoIcons.check_mark_circled,
                            size: 160,
                            color: CupertinoColors.systemGreen,
                          ),
                        ))
                      ],
                    )),
                onLoading: const Center(child: CupertinoActivityIndicator()))));
  }
}

class _FaceScope extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black54.withOpacity(0.25);

    Rect outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    RRect outerRRect =
        RRect.fromRectAndRadius(outerRect, const Radius.circular(0));

    Rect innerRect = Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.5),
        width: size.width * 0.45,
        height: size.height * 0.45);
    RRect innerRRect =
        RRect.fromRectAndRadius(innerRect, const Radius.circular(18));

    canvas.drawDRRect(outerRRect, innerRRect, paint);
  }

  @override
  bool shouldRepaint(_FaceScope oldDelegate) {
    return false;
  }
}
