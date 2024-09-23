import 'package:app/pages/cardscan/controllers/cardscan_controller.dart';
import 'package:app/pages/register/controllers/register_controller.dart';
import 'package:get/get.dart';

class CardscanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<CardscanController>(() => CardscanController());
  }
}