import 'package:app/Screens/error_page.dart';
import 'package:app/Screens/face_scan.dart';
import 'package:camera/camera.dart';
import 'package:app/States/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Checkin extends StatelessWidget {
  const Checkin({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context, listen: false);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Check In'),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Consumer<Profile>(
                builder: (_, value, __) => Text(
                      "Hello ${profile.name}",
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    )),
            const SizedBox(height: 30),
            CupertinoButton(
                onPressed: () {
                  availableCameras().then((cameras) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) {
                        if (cameras.isEmpty) {
                          return const ErrorPage(tabName: "Face Scan", message: "No camera available.");
                        }
                        final camera = cameras.firstWhere(
                          (element) => element.lensDirection == CameraLensDirection.front, 
                          orElse: () => cameras.first
                        );
                        return FaceScan(camera: camera);
                      }),
                    );
                  });
                },
                child: const Text('Check In')),
          ],
        ),
      ),
    );
  }
}
