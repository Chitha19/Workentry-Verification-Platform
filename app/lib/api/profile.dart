import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String name;

  const User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
      } =>
        User(
          id: id,
          name: name,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}

Future<User> fetchUser(String id) async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load user');
  }

  return  User.fromJson(json.decode(response.body) as Map<String, dynamic>);
}
