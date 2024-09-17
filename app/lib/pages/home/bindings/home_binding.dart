import 'package:app/services/auth_service.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    print('========= HomeBinding start binding');
    // Get.put<AuthService>(AuthService());
    // Get.putAsync<AuthService>(() async => await AuthService().loaded());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
