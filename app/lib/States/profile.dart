import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Profile extends ChangeNotifier {
  String _id = "";
  String _name = "";

  Profile() {
    // initProfile("this is token from sharePreference");
  }

  String get id => _id;
  String get name => _name;

  void setProfile(String id, name) {
    _id = id;
    _name = name;
    notifyListeners();
  }

  Future<void> initProfile(String token) async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load album');
    }

    final user = jsonDecode(response.body) as Map<String, dynamic>;
    _id = user["id"].toString();
    _name = user["name"];

    // _id = "12345";
    // _name = "Alongkorn T.";
    notifyListeners();
  }
}
