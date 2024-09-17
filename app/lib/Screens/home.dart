import 'package:app/Screens/register.dart';
import 'package:app/Service/auth_guard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:app/Screens/error_page.dart';
import 'package:app/Screens/face_scan.dart';
import 'package:app/States/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _gotoFaceScan() {
    availableCameras().then((cameras) {
      if (cameras.isEmpty) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const ErrorPage(
                    tabName: "Face Scan", message: "No camera available.")));
        return;
      }

      final camera = cameras.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first);
      guard(context, FaceScan(camera: camera));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Home'),
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: ListView(children: [
              const SizedBox(
                height: 30,
              ),
              const Text('Hello',
                  style: TextStyle(
                      fontFamily: "Netflix",
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0)),
              Consumer<Profile>(
                  builder: (_, value, __) => Text(
                      value.name,
                      style: const TextStyle(
                          fontFamily: "Netflix",
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0))),
              const SizedBox(
                height: 30,
              ),
              _Menu(
                icon: const Icon(
                  CupertinoIcons.location_fill,
                  size: 32,
                ),
                title: 'Check In',
                onClick: _gotoFaceScan,
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
                onClick: () => guard(context, const RegisterAccount()),
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
                  print('Dashboard clicked');
                },
              )
            ])));
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
