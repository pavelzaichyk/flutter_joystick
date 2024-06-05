import 'package:flutter/material.dart';
import 'package:flutter_joystick/src/joystick_arrow.dart';
import 'joystick.dart';

class JoystickBase extends StatelessWidget {
  final Color? arrowsColor;
  final List<BoxShadow>? boxShadows;
  final Color color;
  final bool drawArrows;
  final JoystickMode mode;
  final double size;
  final bool withBorderCircle;
  final bool enableArrowAnimation;

  const JoystickBase({
    this.arrowsColor,
    this.boxShadows,
    this.color = const Color(0x50616161),
    this.drawArrows = true,
    this.mode = JoystickMode.all,
    this.size = 200,
    this.withBorderCircle = true,
    this.enableArrowAnimation = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color boxShadowColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? color.withOpacity(0.08)
            : color.withOpacity(0.16);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: boxShadows ??
            [
              BoxShadow(
                color: boxShadowColor,
                spreadRadius: 1,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _JoystickBasePainter(
                color: color,
                mode: mode,
                withBorderCircle: withBorderCircle,
              ),
            ),
          ),
          if (drawArrows)
            JoystickArrows(
              arrowsColor: arrowsColor ?? color,
              mode: mode,
              size: size,
              enableAnimation: enableArrowAnimation,
            ),
        ],
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  final Color color;
  final JoystickMode mode;
  final bool withBorderCircle;

  _JoystickBasePainter({
    required this.color,
    required this.mode,
    required this.withBorderCircle,
  });

  static const double borderStrokeWidthPercentage = 0.05;
  static const double innerCircleRadiusReductionPercentage = 0.06;
  static const double outermostCircleRadiusReductionPercentage = 0.3;

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = size.width;
    final radius = diameter / 2;
    final center = Offset(radius, radius);

    drawCircles(canvas, center, diameter, withBorderCircle);
  }

  void drawCircles(
      Canvas canvas, Offset center, double diameter, bool withBorderCircle) {
    if (withBorderCircle) {
      final borderPaint = Paint()
        ..color = color
        ..strokeWidth = borderStrokeWidthPercentage * diameter
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, diameter / 2, borderPaint);
    }

    final outerPaint = Paint()
      ..color = color.withOpacity(0.84)
      ..style = PaintingStyle.fill;

    final innerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      diameter / 2 - innerCircleRadiusReductionPercentage * diameter,
      outerPaint,
    );
    canvas.drawCircle(
      center,
      diameter / 2 - outermostCircleRadiusReductionPercentage * diameter,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class JoystickSquareBase extends StatelessWidget {
  final JoystickMode mode;
  final double size;
  final bool drawArrows;
  final Color color;

  const JoystickSquareBase({
    this.mode = JoystickMode.all,
    this.size = 200,
    this.drawArrows = true,
    this.color = const Color(0x50616161),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final padding = 10 / 200 * size;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(border: Border.all(color: color, width: 10)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Container(
          width: size - padding * 2,
          height: size - padding * 2,
          color: color,
          child: drawArrows
              ? CustomPaint(
                  painter:
                      _JoystickSquareBaseArrowPainter(mode: mode, color: color),
                )
              : null,
        ),
      ),
    );
  }
}

class _JoystickSquareBaseArrowPainter extends CustomPainter {
  final JoystickMode mode;
  final Color color;

  _JoystickSquareBaseArrowPainter({
    required this.mode,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lineWidth = 20.0 / 180 * size.width;
    final lineHeight = 40.0 / 180 * size.height;
    final linePosition = 30.0 / 180 * size.width;
    final double arrowSpacing = 15.0 / 180 * size.width;
    final linePaint = Paint()
      ..color = color
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
