// import 'dart:ui';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:app/pages/error/views/error_view.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as imglib;

class CardscanController extends GetxController with StateMixin {
  late CameraController cameraController;
  late Future<void> _initializeControllerFuture;
  late imglib.Image idCard;
  final _isCameraEmpty = true.obs;
  static const imageWidth = 440;
  static const imageHeight = 540;

  @override
  void onInit() {
    print("========= FacescanController on init");
    change(null, status: RxStatus.loading());
    _initialCamera();
    super.onInit();
  }

  @override
  void onReady() async {
    if (_isCameraEmpty()) return;
    await _initializeControllerFuture;

    change(null, status: RxStatus.success());

    super.onReady();
  }

  @override
  void onClose() async {
    if (_isCameraEmpty()) return;
    await _initializeControllerFuture;
    cameraController.dispose();

    super.onClose();
  }

  void _initialCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      Get.off(const ErrorView(
        title: 'Face Scan',
        message: 'No camera available.',
      ));
      return;
    }

    final camera = cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first);

    _isCameraEmpty(false);

    cameraController = CameraController(camera, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888 // support iOS only
        );

    _initializeControllerFuture = cameraController.initialize();
  }

  Future<void> takePicture() async {
    if (_isCameraEmpty()) return;
    await _initializeControllerFuture;

    final raw = await cameraController.takePicture();
    final imgBytes = await raw.readAsBytes();
    final imgInfo = await decodeImageFromList(imgBytes);
    final img = _convertBGRA8888ToImage(imgInfo, imgBytes);
    final cropedImg = _cropImage(img);
    
    idCard = cropedImg;
    update();
  }

  imglib.Image _convertBGRA8888ToImage(Image image, Uint8List imageBytes) {
    return imglib.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: imageBytes.buffer,
      order: imglib.ChannelOrder.bgra,
    );
  }

  imglib.Image _cropImage(imglib.Image image) {
    final centerX = image.width ~/ 2;
    final centerY = image.height ~/ 2;

    final x = centerX - (imageWidth ~/ 2);
    final y = centerY - (imageHeight ~/ 2);

    return imglib.copyCrop(image,
        x: x, y: y, width: imageWidth, height: imageHeight);
  }
}
