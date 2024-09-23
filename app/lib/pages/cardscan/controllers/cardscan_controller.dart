
import 'package:app/pages/register/controllers/register_controller.dart';
import 'package:app/pages/error/views/error_view.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as imglib;

class CardscanController extends GetxController with StateMixin {
  late CameraController cameraController;
  late Future<void> _initializeControllerFuture;
  final _isCameraEmpty = true.obs;
  static const imageWidth = 240;
  static const imageHeight = 360;

  @override
  void onInit() async {
    print("========= CardscanController on init");
    change(null, status: RxStatus.loading());
    await _initialCamera();
    super.onInit();
  }

  @override
  void onReady() async {
    print("========= CardscanController on ready");
    if (_isCameraEmpty()) return;
    await _initializeControllerFuture;
    print("========= CardscanController finished initial camera");
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

  Future<void> _initialCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      Get.off(const ErrorView(
        title: 'ID Card',
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

    update();
  }

  Future<void> takePicture() async {
    if (_isCameraEmpty()) return;
    await _initializeControllerFuture;

    final file = await cameraController.takePicture();
    final img = imglib.decodeJpg(await file.readAsBytes());
    final cropedImg = _cropImage(img!);

    RegisterController.to.idCard(cropedImg);
    Get.back();
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
