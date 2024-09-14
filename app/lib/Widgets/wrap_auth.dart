import 'package:flutter/cupertino.dart';
import 'package:app/Screens/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WrapAuth extends StatefulWidget {
  const WrapAuth({super.key, required this.page});

  final Widget page;

  @override
  State<WrapAuth> createState() => _WrapAuthState();
}

class _WrapAuthState extends State<WrapAuth> {
  late FlutterSecureStorage _storage;

  @override
  void initState() {
    super.initState();
    _storage = const FlutterSecureStorage();
    // _storage.delete(key: 'access_token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _storage.read(key: 'access_token'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const Login();
          } else {
            return widget.page;
          }
        }

        return const CupertinoActivityIndicator();
      },
    );
  }
}
