import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Home'),
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: controller.obx(
              (user) => ListView(children: [
                const SizedBox(
                  height: 30,
                ),
                const Text('Hello',
                    style: TextStyle(
                        fontFamily: "Netflix",
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0)),
                Text((user == null || user.name == '') ? 'Workers' : user.name,
                    style: const TextStyle(
                        fontFamily: "Netflix",
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0)),
                const SizedBox(
                  height: 30,
                ),
                _Menu(
                  icon: const Icon(
                    CupertinoIcons.location_fill,
                    size: 32,
                  ),
                  title: 'Check In',
                  onClick: () {
                    Get.toNamed('/facescan');
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                _Menu(
                  icon: const Icon(
                    CupertinoIcons.person_add_solid,
                    size: 32,
                  ),
                  title: 'Register',
                  onClick: () {
                    Get.toNamed('/register');
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                _Menu(
                  icon: const Icon(
                    CupertinoIcons.chart_bar_square_fill,
                    size: 32,
                  ),
                  title: 'Dashboard',
                  onClick: () {
                    print('Go to Dashboard');
                  },
                )
              ]),
              onLoading: const CupertinoActivityIndicator(),
              onError: (message) => Center(
                  child: Text(message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: "Netflix",
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold))),
            )));
  }
}

class _Menu extends StatelessWidget {
  const _Menu({required this.icon, required this.title, required this.onClick});

  final String title;
  final Icon icon;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onClick,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
              left: 14.0, right: 14.0, top: 20.0, bottom: 20.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
                BoxShadow(
                    color: Colors.grey.shade100,
                    // color: Colors.white,
                    offset: const Offset(-4, -4),
                    blurRadius: 10,
                    spreadRadius: 1),
              ]),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 14),
                child: icon,
              ),
              Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: "Netflix",
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ));
  }
}
