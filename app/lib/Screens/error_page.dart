import 'package:flutter/cupertino.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.tabName, required this.message});

  final String tabName;
  final String message;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(tabName),
        ),
        child: Center(
            child: Text(
              message,
              style:
                const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
            )
        )
    );
  }
}
