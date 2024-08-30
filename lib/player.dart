import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  MyPlayer({super.key, required this.playerX});

  double playerX = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          child: Image.asset("lib/images/Cat.png"),
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}
