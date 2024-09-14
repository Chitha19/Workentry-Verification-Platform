import 'package:app/api/corps.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class RegisterForm extends ChangeNotifier {
  TCorp? _corp;
  TSite? _site;
  XFile? _card;
  String _email = "";
  String _password = "";

  RegisterForm() {
    // _init();
  }

  TCorp? get corp => _corp;
  TSite? get site => _site;
  XFile? get card => _card;
  String get email => _email;
  String get password => _password;

  set corp(TCorp? c) {
    if (c == null) {
      return;
    }
    _corp = c;
    _site = c.sites[0];
    notifyListeners();
  }

  set site(TSite? s) {
    _site = s;
    notifyListeners();
  }

  set card(XFile? c) {
    _card = c;
    notifyListeners();
  }

  set email(String s) {
    _email = s;
    notifyListeners();
  }

  set password(String s) {
    _password = s;
    notifyListeners();
  }
}
