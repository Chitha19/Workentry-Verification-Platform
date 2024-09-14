import 'package:app/Screens/take_idcard.dart';
import 'package:app/Widgets/register_btn.dart';
import 'package:app/Screens/error_page.dart';
import 'package:provider/provider.dart';
import 'package:app/States/register_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RegisterCard extends StatefulWidget {
  const RegisterCard({super.key});

  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  void _prevPage() {
    Navigator.pop(context, true);
  }

  void _submit() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Register ID Card'),
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
                    Text('ID Card',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28.0)),
                    SizedBox(height: 12),
                    Text('To take an employee id card picture.'),
                  ],
                ),
              ),
            ),
            Consumer<RegisterForm>(
                builder: (_, value, __) => (value.card == null)
                    ? const EmptyImage()
                    : ShowImage(img: value.card!)),
            Column(
              children: [
                MaterialButton(
                  onPressed: () {
                    availableCameras().then((cameras) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) {
                          if (cameras.isEmpty) {
                            return const ErrorPage(
                                tabName: "ID Card",
                                message: "No camera available.");
                          }
                          final camera = cameras.firstWhere(
                              (element) =>
                                  element.lensDirection ==
                                  CameraLensDirection.back,
                              orElse: () => cameras.first);
                          return TakeIDCard(camera: camera);
                        }),
                      );
                    });
                  },
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
            const SizedBox(height: 22),
            Consumer<RegisterForm>(
                builder: (_, value, __) => RegisterButtonLayout(
                      onPrev: _prevPage,
                      nextTitle: 'Submit',
                      onNext: (value.card == null) ? null : _submit,
                    )),
          ]),
        ));
  }
}

class EmptyImage extends StatelessWidget {
  const EmptyImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      margin: const EdgeInsets.only(bottom: 28.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.blue.shade200,
              strokeAlign: BorderSide.strokeAlignCenter)),
      child: Center(
          child: Text(
        'ID Card',
        style: TextStyle(color: Colors.blue.shade200),
      )),
    );
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({super.key, required this.img});

  final XFile img;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 28.0),
      // padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.file(File(img.path)),
    );
  }
}
