import 'package:flutter/material.dart';

import 'joystick.dart';

class JoystickBase extends StatelessWidget {
  final Color? arrowsColor;
  final Color color;
  final bool drawArrows;
  final JoystickMode mode;
  final double size;
  final bool withBorderCircle;

  const JoystickBase({
    this.arrowsColor,
    this.color = const Color(0x50616161),
    this.drawArrows = true,
    this.mode = JoystickMode.all,
    this.size = 200,
    this.withBorderCircle = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.16),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: CustomPaint(
        painter: _JoystickBasePainter(
          arrowsColor: arrowsColor ?? color,
          color: color,
          drawArrows: drawArrows,
          mode: mode,
          withBorderCircle: withBorderCircle,
        ),
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  final Color arrowsColor;
  final Color color;
  final bool drawArrows;
  final JoystickMode mode;
  final bool withBorderCircle;

  _JoystickBasePainter({
    required this.arrowsColor,
    required this.color,
    required this.drawArrows,
    required this.mode,
    required this.withBorderCircle,
  });

  static const double borderStrokeWidthPercentage = 0.05;
  static const double arrowStrokeWidthPercentage = 0.025;
  static const double innerCircleRadiusReductionPercentage = 0.06;
  static const double outermostCircleRadiusReductionPercentage = 0.3;
  static const double arrowWidth = 0.15;
  static const double arrowHeight = 0.1;
  static const double arrowHeadOffset = 0.35;

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = size.width;
    final radius = diameter / 2;
    final center = Offset(radius, radius);

    drawCircles(canvas, center, diameter, withBorderCircle);
    drawVerticalAndHorizontalArrows(canvas, center, diameter);
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

  void drawVerticalAndHorizontalArrows(
      Canvas canvas, Offset center, double diameter) {
    final linePaint = Paint()
      ..color = arrowsColor
      ..strokeWidth = arrowStrokeWidthPercentage * diameter
      ..style = PaintingStyle.stroke;
    drawVerticalArrows(canvas, center, diameter, linePaint);
    drawHorizontalArrows(canvas, center, diameter, linePaint);
  }

  void drawVerticalArrows(
      Canvas canvas, Offset center, double diameter, Paint linePaint) {
    if (drawArrows && mode != JoystickMode.horizontal) {
      final height = arrowHeight * diameter;
      final headOffset = arrowHeadOffset * diameter;
      final width = arrowWidth * diameter;

      final topArrowHeadOffset = center.dy - headOffset;
      var topArrowHead = Offset(center.dx, topArrowHeadOffset);
      canvas.drawLine(
          topArrowHead, topArrowHead.translate(-width, height), linePaint);
      canvas.drawLine(
          topArrowHead, topArrowHead.translate(width, height), linePaint);

      final bottomArrowHeadOffset = center.dy + headOffset;
      var bottomArrowHead = Offset(center.dx, bottomArrowHeadOffset);
      canvas.drawLine(bottomArrowHead,
          bottomArrowHead.translate(-width, -height), linePaint);
      canvas.drawLine(bottomArrowHead,
          bottomArrowHead.translate(width, -height), linePaint);
    }
  }

  void drawHorizontalArrows(
      Canvas canvas, Offset center, double diameter, Paint linePaint) {
    if (drawArrows && mode != JoystickMode.vertical) {
      final height = arrowHeight * diameter;
      final headOffset = arrowHeadOffset * diameter;
      final width = arrowWidth * diameter;

      final leftArrowHeadOffset = center.dx - headOffset;
      final leftArrowHead = Offset(leftArrowHeadOffset, center.dy);
      canvas.drawLine(
          leftArrowHead, leftArrowHead.translate(height, -width), linePaint);
      canvas.drawLine(
          leftArrowHead, leftArrowHead.translate(height, width), linePaint);

      final rightArrowHeadOffset = center.dx + headOffset;
      var rightArrowHead = Offset(rightArrowHeadOffset, center.dy);
      canvas.drawLine(
          rightArrowHead, rightArrowHead.translate(-height, -width), linePaint);
      canvas.drawLine(
          rightArrowHead, rightArrowHead.translate(-height, width), linePaint);
    }
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
    Key? key,
  }) : super(key: key);

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
