import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  final int score;

  Score({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0),
      child: Text(
        score.toString(),
        style: TextStyle(
          fontSize: 60,
          color: Colors.white,
        ),
      ),
    );
  }
}
