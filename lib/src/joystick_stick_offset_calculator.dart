import 'dart:math';
import 'dart:ui';

import 'joystick.dart';

/// Utility class for joystick calculations
class JoystickUtils {
  /// Normalizes a value to be within the range [-1, 1]
  static double normalizeOffset(double point) {
    if (point > 1) {
      return 1;
    }
    if (point < -1) {
      return -1;
    }
    return point;
  }

  /// Calculates the final offset based on the joystick mode.
  ///
  /// Different modes restrict movement in different ways:
  /// - [JoystickMode.all]: Allows full 2D movement
  /// - [JoystickMode.vertical]: Restricts movement to vertical axis only
  /// - [JoystickMode.horizontal]: Restricts movement to horizontal axis only
  /// - [JoystickMode.horizontalAndVertical]: Allows movement in both axes but only one at a time
  ///
  /// [mode] determines the movement restrictions
  /// [xOffset] and [yOffset] are the current offset values (-1 to 1)
  /// Returns an Offset with the mode-specific x and y values
  static Offset calculateOffsetForMode(
      JoystickMode mode, double xOffset, double yOffset) {
    switch (mode) {
      case JoystickMode.all:
        return Offset(xOffset, yOffset);
      case JoystickMode.vertical:
        return Offset(0.0, yOffset);
      case JoystickMode.horizontal:
        return Offset(xOffset, 0.0);
      case JoystickMode.horizontalAndVertical:
        return Offset(xOffset.abs() > yOffset.abs() ? xOffset : 0,
            yOffset.abs() > xOffset.abs() ? yOffset : 0);
    }
  }
}

/// Abstract class defining the interface for joystick offset calculators.
/// Implementations must provide a way to calculate offsets based on joystick position and mode.
abstract class StickOffsetCalculator {
  /// Calculates the joystick offset based on various parameters.
  ///
  /// [mode] determines the movement restrictions
  /// [startDragStickPosition] is the initial position when drag started
  /// [currentDragStickPosition] is the current position during drag
  /// [baseSize] defines the boundaries of the joystick area
  /// Returns an Offset representing the normalized joystick position (-1 to 1 for both axes)
  Offset calculate({
    required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  });
}

/// Calculator that constrains joystick movement to a circular area.
///
/// This implementation ensures that the joystick stays within a circular boundary
/// by normalizing the position vector to the circle's radius when needed.
class CircleStickOffsetCalculator implements StickOffsetCalculator {
  const CircleStickOffsetCalculator({
    this.snappingThreshold = 0.0,
  });

  final double snappingThreshold;

  /// Applies snapping behavior to the given x and y offsets for circular movement.
  ///
  /// Snapping helps users by automatically aligning the joystick to specific positions:
  /// - Values close to cardinal directions (0°, 90°, 180°, 270°) are snapped to those angles
  /// - Values close to diagonal directions (45°, 135°, 225°, 315°) are snapped to those angles
  /// - Values close to the border (radius ≈ 1.0) are snapped to the border
  ///
  /// [xOffset] and [yOffset] are the current offset values (-1 to 1)
  /// [snappingThreshold] determines how close to a snap angle or border a value needs to be to snap
  /// Returns an Offset with the snapped x and y values
  Offset applySnapping(double xOffset, double yOffset, double _) {
    if (snappingThreshold <= 0) {
      return Offset(xOffset, yOffset);
    }

    // Calculate current magnitude
    final magnitude = sqrt(xOffset * xOffset + yOffset * yOffset);

    // Check if we should snap to border
    if (magnitude > 0 && (1.0 - magnitude).abs() <= snappingThreshold) {
      // Snap to border while maintaining angle
      final scale = 1.0 / magnitude;
      xOffset *= scale;
      yOffset *= scale;
      return Offset(xOffset, yOffset);
    }

    // Calculate the angle in radians
    final angle = atan2(yOffset, xOffset);
    // Convert to degrees
    final degrees = (angle * 180 / pi + 360) % 360;

    // Define snap angles (in degrees)
    const snapAngles = [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0];

    // Find the closest snap angle
    double closestAngle = snapAngles[0];
    double minDifference = 360.0;

    for (final snapAngle in snapAngles) {
      final difference = (degrees - snapAngle).abs();
      final normalizedDifference =
          difference > 180 ? 360 - difference : difference;

      if (normalizedDifference < minDifference) {
        minDifference = normalizedDifference;
        closestAngle = snapAngle;
      }
    }

    // If we're close enough to a snap angle, snap to it
    if (minDifference <= snappingThreshold * 45) {
      // 45 degrees is the maximum difference between snap angles
      final snappedRadians = closestAngle * pi / 180;
      // Calculate new x and y values while maintaining the magnitude
      return Offset(
        magnitude * cos(snappedRadians),
        magnitude * sin(snappedRadians),
      );
    }

    return Offset(xOffset, yOffset);
  }

