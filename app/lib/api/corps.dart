import 'dart:convert';
import 'package:app/Screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TSite {
  final String id;
  final String name;

  TSite({
    required this.id,
    required this.name,
  });

  factory TSite.fromJson(Map<String, dynamic> json) {
    return TSite(
      id: json['site_id'] as String,
      name: json['site_name'] as String,
    );
  }
}

class TCorp {
  final String id;
  final String name;
  final List<TSite> sites;

  TCorp({
    required this.id,
    required this.name,
    required this.sites,
  });

  factory TCorp.fromJson(Map<String, dynamic> json) {
    final List site = json['site'];
    final sites =
        site.map((s) => TSite.fromJson(s as Map<String, dynamic>)).toList();
    return TCorp(
        id: json['corp_id'] as String,
        name: json['corp_name'] as String,
        sites: sites);
  }
}

Future<List<TCorp>> fetchTCorps(BuildContext context) async {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  // String? token = await storage.read(key: 'access_token');
  // if (token == null) {
  //   throw Exception('token is null');
  // }

  // Map<String, String> headers = {'Authorization': token};
  // final response = await http
  //     .get(Uri.parse('http://localhost:8000/api/v1/corp'), headers: headers);

  // if (response.statusCode == 401) {
  //   throw Navigator.of(context).pushAndRemoveUntil(
  //       CupertinoPageRoute(builder: (context) => const Login()), //! wrap auth
  //       (Route route) => false);
  // }

  // if (response.statusCode == 200) {
  //   final List body = json.decode(response.body);
  //   return body.map((e) => TCorp.fromJson(e as Map<String, dynamic>)).toList();
  // }

  // throw Exception('Failed to load corps');

  return storage.read(key: 'access_token').then((token) {
    if (token == null) {
      throw Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => const Login()), //! wrap auth
          (Route route) => false);
    }
    return token;
  }).then((token) async {
    Map<String, String> headers = {'Authorization': token};
    return http.get(Uri.parse('http://localhost:8000/api/v1/corp'),
        headers: headers);
  }).then((response) {
    if (response.statusCode == 401) {
      throw Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => const Login()), //! wrap auth
          (Route route) => false);
    }

    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body
          .map((e) => TCorp.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load corps');
  });
}

class Corp {
  final int id;
  final String name;

  Corp({
    required this.id,
    required this.name,
  });

  factory Corp.fromJson(Map<String, dynamic> json) {
    return Corp(
      id: json['id'] as int,
      name: json['title'] as String,
    );
  }
}

Future<List<Corp>> fetchCorps() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=2'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load corps');
  }

  final List body = json.decode(response.body);
  return body.map((e) => Corp.fromJson(e as Map<String, dynamic>)).toList();
  //   List<Map<String, dynamic>> response = [
  //   {
  //     'corp_id': 'corp_1',
  //     'corp_name': 'corp_name_1',
  //     'site': [
  //       {'site_id': 'corp_1_site_1', 'site_name': 'corp_name_1_site_name_1'},
  //       {'site_id': 'corp_1_site_2', 'site_name': 'corp_name_1_site_name_2'}
  //     ]
  //   },
  //   {
  //     'corp_id': 'corp_2',
  //     'corp_name': 'corp_name_2',
  //     'site': [
  //       {'site_id': 'corp_2_site_1', 'site_name': 'corp_name_2_site_name_1'},
  //     ]
  //   },
  //   {
  //     'corp_id': 'corp_3',
  //     'corp_name': 'corp_name_3',
  //     'site': [
  //       {'site_id': 'corp_3_site_1', 'site_name': 'corp_name_3_site_name_1'},
  //       {'site_id': 'corp_3_site_2', 'site_name': 'corp_name_3_site_name_2'},
  //       {
  //         'site_id': 'corp_3_site_3',
  //         'site_name':
  //             'corp_name_3_site_name_3_ooooooooooooooooooooooooooooooooooooo'
  //       },
  //     ]
  //   }
  // ];

  // List<TCorp> body = response.map((e) => TCorp.fromJson(e)).toList();
  // return Future<List<TCorp>>.value(body);
}
