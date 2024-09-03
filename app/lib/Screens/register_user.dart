import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:app/States/register_form.dart';
import 'package:provider/provider.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  String randomPassword(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController(text: randomPassword(10));
  }

  @override
  void dispose() {
    final form = Provider.of<RegisterForm>(context, listen: false);
    form.email = emailController.text;
    form.password = passwordController.text;
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Register'),
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 100,
                // width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100,
                ),
                child: Column(
                  children: [
                    CupertinoTextField(
                      placeholder: 'Required',
                      prefix: const Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: const BoxDecoration(),
                      controller: emailController,
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    CupertinoTextField(
                      placeholder: 'Required',
                      prefix: const Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: const BoxDecoration(),
                      controller: passwordController,
                    ),
                  ],
                ),
              ),
            )));
  }
}