  @override
  Offset calculate({
    required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  }) {
    // Calculate the displacement from the start position
    double x = currentDragStickPosition.dx - startDragStickPosition.dx;
    double y = currentDragStickPosition.dy - startDragStickPosition.dy;
    final radius = baseSize.width / 2;

    // Check if the point is outside the circle
    final isPointInCircle = x * x + y * y < radius * radius;

    // If outside, normalize the vector to the circle's radius
    if (!isPointInCircle) {
      final mult = sqrt(radius * radius / (y * y + x * x));
      x *= mult;
      y *= mult;
    }

    // Convert to normalized coordinates (-1 to 1)
    var xOffset = x / radius;
    var yOffset = y / radius;

    // Apply snapping and mode-specific calculations
    final snappedOffset = applySnapping(xOffset, yOffset, snappingThreshold);
    return JoystickUtils.calculateOffsetForMode(
        mode, snappedOffset.dx, snappedOffset.dy);
  }
}

/// Calculator that constrains joystick movement to a rectangular area.
///
/// This implementation allows the joystick to move within a rectangular boundary,
/// with independent constraints on the x and y axes.
class RectangleStickOffsetCalculator implements StickOffsetCalculator {
  const RectangleStickOffsetCalculator({
    this.snappingThreshold = 0.0,
  });

  final double snappingThreshold;

  /// Applies snapping behavior to the given x and y offsets for rectangular movement.
  ///
  /// Snapping helps users by automatically aligning the joystick to specific positions:
  /// - Values close to edges (±1.0) are snapped to those edges
  /// - Values close to corners (±1.0, ±1.0) are snapped to those corners
  /// - Values close to zero are snapped to zero
  ///
  /// [xOffset] and [yOffset] are the current offset values (-1 to 1)
  /// [snappingThreshold] determines how close to a snap point a value needs to be to snap
  /// Returns an Offset with the snapped x and y values
  Offset applySnapping(double xOffset, double yOffset, double _) {
    if (snappingThreshold <= 0) {
      return Offset(xOffset, yOffset);
    }

    // Check if we're close to a corner
    final isNearRightEdge = (1.0 - xOffset.abs()).abs() <= snappingThreshold;
    final isNearTopEdge = (1.0 - yOffset.abs()).abs() <= snappingThreshold;
    final isNearLeftEdge = xOffset.abs() <= snappingThreshold;
    final isNearBottomEdge = yOffset.abs() <= snappingThreshold;

    // Snap to corners
    if (isNearRightEdge && isNearTopEdge) {
      return Offset(xOffset.sign, yOffset.sign);
    }

    // Snap to edges
    if (isNearRightEdge) {
      return Offset(xOffset.sign, yOffset);
    }
    if (isNearTopEdge) {
      return Offset(xOffset, yOffset.sign);
    }
    if (isNearLeftEdge) {
      return Offset(0.0, yOffset);
    }
    if (isNearBottomEdge) {
      return Offset(xOffset, 0.0);
    }

    return Offset(xOffset, yOffset);
  }

  @override
  Offset calculate({
    required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  }) {
    // Calculate the displacement from the start position
    double x = currentDragStickPosition.dx - startDragStickPosition.dx;
    double y = currentDragStickPosition.dy - startDragStickPosition.dy;

    // Normalize coordinates to [-1, 1] range
    final xOffset = JoystickUtils.normalizeOffset(x / (baseSize.width / 2));
    final yOffset = JoystickUtils.normalizeOffset(y / (baseSize.height / 2));

    // Apply snapping and mode-specific calculations
    final snappedOffset = applySnapping(xOffset, yOffset, snappingThreshold);
    return JoystickUtils.calculateOffsetForMode(
        mode, snappedOffset.dx, snappedOffset.dy);
  }
}
