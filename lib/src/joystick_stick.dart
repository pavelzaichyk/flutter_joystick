import 'package:flutter/material.dart';
import 'package:flutter_joystick/src/utils.dart';

class JoystickStick extends StatelessWidget {
  final Color color;
  final Color? shadowColor;
  final double size;

  const JoystickStick({
    this.color = Colors.lightBlue,
    this.shadowColor,
    this.size = 50,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? color.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorUtils.darken(color),
            ColorUtils.lighten(color),
          ],
        ),
      ),
    );
  }
}
