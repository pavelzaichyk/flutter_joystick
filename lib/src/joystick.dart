import 'dart:async';

import 'package:flutter/material.dart';

import 'joystick_base.dart';
import 'joystick_controller.dart';
import 'joystick_stick.dart';

/// Joystick widget
class Joystick extends StatefulWidget {
  /// Callback, which is called with [period] frequency when the stick is dragged.
  final StickDragCallback listener;

  /// Frequency of calling [listener] from the moment the stick is dragged, by default 100 milliseconds.
  final Duration period;

  /// Widget that renders joystick base, by default [JoystickBase].
  final Widget? base;

  /// Widget that renders joystick stick, it places in the center of [base] widget.
  final Widget stick;

  /// Controller allows to control joystick events outside the widget.
  final JoystickController? controller;

  /// Mode possible directions of the joystick stick, by default [JoystickMode.all]
  final JoystickMode mode;

  const Joystick({
    Key? key,
    required this.listener,
    this.period = const Duration(milliseconds: 100),
    this.base,
    this.stick = const JoystickStick(),
    this.mode = JoystickMode.all,
    this.controller,
  }) : super(key: key);

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  final GlobalKey _baseKey = GlobalKey();

  Offset _stickOffset = Offset.zero;
  Timer? _callbackTimer;
  Offset _startDragStickPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    widget.controller?.onStickDragStart =
        (globalPosition) => _stickDragStart(globalPosition);
    widget.controller?.onStickDragUpdate =
        (globalPosition) => _stickDragUpdate(globalPosition);
    widget.controller?.onStickDragEnd = () => _stickDragEnd();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(_stickOffset.dx, _stickOffset.dy),
      children: [
        Container(
          key: _baseKey,
          child: widget.base ?? JoystickBase(mode: widget.mode),
        ),
        GestureDetector(
          onPanStart: (details) => _stickDragStart(details.globalPosition),
          onPanUpdate: (details) => _stickDragUpdate(details.globalPosition),
          onPanEnd: (details) => _stickDragEnd(),
          child: widget.stick,
        ),
      ],
    );
  }

  void _stickDragStart(Offset globalPosition) {
    _runCallback();
    _startDragStickPosition = globalPosition;
  }

  void _stickDragUpdate(Offset globalPosition) {
    final baseRenderBox =
        _baseKey.currentContext!.findRenderObject()! as RenderBox;

    final stickOffset =
        _calculateStickOffset(globalPosition, baseRenderBox.size);

    setState(() {
      _stickOffset = stickOffset;
    });
  }

  Offset _calculateStickOffset(Offset globalPosition, Size size) {
    final xOffset = widget.mode == JoystickMode.vertical
        ? 0.0
        : _normalizeOffset((globalPosition.dx - _startDragStickPosition.dx) /
            (size.width / 2));
    final yOffset = widget.mode == JoystickMode.horizontal
        ? 0.0
        : _normalizeOffset((globalPosition.dy - _startDragStickPosition.dy) /
            (size.height / 2));

    if (widget.mode != JoystickMode.onlyTwoDirections) {
      return Offset(xOffset, yOffset);
    }

    //only vertical and horizontal
    return Offset(xOffset.abs() > yOffset.abs() ? xOffset : 0,
        yOffset.abs() > xOffset.abs() ? yOffset : 0);
  }

  double _normalizeOffset(double point) {
    if (point > 1) {
      return 1;
    }
    if (point < -1) {
      return -1;
    }
    return point;
  }

  void _stickDragEnd() {
    setState(() {
      _stickOffset = Offset.zero;
    });

    _callbackTimer?.cancel();
    _startDragStickPosition = Offset.zero;
  }

  void _runCallback() {
    _callbackTimer = Timer.periodic(widget.period, (timer) {
      widget.listener(StickDragDetails(_stickOffset.dx, _stickOffset.dy));
    });
  }

  @override
  void dispose() {
    _callbackTimer?.cancel();
    super.dispose();
  }
}

typedef StickDragCallback = void Function(StickDragDetails details);

/// Contains the stick offset from the center of the base.
class StickDragDetails {
  /// x - the stick offset in the horizontal direction. Can be from -1.0 to +1.0.
  final double x;

  /// y - the stick offset in the vertical direction. Can be from -1.0 to +1.0.
  final double y;

  StickDragDetails(this.x, this.y);
}

/// Possible directions of the joystick stick.
enum JoystickMode {
  /// allow move the stick in any directions: vertical, horizontal and diagonal.
  all,

  /// allow move the stick only in vertical direction.
  vertical,

  /// allow move the stick only in horizontal direction.
  horizontal,

  /// allow move the stick only in horizontal and vertical directions, not diagonal.
  onlyTwoDirections,
}
