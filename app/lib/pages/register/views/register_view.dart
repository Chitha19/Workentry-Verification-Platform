import 'package:app/pages/register/controllers/register_controller.dart';
import 'package:app/pages/register/views/id_card.dart';
import 'package:app/pages/register/views/select_corp.dart';
import 'package:app/pages/register/views/select_site.dart';
import 'package:app/widgets/input_part_layout.dart';
import 'package:app/widgets/register_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Register Account'),
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: controller.obx(
              (coperates) => ListView(children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 26.0, bottom: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Create Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28.0)),
                        SizedBox(height: 12),
                        Text('To create an employee account.'),
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
                    controller: controller.emailController(),
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
                    controller: controller.passwordController(),
                  )
                ]),
                const InputPartLayout(
                  title: 'Coperate',
                  children: [SelectCorp(), SelectSite()],
                ),
                const IdCard(),
                const SizedBox(height: 22),
                Obx(() => RegisterButtonLayout(
                      onPrev: () => Get.back(),
                      nextTitle: 'Review',
                      onNext: !(controller.valid())
                          ? null
                          : controller.registerEmployee,
                    ))
              ]),
              onLoading: const Center(child: CupertinoActivityIndicator()),
              onError: (message) => Center(
                  child: Text(message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: "Netflix",
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold))),
            )));
  }
}
