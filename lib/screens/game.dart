import 'dart:io';
import 'dart:math';

import 'package:diminisizer/screens/done.dart';
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
  int index;
  bool role;
  double value = 0;
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
  double _playerSum = 0;
  double _currMax = 1;
  double _spinnerStopAt = 0;
  bool _onDividerPickerDone = false;
  bool _hasChosenDivider = false;
  bool _isGameDone = false;

  final double size = 310.0;
  final double buttonHeight = 64.0;

  final Color userColor = Colors.indigo;

  @override
  void initState() {
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
    super.initState();
  }

  Player getCurrPlayer() {
    return _playerSession[_currentPlayer];
  }

  void onChange(double v) {
    if (v <= _currMax) {
      setState(() {
        value = v;
      });
    }
  }

  void _getNewStart() {
    double playerSum = 0;

    for (Player item in _players) {
      playerSum += item.value;
      // print(item.value);
    }

    setState(() {
      _playerSum = playerSum;
    });
  }

  void _beforeGameDone() {
    setState(() {
      _isGameDone = true;
    });

    _goToNextPlayer();
  }

  void _onLastDeny() {
    Player player1 = _playerSession[0];
    Player player2 = _playerSession[1];

    if (player1.role) {
      player1.value = value;
      player2.value = 1 - _playerSum - value;
    } else if (player2.role) {
      player1.value = 1 - _playerSum - value;
      player2.value = value;
    }

    _players[player1.index] = player1;
    _players[player2.index] = player2;

    _beforeGameDone();
  }

  void _onLastAccept() {
    Player player1 = _playerSession[0];
    Player player2 = _playerSession[1];

    if (player1.role) {
      player1.value = 1 - _playerSum;
      player2.value = value;
    } else if (player2.role) {
      player1.value = value;
      player2.value = 1 - _playerSum;
    }

    _players[player1.index] = player1;
    _players[player2.index] = player2;

    _beforeGameDone();
  }

  void _goToNextPlayer() {
    if (_isGameDone) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Done(
            players: _players,
          ),
        ),
      );
    } else if (_hasChosenDivider) {
      if (!_playerSession[_currentPlayer].role) {
        setState(() {
          _currentPlayer++;
        });
      }
    } else if (_currentPlayer >= _playerSession.length - 1) {
      late Player tempPlayer;
      num dividers = 0;

      for (Player item in _playerSession) {
        if (item.role) {
          tempPlayer = item;
          dividers++;
        }
      }

      double start = 0;

      for (Player item in _players) {
        start += item.value;
      }

      tempPlayer.isDone = true;
      tempPlayer.value = value;
      int playerIndex = tempPlayer.index;

      int getIndex = 0;

      for (Player item in _players) {
        if (item.index == playerIndex) {
          getIndex = item.index;
        }
      }

      _players[getIndex] = tempPlayer;

      setState(() {
        _currStack.add(
          CircleDivide(
            value: value,
            userColor: defaultColors[tempPlayer.index],
            start: start * 100,
          ),
        );
      });

      List<Player> tempSession = List.from(_playerSession);

      tempSession.removeWhere((item) => item.index == playerIndex);
      _playerSession = tempSession;

      //If the starting divider is the piece receiver,
      //set the player at the start as the dividider
      if (dividers == 1) {
        _playerSession[0].role = true;
      } else {
        //reset all roles, and assign starting player as divider
        for (Player item in _playerSession) {
          item.role = false;
          _playerSession[0].role = true;
        }
      }

      _getNewStart();

      _currMax = 1 - _playerSum;

      setState(() {
        _currentPlayer = 0;
      });
    } else {
      setState(() {
        _currentPlayer++;
      });
    }
  }

  void _goBackToStartPlayer() {
    setState(() {
      _currentPlayer = 0;
    });
  }

  void _onDividerPickerStop() {
    final random = Random();
    final decision = random.nextBool();

    if (decision) {
      _playerSession[1].role = true;
      _playerSession[0].role = false;

      setState(() {
        _spinnerStopAt = 0.75;
      });
    } else {
      _playerSession[0].role = false;
      _playerSession[1].role = true;

      setState(() {
        _spinnerStopAt = 0.25;
      });
    }

    setState(() {
      _onDividerPickerDone = true;
    });
  }

  void _onStartDuo() {
    setState(() {
      _hasChosenDivider = true;
    });

    _goToNextPlayer();
  }

  void _onAcceptStart() {
    setState(() {
      _currentDivide = value;
    });

    value = _currentDivide;

    _goToNextPlayer();
  }

  void _onChooseAbove() {
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

  void _onChooseBelow() {
    _goToNextPlayer();
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
            _playerSession.length == 2 && !_hasChosenDivider
                ? DividerPicker(
                    stopAt: _spinnerStopAt,
                    currentPlayers: _playerSession,
                  )
                : Column(
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
                                      color:
                                          defaultColors[getCurrPlayer().index],
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
                              userColor: Colors.white,
                              start: _playerSum * 100,
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
                  _playerSession.length == 2 && !_hasChosenDivider
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _onDividerPickerDone
                                  ? _onStartDuo
                                  : _onDividerPickerStop,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  _onDividerPickerDone
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              child: Text(
                                _onDividerPickerDone ? "START" : "STOP",
                                style: GoogleFonts.ibmPlexMono(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : getCurrPlayer().role
                          ? AcceptWrapper(
                              color: Colors.blue,
                              value: value,
                              max: _currMax,
                              // max: 1 - value,
                              onChange: onChange,
                              onStart: _hasChosenDivider
                                  ? _goBackToStartPlayer
                                  : _onAcceptStart,
                            )
                          : ChooseWrapper(
                              buttonHeight: buttonHeight,
                              onAbove: _hasChosenDivider
                                  ? _onLastAccept
                                  : _onChooseAbove,
                              onBelow: _hasChosenDivider
                                  ? _onLastDeny
                                  : _onChooseBelow,
                            ),
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

class DividerPicker extends StatefulWidget {
  const DividerPicker(
      {super.key, required this.stopAt, required this.currentPlayers});

  final double stopAt;
  final List<Player> currentPlayers;

  @override
  State<DividerPicker> createState() => _DividerPickerState();
}

class _DividerPickerState extends State<DividerPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AnimationController _shouldSpin() {
    if (widget.stopAt == 0) {
      _controller.repeat();
      return _controller;
    }

    _controller.animateTo(widget.stopAt);
    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "P${widget.currentPlayers[0].index + 1}",
          style: GoogleFonts.ibmPlexMono(
            color: defaultColors[widget.currentPlayers[0].index],
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_shouldSpin()),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 18.0),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset("arrow.png"),
            ),
          ),
        ),
        Text(
          "P${widget.currentPlayers[1].index + 1}",
          style: GoogleFonts.ibmPlexMono(
            color: defaultColors[widget.currentPlayers[1].index],
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
