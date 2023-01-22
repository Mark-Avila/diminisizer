import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:diminisizer/main.dart';
import 'package:diminisizer/screens/game.dart';
import 'package:diminisizer/screens/players.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class Camera extends StatefulWidget {
  const Camera({
    super.key,
    required this.camera,
    required this.dividedPieces,
  });

  final CameraDescription camera;
  final List<Player> dividedPieces;

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _generatePieces() {
    List<Widget> widgets = [];
    double start = 0;

    if (widget.dividedPieces.isNotEmpty) {
      for (Player item in widget.dividedPieces) {
        widgets.add(
          CircleDivide(
            value: item.value,
            userColor: defaultColors[item.index],
            start: start,
          ),
        );
        start += item.value * 100;
      }
    } else {
      widgets.add(
        Container(
          width: 350,
          height: 450,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 27, 26, 36),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 450,
                        width: double.infinity,
                        child: CameraPreview(_controller),
                      ),
                      SizedBox(
                        height: 450,
                        width: 350,
                        child: Stack(
                          children: _generatePieces(),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: widget.dividedPieces.isEmpty
            ? () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Attempt to take a picture and get the file `image`
                  // where it was saved.
                  final image = await _controller.takePicture();

                  if (!mounted) return;

                  // If the picture was taken, display it on a new screen.
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Players(
                        // Pass the automatically generated path to
                        // the DisplayPictureScreen widget.
                        imagePath: image.path,
                        camera: widget.camera,
                      ),
                    ),
                  );
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => App(
                        // Pass the automatically generated path to
                        // the DisplayPictureScreen widget.
                        camera: widget.camera,
                      ),
                    ),
                  );
                }
              }
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => App(
                      camera: widget.camera,
                    ),
                  ),
                );
              },
        child: widget.dividedPieces.isNotEmpty
            ? const Icon(Icons.check)
            : const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
