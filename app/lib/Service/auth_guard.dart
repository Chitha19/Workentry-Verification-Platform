import 'package:app/Screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void guard(BuildContext context, Widget page) {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  storage.read(key: 'access_token').then((token) {
    if (token != null) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const Login()), //! wrap auth
        (Route route) => false);
  });
}
