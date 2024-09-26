import 'package:app/pages/register/controllers/register_controller.dart';
import 'package:app/pages/review/controllers/review_controller.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class ReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<ReviewController>(() => ReviewController());
  }
}
