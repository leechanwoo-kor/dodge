import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dodge/game_manager.dart';
import 'package:dodge/global.dart';

class MenuOverlay extends StatefulWidget {
  MenuOverlay({Key? key, required this.game}) : super(key: key);

  final GameManager game;
  final state = _MenuOverlayState();

  @override
  State<MenuOverlay> createState() => state;

  void refreshScreen() {
    state.refreshScreen();
  }
}

class _MenuOverlayState extends State<MenuOverlay> {
  final String resumeText = "RESUME";
  final String startText = "START";
  final String pauseText = "PAUSE";
  final String overText = "GAME OVER";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: gameStatusButtonClick,
              child: Global.isRun()
                  ? Text(pauseText)
                  : Global.isPause()
                      ? Text(resumeText)
                      : Text(startText),
            ),
          ],
        ),
        (Global.isPause() || Global.isOver()) ? const SizedBox(height: 80) : const SizedBox.shrink(),
        Column(
          children: [
            (Global.isPause() || Global.isOver())
                ? Column(
                    children: [
                      Global.isPause()
                          ? Text(
                              pauseText,
                              style: const TextStyle(color: Colors.white, fontSize: 80),
                            )
                          : Text(
                              overText,
                              style: const TextStyle(color: Colors.red, fontSize: 80),
                            ),
                      const SizedBox(height: 200),
                      Text(
                        "LEVEL : ${Global.level}",
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "SPEED : ${Global.gameSpeed}",
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "MISSILE : ${widget.game.missiles.length}",
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(height: 62),
                      Text(
                        "SCORE : ${Global.score.toStringAsFixed(4)}",
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(height: 500),
                      Text(
                        "SCORE : ${Global.score.toStringAsFixed(4)}",
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
          ],
        ),
      ],
    );
  }

  void gameStatusButtonClick() {
    if (Global.isRun()) {
      Global.status = GameStatus.pause;
    } else if (Global.isPause()) {
      Global.status = GameStatus.run;
    } else {
      widget.game.restart();
    }
    setState(() {});
  }

  void refreshScreen() {
    setState(() {});
  }
}
