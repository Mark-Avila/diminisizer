import 'package:camera/camera.dart';
import 'package:diminisizer/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

const maxVal = 7;
const minVal = 3;

const defaultColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.amber,
  Colors.pink,
  Colors.purple,
  Colors.orange
];

class Players extends StatefulWidget {
  final String imagePath;

  const Players({super.key, required this.imagePath});

  @override
  State<Players> createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  final PageController _pageController = PageController();
  num players = 3;

  void onRightPressed() {
    if (players < maxVal) {
      setState(() {
        players = players + 1;
      });
    }
  }

  void onLeftPressed() {
    if (players > minVal) {
      setState(() {
        players = players - 1;
      });
    }
  }

  void onPlayerNumbersComplete() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPlayerNumbersBack() {
    Navigator.pop(context);
  }

  void onPlayerChooseDividerBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void onStart() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Game(
    //       imagePath: widget.imagePath,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 27, 26, 36),
        ),
        padding: const EdgeInsets.all(8.0),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            PlayerNumbers(
              value: players,
              onLeftPressed: onLeftPressed,
              onRightPressed: onRightPressed,
              onComplete: onPlayerNumbersComplete,
              onBack: onPlayerNumbersBack,
            ),
            PlayerChooseDivider(
              players: players,
              onBack: onPlayerChooseDividerBack,
              onStart: onStart,
            ),
          ],
        ),
      ),
    );
  }
}

typedef OnPressed = void Function();

class PlayerNumbers extends StatefulWidget {
  final num value;
  final OnPressed onRightPressed;
  final OnPressed onLeftPressed;
  final OnPressed onComplete;
  final OnPressed onBack;

  const PlayerNumbers({
    super.key,
    required this.value,
    required this.onLeftPressed,
    required this.onRightPressed,
    required this.onComplete,
    required this.onBack,
  });

  @override
  State<PlayerNumbers> createState() => _PlayerNumbersState();
}

class _PlayerNumbersState extends State<PlayerNumbers> {
  final double iconSize = 48.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: widget.onBack,
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.angleLeft,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Back",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Choose number of players",
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: widget.onLeftPressed,
                      icon: const FaIcon(FontAwesomeIcons.angleLeft),
                      color: Colors.white,
                      iconSize: iconSize,
                    ),
                    SizedBox(
                      width: 96.0,
                      child: Center(
                        child: Text(
                          widget.value.toString(),
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 96.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onRightPressed,
                      icon: const FaIcon(FontAwesomeIcons.angleRight),
                      color: Colors.white,
                      iconSize: iconSize,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 18.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(18.0),
                    ),
                  ),
                  onPressed: widget.onComplete,
                  child: Text(
                    "Continue",
                    style: GoogleFonts.roboto(),
                  ),
                ),
              ),
            ],
          ),
          const Center(),
        ],
      ),
    );
  }
}

class PlayerChooseDivider extends StatefulWidget {
  final num players;
  final OnPressed onBack;
  final OnPressed onStart;

  const PlayerChooseDivider({
    super.key,
    required this.players,
    required this.onBack,
    required this.onStart,
  });

  @override
  State<PlayerChooseDivider> createState() => _PlayerDividChooseerState();
}

class _PlayerDividChooseerState extends State<PlayerChooseDivider> {
  List<Widget> _renderItems() {
    List<Widget> widgetItems = [];

    bool flag = true;

    for (var idx = 0; idx < widget.players; idx++) {
      if (idx > 0) {
        flag = false;
      }

      widgetItems.add(
        PlayerItem(color: defaultColors[idx], number: idx + 1, role: flag),
      );
    }

    return widgetItems;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64.0,
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.only(left: 0),
                      ),
                    ),
                    onPressed: widget.onBack,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          child: const FaIcon(
                            FontAwesomeIcons.angleLeft,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Overview of users",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(color: Colors.white),
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: _renderItems(),
          ),
          SizedBox(
            height: 48.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onStart,
              child: Text(
                "Start",
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerItem extends StatelessWidget {
  final num number;
  final bool role; //true = divider
  final MaterialColor color;

  const PlayerItem({
    Key? key,
    required this.color,
    required this.number,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        height: 64.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
            border: Border.all(
              width: 2.0,
              color: color,
            ),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12.0),
                child: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  color: color,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 12.0),
                child: FaIcon(
                  FontAwesomeIcons.user,
                  color: color,
                ),
              ),
              Text(
                "P$number",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              role
                  ? Expanded(
                      child: Text(
                        "(Divider)",
                        textAlign: TextAlign.end,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    )
                  : const Center(),
            ],
          ),
        ),
      ),
    );
  }
}
