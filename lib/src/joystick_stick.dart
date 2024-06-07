import 'package:flutter/material.dart';
import 'package:flutter_joystick/src/utils.dart';

class JoystickStick extends StatelessWidget {
  final double size;
  final JoystickStickDecoration? decoration;

  const JoystickStick({
    this.size = 50,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = this.decoration ?? JoystickStickDecoration();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: decoration.shadowColor,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorUtils.darken(decoration.color),
            ColorUtils.lighten(decoration.color),
          ],
        ),
      ),
    );
  }
}

@immutable
class JoystickStickDecoration {
  final Color color;
  final Color shadowColor;

  const JoystickStickDecoration._internal({
    required this.color,
    required this.shadowColor,
  });

  factory JoystickStickDecoration({
    Color color = ColorUtils.defaultStickColor,
    Color? shadowColor,
  }) {
    return JoystickStickDecoration._internal(
      color: color,
      shadowColor: shadowColor ?? color.withOpacity(0.5),
    );
  }
}
