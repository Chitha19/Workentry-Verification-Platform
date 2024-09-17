import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/error_controller.dart';
import 'package:get/get.dart';

class ErrorView extends GetView<ErrorController> {
  const ErrorView(
      {super.key,
      this.title = 'Error',
      this.message = 'Something went wrong. Please try again later'});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
        ),
        child: Center(
            child: Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: "Netflix",
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold))));
  }
}
