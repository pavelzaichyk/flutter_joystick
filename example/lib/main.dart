import 'package:flutter/material.dart';
import 'package:joystick/joystick.dart';

void main() {
  runApp(JoystickExampleApp());
}

class JoystickExampleApp extends StatefulWidget {
  @override
  _JoystickExampleAppState createState() => _JoystickExampleAppState();
}

class _JoystickExampleAppState extends State<JoystickExampleApp> {
  final fieldHeight = 400.0;
  final fieldWidth = 300.0;
  final step = 5;
  double x = 140;
  double y = 140;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Joystick Example'),
        ),
        body: Container(
          width: double.infinity,
          color: Colors.grey,
          child: JoystickArea(
            onStickUpdate: (details) {
              print(details.offset);
              var newX = x + step * details.offset.dx;
              var newY = y + step * details.offset.dy;
              newX = newX < 0
                  ? 0
                  : (newX > fieldWidth - 20 ? fieldWidth - 20 : newX);
              newY = newY < 0
                  ? 0
                  : (newY > fieldHeight - 20 ? fieldHeight - 20 : newY);
              setState(() {
                x = newX;
                y = newY;
              });
            },
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.green,
                      width: fieldWidth,
                      height: fieldHeight,
                    ),
                    Positioned(
                      left: x,
                      top: y,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // Joystick(onStickUpdate: (details) {
                //   print(details.offset);
                //   var newX = x + step * details.offset.dx;
                //   var newY = y + step * details.offset.dy;
                //   newX = newX < 0
                //       ? 0
                //       : (newX > fieldWidth - 20 ? fieldWidth - 20 : newX);
                //   newY = newY < 0
                //       ? 0
                //       : (newY > fieldHeight - 20 ? fieldHeight - 20 : newY);
                //   setState(() {
                //     x = newX;
                //     y = newY;
                //   });
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
