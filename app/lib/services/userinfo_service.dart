import 'package:app/models/coperate.dart';
import 'package:app/models/user.dart';
import 'package:get/get.dart';

class UserInfoService extends GetxService {
  static UserInfoService get to => Get.find<UserInfoService>();
  final user = User().obs;
  final lat = 0.0.obs;
  final long = 0.0.obs;
  final site =  const Site().obs;
}
