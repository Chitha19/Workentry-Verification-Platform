import 'package:flutter/material.dart';

class InputPartLayout extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InputPartLayout(
      {super.key, required this.title, required this.children});

  List<Widget> createChildren() {
    List<Widget> joined = [];
    for (var i = 0; i < children.length; i++) {
      joined.add(SizedBox(height: 50, child: children[i]));
      if (i != children.length - 1) {
        joined.add(const Divider(
          thickness: 1,
          color: Colors.grey,
        ));
      }
    }
    return joined;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 20),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(title,
                        style: const TextStyle(
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
                  children: createChildren()),
            )
          ],
        ));
  }
}
