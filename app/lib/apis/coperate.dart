import 'package:http/http.dart' as http;

const _corpUrl = 'http://192.168.1.76:8000/api/v1/corp';

Future<http.Response> fetchCoperate(String token) async {
  Map<String, String> headers = {'Authorization': token};
  return http.get(Uri.parse(_corpUrl), headers: headers);
}
