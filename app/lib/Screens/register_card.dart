import 'package:app/Widgets/register_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterCard extends StatefulWidget {
  const RegisterCard({super.key});

  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  void _prevPage() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Register ID Card'),
        ),
        child: Padding(
            padding: const EdgeInsets.all(24.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('ID Card',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
              const SizedBox(height: 12),
              const Text('To take an employee id card picture.',
                  style: TextStyle()),
              const SizedBox(height: 26),
              Column(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(18),
                    shape: const CircleBorder(),
                    child: const Icon(
                      CupertinoIcons.camera,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Take Photo', style: TextStyle())
                ],
              ),
              const SizedBox(height: 45),
              RegisterButtonLayout(
                onPrev: _prevPage,
                nextTitle: 'Review',
              ),
            ])));
  }
}
