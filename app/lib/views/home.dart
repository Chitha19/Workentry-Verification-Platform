import 'package:flutter/cupertino.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Home'),
        ),
        child: Center(
          child: Text('This is Home page'),
        ));
  }
}
