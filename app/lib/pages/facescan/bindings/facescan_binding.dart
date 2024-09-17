import 'package:app/pages/facescan/controllers/facescan_controller.dart';
import 'package:app/pages/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class FacescanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FacescanController>(() => FacescanController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
