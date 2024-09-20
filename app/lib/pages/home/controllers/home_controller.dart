import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/services/api_service.dart';
// import 'package:app/pages/error/views/error_view.dart';
import 'package:app/services/auth_service.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with StateMixin<User> {
  // AuthService get authService => AuthService.to;

  // final _storage = const FlutterSecureStorage();

  @override
  void onInit() async {
    // await _storage.delete(key: 'access_token');

    print('========= HomeController on init');

    change(null, status: RxStatus.loading());

    ApiService.to.getUser().then((response) {
      if (response.status.isOk) {
        print('========= HomeController get user ok');
        final body = json.decode(response.bodyString!) as Map<String, dynamic>;
        final user = User.fromJson(body);
        AuthService.to.user(user);
        AuthService.to.isAuth(true);
        change(AuthService.to.user(), status: RxStatus.success());
        return;
      }

      print('========= HomeController get user error');
      change(null,
          status:
              RxStatus.error('Something went wrong,\nPlease try again later.'));
    }).onError((error, stackTrace) {
      print('========= HomeController get user on error $error');
      change(null,
          status:
              RxStatus.error('Something went wrong,\nPlease try again later.'));
    });

    super.onInit();
  }

  void gotoFaceScan() {
    print('Go to FaceScan');
  }
}
