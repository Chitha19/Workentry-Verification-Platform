import 'package:flutter/foundation.dart';

class Profile extends ChangeNotifier {
  String _id = "";
  String _name = "";
  bool _isAdmin = false;

  String get id => _id;
  String get name => _name;
  bool get isAdmin => _isAdmin;

  set id(String id) {
    _id = id;
    notifyListeners();
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set isAdmin(bool admin) {
    _isAdmin = admin;
    notifyListeners();
  }
}
