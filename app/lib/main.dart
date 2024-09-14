import 'dart:async';

import 'package:app/States/profile.dart';
import 'package:app/States/register_form.dart';
import 'package:app/Widgets/wrap_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:app/Screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Profile()),
        ChangeNotifierProvider(create: (context) => RegisterForm()),
      ],
      child: const CupertinoApp(
          theme: CupertinoThemeData(brightness: Brightness.light),
          // home: WrapAuth(page: Home())),
          home: Home()),
    ),
  );
}
