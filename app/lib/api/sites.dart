import 'dart:convert';
import 'package:http/http.dart' as http;

class Site {
  final int id;
  final String name;

  Site({
    required this.id,
    required this.name,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: json['id'] as int,
      name: json['email'] as String,
    );
  }
}

Future<List<Site>> fetchSites(int id) async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id/comments'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load sites');
  }

  final List body = json.decode(response.body);
  return body.map((e) => Site.fromJson(e as Map<String, dynamic>)).toList();
}
