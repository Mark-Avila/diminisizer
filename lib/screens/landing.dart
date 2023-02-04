import 'package:camera/camera.dart';
import 'package:diminisizer/screens/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Landing extends StatefulWidget {
  final CameraDescription camera;

  const Landing({super.key, required this.camera});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final double lottieSize = 300;

  void onStartPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Camera(
          camera: widget.camera,
          dividedPieces: const [],
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
              Column(
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
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "CSE2 - Decision Theory",
                      style: GoogleFonts.roboto(
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Developed by Group 1",
                    style: GoogleFonts.roboto(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              Lottie.asset(
                'assets/divider.json',
                repeat: true,
                height: lottieSize,
                width: lottieSize,
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
