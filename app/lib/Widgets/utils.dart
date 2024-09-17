import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  late BuildContext context;

  Utils(this.context);

  Future<void> startLoading() async {
    return await showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  void showError(String message) {
    showCupertinoModalPopup<void>(
      context: context,
      // barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        width: MediaQuery.of(context).size.width - 48,
        padding: const EdgeInsets.only(top: 22.0, bottom: 22.0, left: 14.0, right: 14.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 54,
        ),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(14),
        ),
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: false,
          child: Text(
            message,
            style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
