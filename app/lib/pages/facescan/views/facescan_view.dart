import 'package:app/pages/facescan/controllers/facescan_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
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
            widthFactor: double.infinity,
            heightFactor: double.infinity,
            child: controller.obx(
                (_) => CameraPreview(controller.cameraController),
                onLoading: const Center(child: CupertinoActivityIndicator()))));
  }
}
