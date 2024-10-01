import 'dart:convert';

import 'package:app/models/employee.dart';
import 'package:app/pages/register/controllers/register_controller.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController with StateMixin<Employee> {
  static ReviewController get to => Get.find<ReviewController>();
  final employee = Employee().obs;
  final idController = TextEditingController().obs;
  final siteController = TextEditingController().obs;
  final usernameController = TextEditingController().obs;
  final fnameTHController = TextEditingController().obs;
  final lnameTHController = TextEditingController().obs;
  final fnameENController = TextEditingController().obs;
  final lnameENController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final _idValid = false.obs;
  final _usernameValid = false.obs;
  final _emailValid = false.obs;
  final _passwordValid = false.obs;
  final _fnameTHValid = false.obs;
  final _lnameTHValid = false.obs;
  final _fnameENValid = false.obs;
  final _lnameENValid = false.obs;
  RxBool get isAdmin => employee().isAdmin.obs;
  RxBool get valid => (_idValid() &&
          _emailValid() &&
          _passwordValid() &&
          _usernameValid() &&
          _fnameTHValid() &&
          _lnameTHValid() &&
          _fnameENValid() &&
          _lnameENValid())
      .obs;

  @override
  void onInit() async {
    change(null, status: RxStatus.loading());
    initTECListener();
    super.onInit();
  }

  @override
  void onReady() async {
    await ocr();
    super.onReady();
  }

  @override
  void onClose() {
    idController().dispose();
    siteController().dispose();
    usernameController().dispose();
    fnameTHController().dispose();
    lnameTHController().dispose();
    fnameENController().dispose();
    lnameENController().dispose();
    emailController().dispose();
    passwordController().dispose();
    super.onClose();
  }

  Future<void> ocr() async {
    ApiService.to
        .getOCR(
            RegisterController.to.emailController().text,
            RegisterController.to.passwordController().text,
            RegisterController.to.selectedSite().id,
            RegisterController.to.idCard())
        .then((response) {
      print('========= ReviewController response from ocr : ${response.isOk}, ${response.headers}');
      if (response.status.isOk) {
        final body = json.decode(response.bodyString!) as Map<String, dynamic>;
        print('========= ReviewController get ocr : $body');
        final emp = Employee.fromJson(body);
        employee(emp);
        initTECValue();
        change(employee(), status: RxStatus.success());
        return;
      }

      if (!response.status.isServerError) {
        final body = json.decode(response.bodyString!) as Map<String, dynamic>;
        change(null, status: RxStatus.error(body['detail']));
        return;
      }

      change(null,
          status:
              RxStatus.error('Something went wrong,\nPlease try again later.'));
    }).onError((error, stack) {
      change(null,
          status:
              RxStatus.error('Something went wrong,\nPlease try again later.\n$error'));
    });
  }

  void initTECValue() {
    idController().text = employee().id;
    emailController().text = employee().email;
    passwordController().text = employee().password;
    siteController().text =
        '${RegisterController.to.selectedCorp().shortname} ${RegisterController.to.selectedSite().name}';
    usernameController().text = employee().username;
    fnameTHController().text = employee().firstNameTH;
    lnameTHController().text = employee().lastNameTH;
    fnameENController().text = employee().firstNameEN;
    lnameENController().text = employee().lastNameEN;
  }

  void initTECListener() {
    idController().addListener(() {
      if (idController().text.characters.isEmpty) {
        _idValid(false);
      } else {
        _idValid(true);
      }
      employee().id = idController().text;
    });
    emailController().addListener(() {
      if (emailController().text.characters.isEmpty) {
        _emailValid(false);
      } else {
        _emailValid(true);
      }
      employee().email = emailController().text;
    });
    passwordController().addListener(() {
      if (passwordController().text.characters.isEmpty) {
        _passwordValid(false);
      } else {
        _passwordValid(true);
      }
      employee().password = passwordController().text;
    });
    usernameController().addListener(() {
      if (usernameController().text.characters.isEmpty) {
        _usernameValid(false);
      } else {
        _usernameValid(true);
      }
      employee().username = usernameController().text;
    });
    fnameTHController().addListener(() {
      if (fnameTHController().text.characters.isEmpty) {
        _fnameTHValid(false);
      } else {
        _fnameTHValid(true);
      }
      employee().firstNameTH = fnameTHController().text;
    });
    lnameTHController().addListener(() {
      if (lnameTHController().text.characters.isEmpty) {
        _lnameTHValid(false);
      } else {
        _lnameTHValid(true);
      }
      employee().lastNameTH = lnameTHController().text;
    });
    fnameENController().addListener(() {
      if (fnameENController().text.characters.isEmpty) {
        _fnameENValid(false);
      } else {
        _fnameENValid(true);
      }
      employee().firstNameEN = fnameENController().text;
    });
    lnameENController().addListener(() {
      if (lnameENController().text.characters.isEmpty) {
        _lnameENValid(false);
      } else {
        _lnameENValid(true);
      }
      employee().lastNameEN = lnameENController().text;
    });
  }

  void setIsAdmin(bool option) {
    print('========= ReviewController setIsAdmin to $option');
    employee().isAdmin = option;
  }

  // void confirmRegisterEmployee() {
  //   ApiService.to.confirmRegisterEmployee(employee()).then((response) {
  //     if (response.status.isOk) {
  //       return;
  //     }
  //   }).onError((error, stack) {});
  // }
}
