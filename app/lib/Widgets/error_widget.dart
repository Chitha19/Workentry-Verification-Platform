import 'package:flutter/cupertino.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "Netflix",
                fontSize: 24.0,
                fontWeight: FontWeight.bold)));
  }
}
