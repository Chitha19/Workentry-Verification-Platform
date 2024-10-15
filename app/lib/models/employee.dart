import 'dart:convert';

class Employee {
  String id;
  final String siteID;
  String username;
  String firstNameTH;
  String lastNameTH;
  String firstNameEN;
  String lastNameEN;
  String email;
  String password;
  bool isAdmin;
  final String img;

  Employee(
      {this.id = '',
      this.siteID = '',
      this.username = '',
      this.firstNameTH = '',
      this.lastNameTH = '',
      this.firstNameEN = '',
      this.lastNameEN = '',
      this.email = '',
      this.password = '',
      this.isAdmin = false,
      this.img = ''});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['emp_corp_id'] as String,
      siteID: json['site_id'] as String,
      username: json['username'] as String,
      firstNameTH: json['fname_th'] as String,
      lastNameTH: json['lname_th'] as String,
      firstNameEN: json['fname_en'] as String,
      lastNameEN: json['lname_en'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      isAdmin: json['isAdmin'] as bool,
      img: json['img'] as String,
    );
  }

  String toJson() {
    final emp = json.encode({
      'emp_corp_id': id,
      'site_id': siteID,
      'username': username,
      'email': email,
      'password': password,
      'fname_th': firstNameTH,
      'lname_th': lastNameTH,
      'fname_en': firstNameEN,
      'lname_en': lastNameEN,
      'isAdmin': isAdmin,
      'img': img
    });
    print('confirm $emp');
    return emp;
  }
}
