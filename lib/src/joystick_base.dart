import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class JoystickBase extends StatelessWidget {
  final JoystickMode mode;
  final double size;
  final JoystickBaseDecoration? decoration;
  final Widget? joystickArrows;
  final JoystickArrowsDecoration? arrowsDecoration;

  const JoystickBase({
    this.mode = JoystickMode.all,
    this.size = 200,
    this.decoration,
    this.joystickArrows,
    this.arrowsDecoration,
    super.key,
  }) : assert(joystickArrows == null || arrowsDecoration == null);

  @override
  Widget build(BuildContext context) {
    final baseDecoration = decoration ?? JoystickBaseDecoration();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: baseDecoration.boxShadows),
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _JoystickBasePainter(
                decoration: baseDecoration,
              ),
            ),
          ),
          if (baseDecoration.drawArrows)
            joystickArrows ??
                JoystickArrows(
                  mode: mode,
                  size: size,
                  decoration: arrowsDecoration,
                ),
        ],
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  final JoystickBaseDecoration decoration;

  _JoystickBasePainter({
    required this.decoration,
  });

  static const double borderStrokeWidthPercentage = 0.05;
  static const double innerCircleRadiusReductionPercentage = 0.06;
  static const double outermostCircleRadiusReductionPercentage = 0.3;

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = size.width;
    final radius = diameter / 2;
    final center = Offset(radius, radius);

    drawCircles(canvas, center, diameter);
  }

  void drawCircles(Canvas canvas, Offset center, double diameter) {
    drawOuterCircle(canvas, center, diameter);
    drawMiddleCircle(canvas, center, diameter);
    drawInnerCircle(canvas, center, diameter);
  }

  void drawInnerCircle(Canvas canvas, Offset center, double diameter) {
    if (decoration.drawInnerCircle) {
      final innerPaint = Paint()
        ..color = decoration.innerCircleColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          center,
          diameter / 2 - outermostCircleRadiusReductionPercentage * diameter,
          innerPaint);
    }
  }

  void drawMiddleCircle(Canvas canvas, Offset center, double diameter) {
    if (decoration.drawMiddleCircle) {
      final paint = Paint()
        ..color = decoration.middleCircleColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          center,
          diameter / 2 - innerCircleRadiusReductionPercentage * diameter,
          paint);
    }
  }

  void drawOuterCircle(Canvas canvas, Offset center, double diameter) {
    if (decoration.drawOuterCircle) {
      final outerCirclePaint = Paint()
        ..color = decoration.outerCircleColor
        ..strokeWidth = borderStrokeWidthPercentage * diameter
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, diameter / 2, outerCirclePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class JoystickSquareBase extends StatelessWidget {
  final test = JoystickBaseDecoration();
  final JoystickMode mode;
  final double size;
  final JoystickBaseDecoration? decoration;

  JoystickSquareBase({
    this.mode = JoystickMode.all,
    this.size = 200,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = this.decoration ?? JoystickBaseDecoration();
    final padding = 10 / 200 * size;
    return Container(
      width: size,
      height: size,
      decoration: decoration.drawOuterCircle
          ? BoxDecoration(
              border: Border.all(color: decoration.outerCircleColor, width: 10))
          : null,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Container(
          width: size - padding * 2,
          height: size - padding * 2,
          color: decoration.middleCircleColor,
          child: decoration.drawArrows
              ? CustomPaint(
                  painter: _JoystickSquareBaseArrowPainter(
                      mode: mode, decoration: decoration),
                )
              : null,
        ),
      ),
    );
  }
}

class _JoystickSquareBaseArrowPainter extends CustomPainter {
  final JoystickMode mode;
  final JoystickBaseDecoration decoration;

  _JoystickSquareBaseArrowPainter({
    required this.mode,
    required this.decoration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lineWidth = 20.0 / 180 * size.width;
    final lineHeight = 40.0 / 180 * size.height;
    final linePosition = 30.0 / 180 * size.width;
    final double arrowSpacing = 15.0 / 180 * size.width;
    final linePaint = Paint()
      ..color = decoration.innerCircleColor
      ..strokeWidth = 5 / 180 * size.width
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    if (mode != JoystickMode.horizontal) {
      // draw vertical arrows
      canvas.drawLine(Offset(center.dx - lineWidth, center.dy - linePosition),
          Offset(center.dx, center.dy - linePosition - lineHeight), linePaint);
      canvas.drawLine(Offset(center.dx + lineWidth, center.dy - linePosition),
          Offset(center.dx, center.dy - linePosition - lineHeight), linePaint);

      canvas.drawLine(Offset(center.dx - lineWidth, center.dy + linePosition),
          Offset(center.dx, center.dy + linePosition + lineHeight), linePaint);
      canvas.drawLine(Offset(center.dx + lineWidth, center.dy + linePosition),
          Offset(center.dx, center.dy + linePosition + lineHeight), linePaint);
    }

    if (mode != JoystickMode.vertical) {
      // draw horizontal arrows
      canvas.drawLine(Offset(center.dx - linePosition, center.dy - lineWidth),
          Offset(center.dx - linePosition - lineHeight, center.dy), linePaint);
      canvas.drawLine(Offset(center.dx - linePosition, center.dy + lineWidth),
          Offset(center.dx - linePosition - lineHeight, center.dy), linePaint);
      canvas.drawLine(Offset(center.dx + linePosition, center.dy - lineWidth),
          Offset(center.dx + linePosition + lineHeight, center.dy), linePaint);
      canvas.drawLine(Offset(center.dx + linePosition, center.dy + lineWidth),
          Offset(center.dx + linePosition + lineHeight, center.dy), linePaint);
    }

    if (mode == JoystickMode.all) {
      // draw diagonal arrows
      canvas.drawLine(
          Offset(center.dx + lineWidth, center.dy - linePosition),
          Offset(center.dx + lineWidth + arrowSpacing,
              center.dy - linePosition - 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + linePosition, center.dy - lineWidth),
          Offset(center.dx + lineWidth + arrowSpacing,
              center.dy - linePosition - 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + lineWidth, center.dy + linePosition),
          Offset(center.dx + lineWidth + arrowSpacing,
              center.dy + linePosition + 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + linePosition, center.dy + lineWidth),
          Offset(center.dx + lineWidth + arrowSpacing,
              center.dy + linePosition + 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - lineWidth, center.dy - linePosition),
          Offset(center.dx - lineWidth - arrowSpacing,
              center.dy - linePosition - 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - linePosition, center.dy - lineWidth),
          Offset(center.dx - lineWidth - arrowSpacing,
              center.dy - linePosition - 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - lineWidth, center.dy + linePosition),
          Offset(center.dx - lineWidth - arrowSpacing,
              center.dy + linePosition + 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - linePosition, center.dy + lineWidth),
          Offset(center.dx - lineWidth - arrowSpacing,
              center.dy + linePosition + 5),
          linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

@immutable
class JoystickBaseDecoration {
  final bool drawArrows;

  final bool drawOuterCircle;
  final Color outerCircleColor;
  final bool drawMiddleCircle;
  final Color middleCircleColor;
  final bool drawInnerCircle;
  final Color innerCircleColor;

  final List<BoxShadow>? boxShadows;

  const JoystickBaseDecoration._internal({
    required this.drawArrows,
    required this.drawOuterCircle,
    required this.outerCircleColor,
    required this.drawMiddleCircle,
    required this.middleCircleColor,
    required this.drawInnerCircle,
    required this.innerCircleColor,
    required this.boxShadows,
  });

  factory JoystickBaseDecoration({
    Color? color,
    bool drawArrows = true,
    bool drawOuterCircle = true,
    Color? outerCircleColor,
    bool drawMiddleCircle = true,
    Color? middleCircleColor,
    bool drawInnerCircle = true,
    Color? innerCircleColor,
    List<BoxShadow>? boxShadows,
    Color? boxShadowColor,
  }) {
    assert(boxShadows == null || boxShadowColor == null);
    assert(color == null ||
        outerCircleColor == null ||
        middleCircleColor == null ||
        innerCircleColor == null);
    Color baseColor = color ?? ColorUtils.defaultBaseColor;
    return JoystickBaseDecoration._internal(
      drawArrows: drawArrows,
      drawOuterCircle: drawOuterCircle,
      outerCircleColor: outerCircleColor ?? baseColor,
      drawMiddleCircle: drawMiddleCircle,
      middleCircleColor:
          middleCircleColor ?? ColorUtils.lighten(baseColor, 0.05),
      drawInnerCircle: drawInnerCircle,
      innerCircleColor: innerCircleColor ?? baseColor,
      boxShadows: boxShadows ??
          [
            BoxShadow(
              color: boxShadowColor ?? baseColor.withOpacity(0.16),
              spreadRadius: 10,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
    );
  }
}
