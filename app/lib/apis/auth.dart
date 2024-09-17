import 'dart:convert';
import 'package:app/models/authen.dart';
import 'package:http/http.dart' as http;

const _loginUrl = 'http://192.168.1.76:8000/api/v1/login';
const _empUrl = 'http://192.168.1.76:8000/api/v1/emp';

Future<http.Response> login(String email, String password) {
  return http.post(
    Uri.parse(_loginUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body:
        json.encode(<String, String>{'username': email, 'password': password}),
  );
}

Future<http.Response> fetchUser(String token) {
  return http.get(Uri.parse(_empUrl),
      headers: <String, String>{'Authorization': token});
}

Future<http.Response> loginWithUser(String email, String password) async {
  final response = await login(email, password);
  if (response.statusCode != 200) {
    return response;
  }

  final body = json.decode(response.body) as Map<String, dynamic>;
  final auth = Auth.fromJson(body);
  await auth.store();

  final token = "${auth.type} ${auth.token}";
  return fetchUser(token);
}
