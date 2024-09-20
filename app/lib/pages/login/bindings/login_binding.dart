import 'package:app/services/api_service.dart';
import 'package:app/services/auth_service.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    print('========= LoginBinding start binding');
    // Get.put<AuthService>(AuthService());
    // Get.putAsync<AuthService>(() async => await AuthService().loaded());
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
