import 'package:flutter/cupertino.dart';

class Error extends StatelessWidget {
  const Error(
      {super.key,
      this.tabName = 'Error',
      this.message = 'Something went wrong. Please try again later'});

  final String tabName;
  final String message;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(tabName),
        ),
        child: Center(
            child: Text(message,
                style: const TextStyle(
                    fontFamily: "Netflix",
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold))));
  }
}
