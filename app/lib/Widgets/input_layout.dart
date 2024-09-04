import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

class InputLayout extends StatelessWidget {
  final List<Widget> child;
  const InputLayout({super.key, required this.child});

  List<Widget> createChildren() {
    List<Widget> joined = [];

    for (var i = 0; i < child.length; i++) {
      joined.add(child[i]);

      if (i != child.length - 1) {
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
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Center(
            child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: createChildren()))));
  }
}
