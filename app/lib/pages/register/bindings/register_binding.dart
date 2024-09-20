import 'package:app/pages/register/controllers/register_controller.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/auth_service.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put<AuthService>(AuthService());
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
