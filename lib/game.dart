import 'package:flutter/material.dart';
import 'bird.dart';
import 'barrier.dart';
import 'score.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double birdYAxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = 0;
  bool gameHasStarted = false;
  int score = 0;
  int bestScore = 0;
  double barrierXOne = 1;
  double barrierXTwo = 2;

  double barrierHeightOne = 0.55; // height for collision detection
  double barrierHeightTwo = 0.65;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYAxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;

      setState(() {
        birdYAxis = initialHeight - height;

        barrierXOne -= 0.05;
        barrierXTwo -= 0.05;

        if (barrierXOne < -1.5) {
          barrierXOne += 3;
          score++;
        }

        if (barrierXTwo < -1.5) {
          barrierXTwo += 3;
          score++;
        }

        // Collision detection with barriers
        if (checkCollision(barrierXOne, barrierHeightOne) ||
            checkCollision(barrierXTwo, barrierHeightTwo)) {
          timer.cancel();
          gameHasStarted = false;
          _showGameOverDialog();
        }

        // Bird dies if it goes out of screen bounds
        if (birdYAxis > 1 || birdYAxis < -1) {
          timer.cancel();
          gameHasStarted = false;
          _showGameOverDialog();
        }
      });
    });
  }

  bool checkCollision(double barrierX, double barrierHeight) {
    // Check if the bird is horizontally aligned with the barrier
    if (barrierX < 0.25 && barrierX > -0.25) {
      // Check if the bird is within the height range of the barrier
      if (birdYAxis < -1 + barrierHeight || birdYAxis > 1 - barrierHeight) {
        return true;
      }
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      birdYAxis = 0;
      time = 0;
      height = 0;
      initialHeight = 0;
      gameHasStarted = false;
      score = 0;
      barrierXOne = 1;
      barrierXTwo = 2;
    });
  }

  void _showGameOverDialog() {
    if (score > bestScore) {
      bestScore = score;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("Your score is: $score\nBest score: $bestScore"),
          actions: <Widget>[
            TextButton(
              child: Text("RESTART"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Stack(
                children: <Widget>[
                  AnimatedContainer(
                    alignment: Alignment(0, birdYAxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: Bird(),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXOne, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: Barrier(
                      width: 0.4,
                      height: barrierHeightOne,
                      xPosition: barrierXOne,
                      isThisTopBarrier: false,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXOne, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: Barrier(
                      width: 0.4,
                      height: 0.55,
                      xPosition: barrierXOne,
                      isThisTopBarrier: true,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXTwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: Barrier(
                      width: 0.4,
                      height: barrierHeightTwo,
                      xPosition: barrierXTwo,
                      isThisTopBarrier: false,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXTwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: Barrier(
                      width: 0.4,
                      height: 0.45,
                      xPosition: barrierXTwo,
                      isThisTopBarrier: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment(0, -0.3),
                    child: gameHasStarted
                        ? Text("")
                        : Text(
                            "TAP TO START",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Score(score: score),
                        Text(
                          "Best: $bestScore",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Added Text
                    Text(
                      "Created by Aditya Kumar",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
