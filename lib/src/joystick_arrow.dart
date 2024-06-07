import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class JoystickArrows extends StatefulWidget {
  final JoystickMode mode;
  final double size;
  final JoystickArrowsDecoration? decoration;

  const JoystickArrows({
    super.key,
    required this.mode,
    required this.size,
    this.decoration,
  });

  @override
  State<JoystickArrows> createState() => _JoystickArrowsState();
}

class _JoystickArrowsState extends State<JoystickArrows>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final Tween<double> _rotationTween = Tween(begin: 0, end: 2);

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: _ArrowPainter(
          value: (controller.value * 100).toInt(),
          mode: widget.mode,
          decoration: widget.decoration ?? JoystickArrowsDecoration(),
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final int value;
  final JoystickMode mode;
  final JoystickArrowsDecoration decoration;

  _ArrowPainter({
    required this.value,
    required this.mode,
    required this.decoration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    drawVerticalArrows(canvas, paint, size);
    drawHorizontalArrows(canvas, paint, size);
  }

  void drawVerticalArrows(
    Canvas canvas,
    Paint paint,
    Size size,
  ) {
    if (mode != JoystickMode.horizontal) {
      double xPosition = size.width / 2;
      double top = -36;
      double bottom = size.height - 36;
      double rotationAngle = math.pi;
      double moveX = size.width;

      canvas.translate(moveX, 0);
      canvas.rotate(rotationAngle);
      _drawArrow(
        canvas,
        paint,
        xPosition,
        top,
      );
      canvas.translate(moveX, 0);
      canvas.rotate(-rotationAngle);
      _drawArrow(
        canvas,
        paint,
        xPosition,
        bottom,
      );
      canvas.translate(0, 0);
    }
  }

  void drawHorizontalArrows(
    Canvas canvas,
    Paint paint,
    Size size,
  ) {
    if (mode != JoystickMode.vertical) {
      double yPosition = size.height / 2 - 36;
      double left = 0;
      double right = size.width;
      double rotationAngle = math.pi / 2;
      double moveXLeft = size.width / 2;
      double moveXRight = size.width;
      double moveY = size.height / 2;

      canvas.translate(
        moveXLeft,
        moveY,
      );
      canvas.rotate(rotationAngle);
      _drawArrow(
        canvas,
        paint,
        left,
        yPosition,
      );
      canvas.translate(
        moveXRight,
        0,
      );
      canvas.rotate(math.pi);
      _drawArrow(
        canvas,
        paint..color,
        right,
        yPosition,
      );
    }
  }

  void _drawArrow(
    Canvas canvas,
    Paint paint,
    double xPosition,
    double yPosition,
  ) {
    var path = Path();
    path.moveTo(xPosition - 5, yPosition - 12);
    path.lineTo(xPosition, yPosition - 8);
    path.lineTo(xPosition + 5, yPosition - 12);
    canvas.drawPath(
      path,
      paint..color = evaluateColor(value < 33),
    );

    path = Path();
    path.moveTo(xPosition - 7, yPosition - 5);
    path.lineTo(xPosition, yPosition);
    path.lineTo(xPosition + 7, yPosition - 5);
    canvas.drawPath(
      path,
      paint..color = evaluateColor(value > 33 && value < 66),
    );

    path = Path();
    path.moveTo(xPosition - 10, yPosition + 2);
    path.lineTo(xPosition, yPosition + 9);
    path.lineTo(xPosition + 10, yPosition + 2);
    canvas.drawPath(path, paint..color = evaluateColor(value > 66));
  }

  evaluateColor(bool condition) {
    Color resultColor = decoration.color;
    if (!condition && decoration.enableAnimation) {
      resultColor = ColorUtils.darken(decoration.color, 0.14);
    }
    return resultColor;
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) => oldDelegate.value != value;
}

@immutable
class JoystickArrowsDecoration {
  final Color color;
  final bool enableAnimation;

  const JoystickArrowsDecoration._internal({
    required this.color,
    required this.enableAnimation,
  });

  factory JoystickArrowsDecoration({
    Color? color,
    bool enableAnimation = true,
  }) {
    return JoystickArrowsDecoration._internal(
      color: color ?? ColorUtils.defaultArrowsColor,
      enableAnimation: enableAnimation,
    );
  }
}
