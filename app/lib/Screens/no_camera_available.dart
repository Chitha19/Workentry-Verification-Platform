import 'package:flutter/cupertino.dart';

class NoCameraAvailable extends StatelessWidget {
  const NoCameraAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Face Scan'),
        ),
        child: Center(
          child: Text(
            "No camera available",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))
        )
    );
  }
}
