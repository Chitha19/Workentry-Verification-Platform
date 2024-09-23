import 'dart:typed_data';
import 'package:app/pages/register/controllers/register_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as imglib;

class IdCard extends StatelessWidget {
  const IdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 20),
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('ID Card',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22.0)))),
            Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Obx(() => (RegisterController.to.idCard().isValid)
                      ? ShowImage(
                          img: RegisterController.to.idCard(),
                        )
                      : const EmptyImage()),
                  MaterialButton(
                    onPressed: RegisterController.to.gotoCardCapture,
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(18),
                    shape: const CircleBorder(),
                    child: const Icon(
                      CupertinoIcons.camera,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // const Text('Take Photo', style: TextStyle())
                ],
              ),
            )
          ],
        ));
  }
}

class EmptyImage extends StatelessWidget {
  const EmptyImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 360,
      // height: 200,
      margin: const EdgeInsets.only(bottom: 20.0),
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

  final imglib.Image img;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        // padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.memory(
          Uint8List.fromList(imglib.encodeJpg(img)),
        ));
  }
}
