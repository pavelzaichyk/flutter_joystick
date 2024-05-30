import 'package:flutter/material.dart';

class JoystickStick extends StatelessWidget {
  final MaterialColor color;
  final Color shadowColor;
  final double size;

  const JoystickStick({
    this.color = Colors.lightBlue,
    this.shadowColor = Colors.blue,
    this.size = 50,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.shade900,
            color.shade400,
          ],
        ),
      ),
    );
  }
}
