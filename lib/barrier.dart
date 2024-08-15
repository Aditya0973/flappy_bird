import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final double width;
  final double height;
  final double xPosition;
  final bool isThisTopBarrier;

  Barrier({
    required this.width,
    required this.height,
    required this.xPosition,
    required this.isThisTopBarrier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * xPosition + width) / (2 - width),
          isThisTopBarrier ? -1 : 1),
      child: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width * width / 2, // Adjust width here
        height: MediaQuery.of(context).size.height * 3 / 4 * height / 2,
      ),
    );
  }
}
