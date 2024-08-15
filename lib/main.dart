import 'package:flutter/material.dart';
import 'game.dart';

void main() => runApp(FlappyBird());

class FlappyBird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird',
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
