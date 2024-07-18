import 'package:flutter/foundation.dart';

class Profile extends ChangeNotifier {
  String _id = "";
  String _name = "";

  Profile() {
    initProfile("this is token from sharePreference");
  }

  String get id => _id;
  String get name => _name;

  Future<void> initProfile(String token) async {
    _id = "12345";
    _name = "Alongkorn T.";
    notifyListeners();
  }
}
