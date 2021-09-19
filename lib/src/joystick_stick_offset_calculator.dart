import 'dart:math';
import 'dart:ui';

import '../joystick.dart';

abstract class StickOffsetCalculator {
  Offset calculate({
    required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  });
}

class CircleStickOffsetCalculator implements StickOffsetCalculator {
  const CircleStickOffsetCalculator();

  @override
  Offset calculate({
    required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  }) {
    double x = currentDragStickPosition.dx - startDragStickPosition.dx;
    double y = currentDragStickPosition.dy - startDragStickPosition.dy;
    final radius = baseSize.width / 2;

    final isPointInCircle = x * x + y * y < radius * radius;

    if (!isPointInCircle) {
      final mult = sqrt(radius * radius / (y * y + x * x));
      x *= mult;
      y *= mult;
    }

    final xOffset = mode == JoystickMode.vertical ? 0.0 : x / radius;
    final yOffset = mode == JoystickMode.horizontal ? 0.0 : y / radius;

    if (mode != JoystickMode.onlyTwoDirections) {
      return Offset(xOffset, yOffset);
    }

    //only vertical and horizontal
    return Offset(xOffset.abs() > yOffset.abs() ? xOffset : 0,
        yOffset.abs() > xOffset.abs() ? yOffset : 0);
  }
}
