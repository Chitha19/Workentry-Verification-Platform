import 'package:app/pages/cardscan/bindings/cardscan_binding.dart';
import 'package:app/pages/cardscan/views/cardscan_view.dart';
import 'package:app/pages/facescan/bindings/facescan_binding.dart';
import 'package:app/pages/facescan/views/facescan_view.dart';
import 'package:app/pages/home/bindings/home_binding.dart';
import 'package:app/pages/login/bindings/login_binding.dart';
import 'package:app/pages/login/views/login_view.dart';
import 'package:app/pages/register/bindings/register_binding.dart';
import 'package:app/pages/register/views/register_view.dart';
import 'package:app/pages/review/bindings/review_binding.dart';
import 'package:app/pages/review/views/review_view.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:app/pages/home/views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(GetCupertinoApp(
    theme: const CupertinoThemeData(brightness: Brightness.light),
    initialRoute: '/',
    initialBinding: BindingsBuilder(() {
      Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
      Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
      // Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
      // Get.lazyPut<RegisterController>(() => RegisterController(), fenix: true);
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
          binding: RegisterBinding(),
          children: [
            GetPage(
                name: '/cardscan',
                page: () => const CardscanView(),
                binding: CardscanBinding()),
            GetPage(
                name: '/review',
                page: () => const ReviewView(),
                binding: ReviewBinding())
          ])
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
