import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/widgets/utils.dart';
import 'package:app/models/authen.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../apis/auth.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final _emailValid = false.obs;
  final _passwordValid = false.obs;
  RxBool get valid => (_emailValid() && _passwordValid()).obs;

  @override
  void onInit() {
    print(
        '========= LoginController oninit token is -> ${AuthService.to.token()}');
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
    print('========= LoginController onclose');
    emailController().dispose();
    passwordController().dispose();
    super.onClose();
  }

  void submit() {
    var context = Get.context!;
    Utils(context).startLoading();
    loginWithUser(emailController().text, passwordController().text)
        .then((response) {
      Utils(context).stopLoading();

      if (response.statusCode >= 400 && response.statusCode < 500) {
        Utils(context).showError('Email or Password is Incorrect');
        return;
      }

      if (response.statusCode >= 500) {
        Utils(context)
            .showError('Something went wrong. Please try again later');
        return;
      }

      final body = json.decode(response.body) as Map<String, dynamic>;
      final user = User.fromJson(body);

      print('========= LoginController user: $user');

      AuthService.to.user(user);
      AuthService.to.isAuth(true);
      Auth().read().then((token) {
        // print(
        //     '========= LoginController finshed login previos=${Get.previousRoute} raw=${context.}');
        if (token != null) AuthService.to.token(token);
        // Get.back(result: token);
        Get.offNamed('/');
      });
    }).onError((error, stack) {
      Utils(context).stopLoading();
      Utils(context).showError('Something went wrong. Please try again later');
      return;
    });
  }
}
