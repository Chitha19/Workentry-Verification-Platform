import 'dart:async';

import 'package:app/States/profile.dart';
import 'package:app/States/register_form.dart';
import 'package:app/middlewares/auth_middleware.dart';
import 'package:app/pages/facescan/bindings/facescan_binding.dart';
import 'package:app/pages/facescan/views/facescan_view.dart';
import 'package:app/pages/home/bindings/home_binding.dart';
import 'package:app/pages/home/controllers/home_controller.dart';
import 'package:app/pages/login/bindings/login_binding.dart';
import 'package:app/pages/login/controllers/login_controller.dart';
import 'package:app/pages/login/views/login_view.dart';
import 'package:app/pages/register/bindings/register_binding.dart';
import 'package:app/pages/register/views/register_view.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/widgets/wrap_auth.dart';
import 'package:app/views/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:app/pages/home/views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(GetCupertinoApp(
    theme: const CupertinoThemeData(brightness: Brightness.light),
    initialRoute: '/',
    initialBinding: BindingsBuilder(() {
      Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
      Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    }),
    getPages: [
      GetPage(
          name: '/',
          page: () => const HomeView(),
          binding: HomeBinding(),
          children: [
            GetPage(
                name: '/facescan',
                page: () => const FacescanView(),
                binding: FacescanBinding())
          ]),
      GetPage(
          name: '/login',
          page: () => const LoginView(),
          binding: LoginBinding()),
      GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: RegisterBinding())
    ],
  ));

  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => Profile()),
  //       ChangeNotifierProvider(create: (context) => RegisterForm()),
  //     ],
  //     child: const CupertinoApp(
  //         theme: CupertinoThemeData(brightness: Brightness.light),
  //         home: WrapAuth(page: Home())),
  //     // home: Home()),
  //   ),
  // );
}
