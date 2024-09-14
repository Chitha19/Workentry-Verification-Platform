import 'package:app/Screens/register_card.dart';
import 'package:app/Service/random_password.dart';
import 'package:app/Widgets/input_part_layout.dart';
import 'package:app/Widgets/register_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/api/corps.dart';
import 'package:app/States/register_form.dart';
import 'package:provider/provider.dart';
import 'package:app/Widgets/selected_corp.dart';
import 'package:app/Widgets/selected_site.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  final Future<List<TCorp>> corps = fetchTCorps();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _emailValid = false;
  bool _passwordValid = true;
  bool get _valid => (_emailValid && _passwordValid);

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController(text: RandomPassword().password);

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RegisterForm form = Provider.of<RegisterForm>(context, listen: false);
      corps.then((datas) {
        form.corp = datas[0];
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _nextPage() {
    RegisterForm form = Provider.of<RegisterForm>(context, listen: false);
    form.email = emailController.text;
    form.password = passwordController.text;
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => const RegisterCard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Register Account'),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: FutureBuilder<List<TCorp>>(
              future: corps,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Server error. Please try again later.",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold)),
                  );
                }

                if (snapshot.hasData) {
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Server error. Please try again later.",
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold)),
                    );
                  }

                  var datas = snapshot.data!;
                  return ListView(
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 26.0, bottom: 28.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Create Account',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.0)),
                              SizedBox(height: 12),
                              Text('To create an employee account.'),
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
                        )
                      ]),
                      InputPartLayout(
                        title: 'Coperate',
                        children: [
                          SelectedCorp(corps: datas),
                          const SelectedSite()
                        ],
                      ),
                      const SizedBox(height: 22),
                      RegisterButtonLayout(
                        // TODO: add prev page
                        onNext: (!_valid) ? null : _nextPage,
                      )
                    ],
                  );
                }

                return const CupertinoActivityIndicator();
              }),
        ));
  }
}
