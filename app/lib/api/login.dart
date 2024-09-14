import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  final String token;
  final String type;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  const Token({
    required this.token,
    required this.type,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['access_token'] as String,
      type: json['token_type'] as String,
    );
  }

  Future<void> store() async {
    await _storage.write(key: 'access_token', value: token);
  }
}

Future<http.Response> login(String email, String password) {
  return http.post(
    Uri.parse('http://localhost:8000/api/v1/login/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body:
        json.encode(<String, String>{'username': email, 'password': password}),
  );
}
