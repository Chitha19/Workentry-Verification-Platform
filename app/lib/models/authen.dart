import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  String token;
  String type;

  Auth({
    this.token = '',
    this.type = 'Bearer',
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      token: json['access_token'] as String,
      type: json['token_type'] as String,
    );
  }

  Future<void> store() =>
      _storage.write(key: 'access_token', value: '$type $token');

  Future<String?> read() =>
      _storage.read(key: 'access_token');
}
