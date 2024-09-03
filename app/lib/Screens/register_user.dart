import 'package:app/Screens/register_corp.dart';
import 'package:app/Widgets/register_btn.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:app/Widgets/input_layout.dart';
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
  bool _emailValid = false;
  bool _passwordValid = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController(text: randomPassword(10));

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

  String randomPassword(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  bool get _valid => (_emailValid && _passwordValid);

  void _nextPage() {
    RegisterForm form = Provider.of<RegisterForm>(context, listen: false);
    form.email = emailController.text;
    form.password = passwordController.text;
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => const RegisterCorp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Register Account'),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Employee Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
          const SizedBox(height: 30),
          const Text('To register employee account.', style: TextStyle()),
          const SizedBox(height: 35),
          InputLayout(child: [
            SizedBox(
                height: 50,
                child: CupertinoTextField(
                  placeholder: 'Required',
                  prefix: const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: const BoxDecoration(),
                  controller: emailController,
                )),
            SizedBox(
                height: 50,
                child: CupertinoTextField(
                  placeholder: 'Required',
                  prefix: const Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: const BoxDecoration(),
                  controller: passwordController,
                ))
          ]),
          const SizedBox(height: 45),
          RegisterButtonLayout(
            // TODO: add prev page
            onNext: (!_valid) ? null : _nextPage,
          ),
        ]));
  }
}
