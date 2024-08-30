import 'dart:async';
import 'package:bubble_trouble_game/ball.dart';
import 'package:bubble_trouble_game/button.dart';
import 'package:bubble_trouble_game/missile.dart';
import 'package:bubble_trouble_game/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum direction { LEFT, RIGHT }

class _HomepageState extends State<Homepage> {
  //player Variables
  static double playerX = 0;

  // missile variables
  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

  // ball variables
  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = direction.LEFT;

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60;

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = -5 * time * time + velocity * time;

      if (height < 0) {
        time = 0;
      }

      setState(() {
        ballY = heightToPosition(height);
      });

      if (ballX - 0.005 < -1) {
        ballDirection = direction.RIGHT;
      } else if (ballX + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }
      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.005;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballX += 0.005;
        });
      }
      if (PlayersDies()){
        timer.cancel();
        _showDialog();
      }

      time += 0.1;
    });
  }

  void _showDialog() {
    showDialog(context: context, builder:(BuildContext  context){
      return AlertDialog(
        backgroundColor: Colors.grey[700],
        title: const Center(
          child: Text('You Dead Bro',style: TextStyle(color: Colors.white),),
        ),
      );
    });
  }

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
        // do nothing
      } else {
        playerX -= 0.1;
      }
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        // do nothing
      } else {
        playerX += 0.1;
      }
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(Duration(milliseconds: 20), (timer) {
        // mm shot fired
        midShot = true;
        setState(() {
          missileHeight += 10;
        });

        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          // stop missile
          resetMissile();
          timer.cancel();
        }

        if (ballY > heightToPosition(missileHeight) &&
            (ballX - missileX.abs() < 0.03)) {
          resetMissile();
          ballY = 5;
          timer.cancel();
        }
      });
    }
  }

  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 0;
    midShot = false;
  }

  // players Dies
  bool PlayersDies() {
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (event) {
          // if (event.physicalKey == LogicalKeyboardKey.arrowLeft) {
          //   moveLeft();
          // } else if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
          //   moveRight();
          // }
        },
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  color: Colors.pink[100],
                  child: Center(
                    child: Stack(
                      children: [
                        MyBall(ballX: ballX, ballY: ballY),
                        MyMissile(
                          missileX: playerX,
                          height: missileHeight,
                        ),
                        MyPlayer(playerX: playerX),
                      ],
                    ),
                  ),
                )),
            Expanded(
                child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.play_arrow,
                    function: startGame,
                  ),
                  MyButton(
                    icon: Icons.arrow_back,
                    function: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    function: fireMissile,
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    function: moveRight,
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}
