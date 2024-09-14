import 'dart:convert';
import 'package:app/Screens/home.dart';
import 'package:app/Widgets/loading.dart';
import 'package:app/api/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/Widgets/input_part_layout.dart';
import 'package:app/Widgets/register_btn.dart';
import 'package:app/States/profile.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _emailValid = false;
  bool _passwordValid = true;
  bool get _valid => (_emailValid && _passwordValid);

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailController.addListener(() {
      if (emailController.text.characters.isEmpty) {
        setState(() {
          _emailValid = false;
        });
      } else {
        setState(() {
          _emailValid = true;
        });
      }
    });

    passwordController.addListener(() {
      if (passwordController.text.characters.isEmpty) {
        setState(() {
          _passwordValid = false;
        });
      } else {
        setState(() {
          _passwordValid = true;
        });
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    Utils(context).startLoading();
    login(emailController.text, passwordController.text).then((response) {
      Utils(context).stopLoading();

      if (response.statusCode == 200) {
        final raw = json.decode(response.body) as Map<String, dynamic>;
        final token = Token.fromJson(raw);
        token.store().then((_) {
          //! set profile
          Profile profile = Provider.of<Profile>(context, listen: false);
          profile.id = raw['profile']['id'] as String;
          profile.name = raw['profile']['username'] as String;
          profile.isAdmin = raw['profile']['isAdmin'] as bool;
          // route to home page
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => const Home()),
              (Route route) => false);
        });
        return;
      }

      if (response.statusCode >= 400 && response.statusCode < 500) {
        Utils(context).showError('Email or Password is Incorrect');
        return;
      }

      Utils(context).showError('Something went wrong. Please try again later');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            // middle: Text('Login'),
            ),
        child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: ListView(children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 26.0, bottom: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28.0)),
                      // SizedBox(height: 12),
                      // Text('To create an employee account.'),
                    ],
                  ),
                ),
              ),
              InputPartLayout(title: 'Account', children: [
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
                    obscureText: true),
              ]),
              const SizedBox(height: 22),
              RegisterButtonLayout(
                nextTitle: 'Submit',
                onNext: (!_valid) ? null : _login,
              )
            ])));
  }
}
