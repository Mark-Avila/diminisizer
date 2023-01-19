import 'package:diminisizer/screens/game.dart';
import 'package:flutter/material.dart';

class Done extends StatefulWidget {
  final List<Player> players;

  const Done({super.key, required this.players});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  List<Widget> _generatePieces() {
    double start = 0;
    List<Widget> widgets = [];

    for (Player item in widget.players) {
      widgets.add(CircleDivide(
        value: item.value,
        userColor: defaultColors[item.index],
        start: start,
      ));

      start += item.value * 100;
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 310,
        height: 310,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
          image: const DecorationImage(
            // image: FileImage(File(widget.imagePath)),
            image: AssetImage("background-test-3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: _generatePieces(),
        ),
      ),
    );
  }
}
