import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double value = .4;
  double value2 = .2;
  final double size = 310.0;
  final double buttonHeight = 64.0;

  final Color userColor = Colors.indigo;

  void onChange(double v) {
    setState(() {
      if (v < 1 - value) {
        value2 = v;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 27, 26, 36),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                ReturnButton(),
              ],
            ),
            Column(
              children: [
                const Text("Current: P1 (Divider)"),
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    image: const DecorationImage(
                      image: AssetImage("background-test-3.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: CustomPaint(
                          painter: CirclePaint(
                            value,
                            userColor.withOpacity(0.75),
                            0,
                            0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: CustomPaint(
                          painter: CirclePaint(
                            value2,
                            Colors.red.withOpacity(0.75),
                            40,
                            360 * (value / 100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AcceptWrapper(
                    color: Colors.blue,
                    value: value2,
                    onChange: onChange,
                    max: 1 - value,
                  ),
                  // ChooseWrapper(buttonHeight: buttonHeight)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerChoice {
  double value = 0;
  int playerNumber;
  Color color;

  PlayerChoice(
    this.playerNumber,
    this.value,
    this.color,
  );

  void setValue(double value) {
    this.value = value;
  }
}

class ChooseWrapper extends StatefulWidget {
  final double buttonHeight;

  const ChooseWrapper({super.key, required this.buttonHeight});

  @override
  State<ChooseWrapper> createState() => _ChooseWrapperState();
}

class _ChooseWrapperState extends State<ChooseWrapper> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ChooseLabel(),
        Row(
          children: [
            Expanded(
              child: ChooseButton(
                text: "Below",
                height: widget.buttonHeight,
                background: Colors.green,
              ),
            ),
            Expanded(
              child: ChooseButton(
                text: "Above",
                height: widget.buttonHeight,
                background: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

typedef AcceptCallback = void Function(double value)?;

class AcceptWrapper extends StatefulWidget {
  final Color color;
  final double value;
  final AcceptCallback onChange;
  final double max;

  const AcceptWrapper({
    super.key,
    required this.color,
    required this.value,
    required this.onChange,
    required this.max,
  });

  @override
  State<AcceptWrapper> createState() => _AcceptWrapperState();
}

class _AcceptWrapperState extends State<AcceptWrapper> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          margin: const EdgeInsets.only(bottom: 12.0),
          child: Slider(
            activeColor: widget.color,
            thumbColor: widget.color,
            value: widget.value,
            onChanged: widget.onChange,
            max: widget.max,
          ),
        ),
        SizedBox(
          height: 48.0,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("START"),
          ),
        )
      ],
    );
  }
}

class ChooseLabel extends StatelessWidget {
  const ChooseLabel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
      margin: const EdgeInsets.only(bottom: 18.0),
      child: Center(
        child: Text(
          "Is it below or above 20%?",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ReturnButton extends StatelessWidget {
  const ReturnButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            ),
          ),
          Text(
            "Return",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePaint extends CustomPainter {
  final double value;
  final double start;
  final Color color;
  final double max;

  CirclePaint(this.value, this.color, this.start, this.max);

  double getStartAngle(double start) {
    double deg = (360 * -start / 100) + 90;
    return -(deg * pi / 180);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.width / 2,
    );

    canvas.drawArc(
      area,
      getStartAngle(start),
      2 * pi * value,
      true,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ChooseButton extends StatelessWidget {
  final String text;
  final double height;
  final Color? background;

  const ChooseButton({
    super.key,
    required this.text,
    required this.height,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(background),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: GoogleFonts.ibmPlexMono(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
