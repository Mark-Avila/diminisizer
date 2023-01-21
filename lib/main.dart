import 'package:camera/camera.dart';
import 'package:diminisizer/screens/done.dart';
import 'package:diminisizer/screens/game.dart';
import 'package:diminisizer/screens/landing.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    App(
      camera: firstCamera,
    ),
  );
}

class App extends StatelessWidget {
  App({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  final List<Player> players = [
    Player(0, 0.14, false),
    Player(1, 0.14, false),
    Player(2, 0.14, false),
    Player(3, 0.14, false),
    Player(4, 0.14, false),
    Player(5, 0.14, false),
    Player(6, 0.14, false),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Landing(
        camera: camera,
      ),
    );
  }
}
