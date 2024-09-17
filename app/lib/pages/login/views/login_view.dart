import 'package:app/widgets/input_part_layout.dart';
import 'package:app/widgets/register_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
        child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: ListView(children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 26.0, bottom: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28.0)),
                    ],
                  ),
                ),
              ),
              InputPartLayout(title: 'Account', children: [
                CupertinoTextField(
                  placeholder: 'Required',
                  prefix: const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: const BoxDecoration(),
                  controller: controller.emailController.value,
                ),
                CupertinoTextField(
                    placeholder: 'Required',
                    prefix: const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    decoration: const BoxDecoration(),
                    controller: controller.passwordController.value,
                    obscureText: true),
              ]),
              const SizedBox(height: 22),
              Obx(() => RegisterButtonLayout(
                  nextTitle: 'Submit',
                  onNext: !(controller.valid.value) ? null : controller.submit))
            ])));
  }
}
