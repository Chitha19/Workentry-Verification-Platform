import 'package:app/Service/stream_image.dart';
import 'package:app/pages/error/views/error_view.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class FacescanController extends GetxController with StateMixin {
  late CameraController cameraController;
  late StreamImage _streamController;
  late Future<void> _initializeControllerFuture;

  @override
  void onInit() async {
    print("========= FacescanController onInit");
    change(null, status: RxStatus.loading());

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      Get.off(const ErrorView(
        title: 'Face Scan',
        message: 'No camera available.',
      ));
      return;
    }
    final camera = cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first);

    cameraController = CameraController(camera, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888 // support iOS only
        );

    _initializeControllerFuture = cameraController.initialize();

    _streamController = StreamImage(
      onTimeout: invalidFaceVerification,
    );
    
    super.onInit();
  }

  @override
  void onReady() async {
    print("========= FacescanController onReady");
    await _initializeControllerFuture;
    _streamController.start();
    print("========= FacescanController start stream");
    cameraController.startImageStream((image) async {
      _streamController.stream(() {
        print("========= FacescanController stream");
      });
    });
    super.onReady();
    update();
    change(null, status: RxStatus.success());
  }

  @override
  void onClose() async {
    await _initializeControllerFuture;
    cameraController.dispose();
    _streamController.cancel();
    super.onClose();
  }

  void invalidFaceVerification() async {
    await _initializeControllerFuture;
    await cameraController.stopImageStream();
    Get.off(const ErrorView(
      title: 'Face Scan',
      message: 'Invalid face scanning.',
    ));
  }
}
