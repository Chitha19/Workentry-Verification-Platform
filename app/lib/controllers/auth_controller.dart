import 'package:app/models/user.dart';
import 'package:app/models/authen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  static final _loginUrl = Uri.parse('http://localhost:8000/api/v1/login');
  static final _empUrl = Uri.parse('http://localhost:8000/api/v1/emp');
  static const _tokenKey = 'access_token';
  final _storage = const FlutterSecureStorage();

  final isAuth = false.obs;
  final token = "".obs;
  final user = User().obs;

  @override
  void onInit() async {
    await loadProfile();
    super.onInit();
  }

  @override
  void onClose() async {
    await _storage.write(key: _tokenKey, value: token.value);
    super.onClose();
  }

  Future<void> loadProfile() async {
    final accessToken = await _storage.read(key: _tokenKey);

    if (accessToken == null) {
      //! to go login page
      return;
    }

    token.value = accessToken;
    await handleFetchUser();
  }

  Future<void> handleFetchUser() async {
    final response = await fetchUser();
    if (response.statusCode >= 400 && response.statusCode < 500) {
      //! to go login page
      return;
    }
    if (response.statusCode >= 500) {
      //! to go error page
      return;
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    user.value = User.fromJson(body);
    isAuth.value = true;
  }

  Future<void> handleLoginResponse(Future<http.Response> resp) async {
    final response = await resp;
    if (response.statusCode >= 400 && response.statusCode < 500) {
      //! show invalid login infomation
      return;
    }
    if (response.statusCode >= 500) {
      //! to go error page
      return;
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final auth = Auth.fromJson(body);
    token.value = "${auth.type} ${auth.token}";
    
    await handleFetchUser();
  }

  Future<http.Response> login(String email, String password) {
    return http.post(
      _loginUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json
          .encode(<String, String>{'username': email, 'password': password}),
    );
  }

  Future<http.Response> fetchUser() {
    return http
        .get(_empUrl, headers: <String, String>{'Authorization': token.value});
  }
}
