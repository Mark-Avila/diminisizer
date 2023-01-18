import 'package:camera/camera.dart';
import 'package:diminisizer/screens/camera.dart';
import 'package:diminisizer/screens/game.dart';
import 'package:diminisizer/screens/landing.dart';
import 'package:diminisizer/screens/players.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // // Obtain a list of the available cameras on the device.
  // final cameras = await availableCameras();

  // // Get a specific camera from the list of available cameras.
  // final firstCamera = cameras.first;

  runApp(
    App(
        // camera: firstCamera,
        ),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
    // required this.camera,
  });

  // final CameraDescription camera;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Landing(
      //   camera: camera,
      // ),
      home: const Game(
        imagePath: "bruh",
        playerNumbers: 5,
      ),
    );
  }
}
