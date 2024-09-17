import 'package:app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  // final authService =
  //     Get.putAsync<AuthService>(() async => await AuthService().loaded());

  @override
  int? get priority => 8;

  @override
  RouteSettings? redirect(String? route) {
    print('========= AuthMiddleware redirect from $route');
    return null;
    // if (authService.isAuth()) {
    //   return null;
    // }
    // print('========= AuthMiddleware from $route redirect to /login');
    // return const RouteSettings(name: '/login');
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    // bindings?.add(BindingsBuilder(() {
    //   Get.putAsync<AuthService>(() async => AuthService());
    // }));
    print('========= AuthMiddleware onBindingsStart bindings $bindings');
    return bindings;
  }
}
