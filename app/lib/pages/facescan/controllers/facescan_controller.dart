import 'package:app/Service/stream_image.dart';
import 'package:app/pages/error/views/error_view.dart';
import 'package:app/services/api_service.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:image/image.dart' as imglib;

class FacescanController extends GetxController with StateMixin {
  late CameraController cameraController;
  late StreamImage _streamController;
  late Future<void> _initializeControllerFuture;
  late IOWebSocketChannel _channel;
  final _isCameraEmpty = true.obs;

  @override
  void onInit() async {
    print("========= FacescanController onInit");
    change(null, status: RxStatus.loading());
    await _initialStream();
    super.onInit();
  }

  @override
  void onReady() async {
    print("========= FacescanController onReady");
    super.onReady();
    _startStreaming();
  }

  @override
  void onClose() async {
    super.onClose();
    await _closeAll();
  }

  Future<void> _initialStream() async {
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

    _isCameraEmpty(false);

    cameraController = CameraController(camera, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888 // support iOS only
        );

    _initializeControllerFuture = cameraController.initialize();

    _streamController = StreamImage(
      onTimeout: _invalidVerified,
    );

    _channel = await ApiService.to.getFaceVerificationChannel();
  }

  void _startStreaming() async {
    if (_isCameraEmpty()) return;
    await _initializeControllerFuture;

    _listenForVerified();

    _streamController.start();
    print("========= FacescanController start stream");
    cameraController.startImageStream((image) async {
      _streamController.stream(() {
        print("========= FacescanController stream");
        final raw = _convertBGRA8888ToImage(image);
        final cropedImg = _cropImage(raw);
        final img = imglib.encodeJpg(cropedImg);
        _channel.sink.add(img);
      });
    });
    update();

    change(null, status: RxStatus.success());
  }

  void _listenForVerified() async {
    _channel.stream.listen((_) {
      print("========= FacescanController stream verified.");
      _streamController.cancel();
      _channel.sink.close();
    }, onDone: () {
      print("========= FacescanController stream on done.");
      _streamController.cancel();
      _channel.sink.close();
    }, onError: (error) {
      print("========= FacescanController stream on error.");
      _streamController.cancel();
      _channel.sink.close();
    });
  }

  void _invalidVerified() async {
    // await _closeAll();
    Get.off(const ErrorView(
      title: 'Face Scan',
      message: 'Invalid face scanning.',
    ));
  }

  Future<void> _closeAll() async {
    if (_isCameraEmpty()) return;

    await _initializeControllerFuture;

    cameraController.dispose();
    _streamController.cancel();
    _channel.sink.close();
  }

  imglib.Image _convertBGRA8888ToImage(CameraImage cameraImage) {
    return imglib.Image.fromBytes(
      width: cameraImage.planes.first.width!,
      height: cameraImage.planes.first.height!,
      bytes: cameraImage.planes.first.bytes.buffer,
      order: imglib.ChannelOrder.bgra,
    );
  }

  imglib.Image _cropImage(imglib.Image image) {
    final centerX = image.width ~/ 2;
    final centerY = image.height ~/ 2;

    const width = 220;
    const height = 260;
    final x = centerX - (width ~/ 2);
    final y = centerY - (height ~/ 2);

    return imglib.copyCrop(image, x: x, y: y, width: width, height: height);
  }
}
