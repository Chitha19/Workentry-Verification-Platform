import 'dart:async';
import 'dart:convert';

import 'package:app/apis/auth.dart';
import 'package:app/models/authen.dart';
import 'package:app/models/user.dart';
import 'package:app/pages/error/views/error_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  static const _tokenKey = 'access_token';
  static const _storage = FlutterSecureStorage();

  final _loaded = false.obs;
  final isAuth = false.obs;
  final token = "".obs;
  final user = User().obs;

  Future<AuthService> init() async {
    print('========= AuthService init');
    await loadProfile();
    return this;
  }

  Future<AuthService> loaded() async {
    print('========= AuthService loading.');
    await Future.doWhile(() => !(_loaded()));
    print('========= AuthService loaded.');
    return this;
  }

  @override
  void onInit() {
    print('========= AuthService onInit');
    super.onInit();
  }

  @override
  void onClose() {
    print('========= AuthService onClose');
    _storage.write(key: _tokenKey, value: token());
    super.onClose();
  }

  Future<void> loadProfile() async {
    print('========= AuthService start load profile');
    final accessToken = await _storage.read(key: _tokenKey);

    if (accessToken == null) {
      //! go to login page
      _loaded(true);
      return;
    }
    print('========= AuthService load token -> $accessToken');
    token(accessToken);
    await handleFetchUser();
  }

  Future<User?> loadUser() async {
    final accessToken = await loadToken();
    if (accessToken == '') return null;

    try {
      final response = await fetchUser(token.value);
      if (response.statusCode >= 400 && response.statusCode < 500) {
        print('========= AuthService fetch user error: ${response.statusCode}');
        // return;
      }
      if (response.statusCode >= 500) {
        //! go to error page
        _loaded(true);
        Get.off(const ErrorView(
          title: 'Error',
          message: 'Something went wrong,\nPlease try again later.',
        ));
        // return;
      }

      final body = json.decode(response.body) as Map<String, dynamic>;
      user.value = User.fromJson(body);
      isAuth.value = true;
      _loaded(true);
    } catch (e) {
      
    }
  }

  Future<String> loadToken() async {
    print('========= AuthService start load token');
    final accessToken = await _storage.read(key: _tokenKey);

    if (accessToken == null) {
      print('========= AuthService token loaded -> null');
      return token();
    }
    print('========= AuthService token loaded -> $accessToken');
    token(accessToken);
    return token();
  }

  Future<void> handleFetchUser() async {
    try {
      final response = await fetchUser(token.value);
      if (response.statusCode >= 400 && response.statusCode < 500) {
        //! go to login page
        print('========= AuthService fetch user error: ${response.statusCode}');
        _loaded(true);
        return;
      }
      if (response.statusCode >= 500) {
        //! go to error page
        _loaded(true);
        Get.off(const ErrorView(
          title: 'Error',
          message: 'Something went wrong,\nPlease try again later.',
        ));
        return;
      }

      final body = json.decode(response.body) as Map<String, dynamic>;
      user.value = User.fromJson(body);
      isAuth.value = true;
      _loaded(true);
    } catch (e) {
      print('======== AuthService handleFetchUser catch $e');
      _loaded(true);
      Get.off(const ErrorView(
        title: 'Error',
        message: 'Something went wrong,\nPlease try again later.',
      ));
    }
  }

  // no longer use
  Future<void> handleLogin(String email, String password) async {
    final response = await login(email, password);
    if (response.statusCode >= 400 && response.statusCode < 500) {
      //! show invalid login infomation
      return;
    }
    if (response.statusCode >= 500) {
      //! go to error page
      return;
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final auth = Auth.fromJson(body);
    token.value = "${auth.type} ${auth.token}";

    await handleFetchUser();
  }
}
