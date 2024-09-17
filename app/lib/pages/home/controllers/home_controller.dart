import 'dart:convert';

import 'package:app/apis/auth.dart';
import 'package:app/models/user.dart';
import 'package:app/pages/error/views/error_view.dart';
import 'package:app/services/auth_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with StateMixin<User> {
  // AuthService get authService => AuthService.to;

  final _storage = const FlutterSecureStorage();

  @override
  void onInit() async {
    // await _storage.delete(key: 'access_token');

    print('========= HomeController on init');
    change(null, status: RxStatus.loading());

    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      await Get.offNamed('/login');
      print('========= HomeController finished login');
      return;
    }
    AuthService.to.token(token);

    await loadUser(token);

    super.onInit();
  }

  Future<void> loadUser(String token) async {
    try {
      final response = await fetchUser(token);

      if (response.statusCode >= 400 && response.statusCode < 500) {
        change(null, status: RxStatus.empty());
        await Get.offNamed('/login');
        return;
      }
      if (response.statusCode >= 500) {
        change(null,
            status: RxStatus.error(
                'Something went wrong,\nPlease try again later.'));
        return;
      }

      final body = json.decode(response.body) as Map<String, dynamic>;
      final user = User.fromJson(body);
      AuthService.to.user(user);
      AuthService.to.isAuth(true);

      change(user, status: RxStatus.success());
      return;
    } catch (e) {
      change(null,
          status:
              RxStatus.error('Something went wrong,\nPlease try again later.'));
      return;
    }
  }

  void gotoFaceScan() {
    availableCameras().then((cameras) {
      if (cameras.isEmpty) {
        Get.to(const ErrorView(
          title: 'Face Scan',
          message: 'No camera available.',
        ));
        return;
      }

      final camera = cameras.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first);

      print('Go to FaceScan');
    });
  }
}
