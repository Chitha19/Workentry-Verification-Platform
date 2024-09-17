import 'package:app/Screens/login.dart';
import 'package:app/States/register_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

Future<http.StreamedResponse> register(BuildContext context) async {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  return storage.read(key: 'access_token').then((token) {
    if (token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => const Login()), //! wrap auth
          (Route route) => false);
    }
    return token!;
  }).then((token) async {
    final form = Provider.of<RegisterForm>(context, listen: false);
    final request = http.MultipartRequest(
        'POST', Uri.parse('http://172.23.19.85:8000/api/v2/emp'));

    final file = http.MultipartFile.fromPath('img', form.card!.path);
    request.headers['Authorization'] = token;
    request.fields['email'] = form.email;
    request.fields['password'] = form.password;
    request.fields['site_id'] = form.site!.id;
    request.files.add(await file);

    return request.send();
  });
}
