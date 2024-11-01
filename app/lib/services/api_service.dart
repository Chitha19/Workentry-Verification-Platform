import 'dart:async';
import 'dart:convert';
// import 'dart:typed_data';
// import 'package:get/get_connect/connect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:app/models/employee.dart';
import 'package:app/services/userinfo_service.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:web_socket_channel/io.dart';
import 'package:image/image.dart' as imglib;

class ApiService extends GetConnect {
  static ApiService get to => Get.find<ApiService>();

  // static const host = '13.251.157.178:8080';
  static const host = '192.168.1.76:8080';
  static const storage = FlutterSecureStorage();

  @override
  bool get allowAutoSignedCert => true;

  @override
  Duration get timeout => const Duration(minutes: 1);

  @override
  void onInit() async {
    print('========= ApiService on init');
    httpClient.baseUrl = 'https://$host';

    // print('token is ${await getToken()}');
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
      // else {
      //   Get.offAllNamed('/login');
      // }
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

  Future<String?> getToken() => storage.read(key: 'access_token');

  Future<Response> login(String email, String password) => post(
      '/api/v1/login', json.encode({'username': email, 'password': password}));

  Future<Response> getUser() => get('/api/v1/emp');

  Future<Response> getCoperates() => get('/api/v1/corp');

  Future<Response> confirmRegisterEmployee(Employee emp) =>
      post('/api/v1/emp', emp.toJson());

  // Future<Response> confirmRegisterEmployee(Employee emp) {
  //   // final body = emp.toJson();
  //   final body = json.encode({
  //     'emp_corp_id': emp.id,
  //     'site_id': emp.siteID,
  //     'username': emp.username,
  //     'email': emp.email,
  //     'password': emp.password,
  //     'fname_th': emp.firstNameTH,
  //     'lname_th': emp.lastNameTH,
  //     'fname_en': emp.firstNameEN,
  //     'lname_en': emp.lastNameEN,
  //     'isAdmin': emp.isAdmin,
  //     'img': emp.img
  //   });
  //   return post(
  //     '/api/v1/emp', body, contentType: 'application/json; charset=utf-8'
  //   );
  // }

  Future<Response> getOCR(
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

    final url = Uri.parse('wss://$host/ws/v1/face-verification');
    final channel = IOWebSocketChannel.connect(url, headers: {
      'Authorization': 'Bearer ${token!}',
      'X-Current-Location':
          '${UserInfoService.to.lat},${UserInfoService.to.long}'
    });

    return channel;
  }
}
