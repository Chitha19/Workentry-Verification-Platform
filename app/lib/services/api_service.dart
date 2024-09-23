import 'dart:async';
import 'dart:convert';
// import 'dart:typed_data';
// import 'package:get/get_connect/connect.dart';
// import 'package:http/http.dart' as http;

import 'package:app/services/userinfo_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:web_socket_channel/io.dart';
import 'package:image/image.dart' as imglib;

class ApiService extends GetConnect {
  static ApiService get to => Get.find<ApiService>();

  static const _host = '192.168.1.76:8000';
  static const _storage = FlutterSecureStorage();

  @override
  void onInit() {
    print('========= ApiService on init');
    httpClient.baseUrl = 'http://$_host';
    addRequestInterceptor();
    addResponseInterceptor();
    super.onInit();
  }

  void addRequestInterceptor() {
    httpClient.addRequestModifier<void>((Request request) async {
      final token = await getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }

  void addResponseInterceptor() {
    httpClient
        .addResponseModifier<void>((Request request, Response response) async {
      if (response.status.isUnauthorized) {
        Get.offAllNamed('/login');
      }
      return response;
    });
  }

  Future<String?> getToken() => _storage.read(key: 'access_token');

  Future<Response> login(String email, String password) => post(
      '/api/v1/login', json.encode({'username': email, 'password': password}));

  Future<Response> getUser() => get('/api/v1/emp');

  Future<Response> getCoperates() => get('/api/v1/corp');

  Future<Response> registerEmployee(
      String email, String password, String siteID, imglib.Image image) {
    final imgBytes = imglib.encodeJpg(image);
    final form = FormData({
      'email': email,
      'password': password,
      'site_id': siteID,
      'img': MultipartFile(imgBytes, filename: 'idcard.jpg')
    });
    return post('/api/v2/emp', form);
  }

  Future<IOWebSocketChannel> getFaceVerificationChannel() async {
    final token = await getToken();

    final url = Uri.parse('ws://$_host/ws/v1/face-verification');
    final channel = IOWebSocketChannel.connect(url, headers: {
      'Authorization': 'Bearer ${token!}',
      'X-Current-Location':
          '${UserInfoService.to.lat},${UserInfoService.to.long}'
    });

    return channel;
  }
}
