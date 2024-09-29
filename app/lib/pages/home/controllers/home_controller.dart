import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/pages/error/views/error_view.dart';
import 'package:app/services/api_service.dart';
// import 'package:app/pages/error/views/error_view.dart';
// import 'package:app/services/auth_service.dart';
import 'package:app/services/userinfo_service.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends GetxController with StateMixin<User> {
  // ApiService get apiService => ApiService.to;

  // final _storage = const FlutterSecureStorage();
  // late Position _currentPosition;

  @override
  void onInit() async {
    print('========= HomeController on init');

    change(null, status: RxStatus.loading());

    super.onInit();
  }

  @override
  void onReady() {
    print('========= HomeController on ready');

    ApiService.to.getUser().then((response) {
      if (response.status.isOk) {
        print('========= HomeController get user ok');
        final body = json.decode(response.bodyString!) as Map<String, dynamic>;
        final user = User.fromJson(body);
        change(user, status: RxStatus.success());
        return;
      }

      print('========= HomeController get user error: ${response.statusCode}');
      change(null,
          status:
              RxStatus.error('Something went wrong,\nPlease try again later.'));
    }).onError((error, stackTrace) {
      print('========= HomeController get user on error $error');
      change(null,
          status:
              RxStatus.error('Something went wrong,\nPlease try again later.'));
    });
    super.onReady();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 100,
    );

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings);
  }

  void gotoFaceScan() {
    _determinePosition().then((position) {
      UserInfoService.to.lat(position.latitude);
      UserInfoService.to.long(position.longitude);
      print(
          '========= HomeController lat=${UserInfoService.to.lat()}, long=${UserInfoService.to.long()}');
      Get.toNamed('/facescan');
    }).onError((error, stackTrace) {
      Get.to(ErrorView(title: 'Face Scan', message: '$error'));
    });
  }
}
