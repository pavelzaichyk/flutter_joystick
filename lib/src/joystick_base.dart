import 'package:flutter/material.dart';

class JoystickBase extends StatelessWidget {
  const JoystickBase({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: JoystickBasePainter(),
      ),
    );
  }
}

class JoystickBasePainter extends CustomPainter {
  final _borderPaint = Paint()
    ..color = const Color(0x50616161)
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
  final _centerPaint = Paint()
    ..color = const Color(0x50616161)
    ..style = PaintingStyle.fill;
  final _linePaint = Paint()
    ..color = const Color(0x50616161)
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, _borderPaint);
    canvas.drawCircle(center, radius - 12, _centerPaint);
    canvas.drawCircle(center, radius - 60, _centerPaint);

    canvas.drawLine(Offset(center.dx - 30, center.dy - 50),
        Offset(center.dx, center.dy - 70), _linePaint);
    canvas.drawLine(Offset(center.dx + 30, center.dy - 50),
        Offset(center.dx, center.dy - 70), _linePaint);
    canvas.drawLine(Offset(center.dx - 30, center.dy + 50),
        Offset(center.dx, center.dy + 70), _linePaint);
    canvas.drawLine(Offset(center.dx + 30, center.dy + 50),
        Offset(center.dx, center.dy + 70), _linePaint);

    canvas.drawLine(Offset(center.dx - 50, center.dy - 30),
        Offset(center.dx - 70, center.dy), _linePaint);
    canvas.drawLine(Offset(center.dx - 50, center.dy + 30),
        Offset(center.dx - 70, center.dy), _linePaint);
    canvas.drawLine(Offset(center.dx + 50, center.dy - 30),
        Offset(center.dx + 70, center.dy), _linePaint);
    canvas.drawLine(Offset(center.dx + 50, center.dy + 30),
        Offset(center.dx + 70, center.dy), _linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
