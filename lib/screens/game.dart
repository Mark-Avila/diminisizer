import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

typedef AcceptCallback = void Function(double value)?;
typedef OnPressed = void Function()?;

const defaultColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.amber,
  Colors.pink,
  Colors.purple,
  Colors.orange
];

class Player {
  //Player index, in this case the turn
  int index;

  //Player role, where 'true' is the divider
  bool role;

  //Player piece value once done
  double value = 0;

  //Player status, where false states that the player has no piece yey
  bool isDone = false;

  Player(this.index, this.value, this.role);
}

class Game extends StatefulWidget {
  final String imagePath;
  final num playerNumbers;

  const Game({
    Key? key,
    required this.imagePath,
    required this.playerNumbers,
  }) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  double value = 0;
  double max = 0;

  //States
  bool _isLoading = true;
  List<Player> _players = [];

  //Values for ingame mechanices
  double _currentDivide = 0;
  int _currentPlayer = 0;
  List<Player> _playerSession = [];
  List<Widget> _currStack = [];

  final double size = 310.0;
  final double buttonHeight = 64.0;

  final Color userColor = Colors.indigo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Player> tempPlayers = [];

      for (int i = 0; i < widget.playerNumbers; i++) {
        tempPlayers.add(Player(i, 0, i == 0 ? true : false));
      }

      setState(() {
        _players = tempPlayers;
        _playerSession = tempPlayers;
        _isLoading = false;
      });
    });
  }

  Player getCurrPlayer() {
    return _playerSession[_currentPlayer];
  }

  void onChange(double v) {
    setState(() {
      value = v;
    });
  }

  void goToNextPlayer() {
    if (_currentPlayer >= _playerSession.length - 1) {
      late Player tempPlayer;
      num dividers = 0;

      for (Player item in _playerSession) {
        if (item.role) {
          tempPlayer = item;
          dividers++;
        }
      }

      tempPlayer.isDone = true;
      tempPlayer.value = value;
      int playerIndex = tempPlayer.index;

      _players[_playerSession.indexWhere(
        (item) => item.index == playerIndex,
      )] = tempPlayer;

      _playerSession.removeWhere((item) => item.index == playerIndex);

      //If the starting divider is the piece receiver,
      //set the player at the start as the dividider
      if (dividers == 1) {
        _playerSession[0].role = true;
      }

      // goBackToStartPlayer();
      setState(() {
        _currentPlayer = 0;
      });
    } else {
      setState(() {
        _currentPlayer++;
      });
    }
  }

  void goBackToStartPlayer() {
    int tempIndex = 0;
    for (Player item in _playerSession) {
      if (!item.isDone) {
        tempIndex = item.index;
        break;
      }
    }

    setState(() {
      _currentPlayer = tempIndex;
    });
  }

  void onAcceptStart() {
    setState(() {
      _currentDivide = value;
    });

    value = _currentDivide;

    goToNextPlayer();
  }

  void onChooseAbove() {
    Player currPlayer = getCurrPlayer();

    //Set as divider
    currPlayer.role = true;
    int currPlayerIndex = currPlayer.index;

    setState(() {
      _playerSession[_playerSession.indexWhere(
        (item) => item.index == currPlayerIndex,
      )] = currPlayer;
    });
  }

  void onChooseBelow() {
    goToNextPlayer();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 27, 26, 36),
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

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
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 0, 14, 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Current:",
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              "P${getCurrPlayer().index + 1} ${getCurrPlayer().role ? "(Divider)" : ""}",
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 18.0,
                                color: defaultColors[getCurrPlayer().index],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Fair share: ${(100 / widget.playerNumbers).toStringAsFixed(0)}%",
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
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
                      // image: FileImage(File(widget.imagePath)),
                      image: AssetImage("background-test-3.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      for (var item in _currStack) item,
                      CircleDivide(
                        value: value,
                        userColor: userColor,
                        start: 0,
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
                  getCurrPlayer().role
                      ? AcceptWrapper(
                          color: Colors.blue,
                          value: value,
                          max: 1,
                          // max: 1 - value,
                          onChange: onChange,
                          onStart: onAcceptStart,
                        )
                      : ChooseWrapper(
                          buttonHeight: buttonHeight,
                          onAbove: onChooseAbove,
                          onBelow: onChooseBelow,
                        ),
                  // ChooseWrapper(buttonHeight: buttonHeight)
                  // AcceptWrapper(
                  //   color: Colors.blue,
                  //   value: value,
                  //   max: 1,
                  //   // max: 1 - value,
                  //   onChange: onChange,
                  //   onStart: onAcceptStart,
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleDivide extends StatelessWidget {
  const CircleDivide({
    Key? key,
    required this.value,
    required this.userColor,
    required this.start,
  }) : super(key: key);

  final double value;
  final Color userColor;
  final double start;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: CirclePaint(
          value,
          userColor.withOpacity(0.75),
          start,
        ),
      ),
    );
  }
}

class ChooseWrapper extends StatefulWidget {
  final double buttonHeight;
  final OnPressed onAbove;
  final OnPressed onBelow;

  const ChooseWrapper({
    super.key,
    required this.buttonHeight,
    required this.onAbove,
    required this.onBelow,
  });

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
                onPressed: widget.onBelow,
              ),
            ),
            Expanded(
              child: ChooseButton(
                text: "Above",
                height: widget.buttonHeight,
                background: Colors.red,
                onPressed: widget.onAbove,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AcceptWrapper extends StatefulWidget {
  final Color color;
  final double value;
  final AcceptCallback onChange;
  final Function onStart;
  final double max;

  const AcceptWrapper({
    super.key,
    required this.color,
    required this.value,
    required this.max,
    required this.onStart,
    required this.onChange,
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
            onPressed: () {
              widget.onStart();
            },
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

  CirclePaint(this.value, this.color, this.start);

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
  final OnPressed onPressed;

  const ChooseButton({
    super.key,
    required this.text,
    required this.height,
    required this.background,
    required this.onPressed,
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
        onPressed: onPressed,
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
