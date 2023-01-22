import 'dart:io';

import 'package:camera/camera.dart';
import 'package:diminisizer/screens/camera.dart';
import 'package:diminisizer/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Done extends StatefulWidget {
  final List<Player> players;
  final CameraDescription camera;
  final String path;

  const Done({
    super.key,
    required this.players,
    required this.camera,
    required this.path,
  });

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  ///Generates the pieces for each user
  List<Widget> _generatePieces() {
    double start = 0;
    List<Widget> widgets = [];

    for (Player item in widget.players) {
      widgets.add(CircleDivide(
        value: item.value,
        userColor: defaultColors[item.index],
        start: start,
      ));

      ///Player piece value is scaled 0-1, convert to 1-100
      start += item.value * 100;
    }

    return widgets;
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DoneHeader(
                players: widget.players,
              ),
              DividedDisplay(
                path: widget.path,
                children: _generatePieces(),
              ),
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Camera(
                          camera: widget.camera,
                          dividedPieces: widget.players,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "START DIVIDING",
                    style: GoogleFonts.ibmPlexMono(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoneHeader extends StatelessWidget {
  const DoneHeader({
    Key? key,
    required this.players,
  }) : super(key: key);

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "DIVIDING DONE!",
          style: GoogleFonts.ibmPlexMono(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              for (Player item in players)
                Text(
                  "P${item.index + 1}",
                  style: GoogleFonts.ibmPlexMono(
                    color: defaultColors[item.index],
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class DividedDisplay extends StatelessWidget {
  const DividedDisplay({
    Key? key,
    required this.children,
    required this.path,
  }) : super(key: key);

  final String path;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: 310,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        image: DecorationImage(
          image: FileImage(File(path)),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: children,
      ),
    );
  }
}
