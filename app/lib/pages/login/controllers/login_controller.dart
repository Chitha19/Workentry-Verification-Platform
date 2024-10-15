// import 'dart:convert';

// import 'package:app/models/user.dart';
import 'dart:convert';

import 'package:app/models/authen.dart';
import 'package:app/services/api_service.dart';
import 'package:app/widgets/utils.dart';
// import 'package:app/models/authen.dart';
// import 'package:app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // static const _storage = FlutterSecureStorage();

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final _emailValid = false.obs;
  final _passwordValid = false.obs;
  RxBool get valid => (_emailValid() && _passwordValid()).obs;

  @override
  void onInit() {
    print('========= LoginController on init');
    super.onInit();

    emailController().addListener(() {
      if (emailController().text.characters.isEmpty) {
        _emailValid(false);
      } else {
        _emailValid(true);
      }
    });

    passwordController().addListener(() {
      if (passwordController().text.characters.isEmpty) {
        _passwordValid(false);
      } else {
        _passwordValid(true);
      }
    });
  }

  @override
  void onClose() {
    emailController().dispose();
    passwordController().dispose();
    super.onClose();
  }

  void submit() {
    var context = Get.context!;
    Utils(context).startLoading();

    ApiService.to
        .login(emailController().text, passwordController().text)
        .then((response) async {
      Utils(context).stopLoading();

      if (response.status.isOk) {
        final body = json.decode(response.bodyString!) as Map<String, dynamic>;
        final auth = Auth.fromJson(body);
        await ApiService.storage.write(key: 'access_token', value: auth.token);
        Get.offAllNamed('/');
        return;
      }

      if (response.status.code == 400) {
        Utils(context).showError('Email or Password is invalid.');
        return;
      }

      Utils(context).showError('Something went wrong. Please try again later');
    }).onError((error, stackTrace) {
      Utils(context).stopLoading();
      Utils(context).showError('Something went wrong. Please try again later');
    });
  }
}
