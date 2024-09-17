class User {
  String id;
  String name;
  bool isAdmin;

  User({this.id = '', this.name = '', this.isAdmin = false});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['username'] as String,
      isAdmin: json['isAdmin'] as bool
    );
  }
}
