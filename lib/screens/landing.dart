import 'package:camera/camera.dart';
import 'package:diminisizer/screens/camera.dart';
import 'package:diminisizer/screens/players.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Landing extends StatefulWidget {
  final CameraDescription camera;

  const Landing({super.key, required this.camera});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  void onStartPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Camera(
          camera: widget.camera,
          dividedPieces: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 27, 26, 36),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "DIMINISIZER",
                style: GoogleFonts.ibmPlexMono(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                  ),
                ),
              ),
              SizedBox(
                width: 256,
                height: 48,
                child: ElevatedButton(
                  onPressed: onStartPressed,
                  child: Text(
                    "START",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
