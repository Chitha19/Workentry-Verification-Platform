import 'dart:convert';
import 'package:http/http.dart' as http;

class Todo {
  final String name;
  final String email;

  const Todo({
    required this.name,
    required this.email,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
          name: json['name'] as String,
          email: json['email'] as String,
        );
  }
}

Future<List<Todo>> fetchTodos() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load todos');
  }

  final List body = json.decode(response.body);
  return body.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
}
