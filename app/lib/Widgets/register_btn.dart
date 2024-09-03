import 'package:flutter/cupertino.dart';

class RegisterButtonLayout extends StatelessWidget {
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final String? prevTitle;
  final String? nextTitle;

  const RegisterButtonLayout({
    super.key,
    this.nextTitle = "Next",
    this.prevTitle = "Back",
    this.onNext,
    this.onPrev
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            onPressed: onPrev,
            child: Text(
              prevTitle!,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          CupertinoButton(
            onPressed: onNext,
            child: Text(
              nextTitle!,
              style: const TextStyle(fontSize: 18.0),
            ),
          )
        ],
      ),
    );
  }
}
