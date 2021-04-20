import 'dart:async';

import 'package:flutter/material.dart';

import './joystick_controller.dart';

class Joystick extends StatefulWidget {
  /// Calling with [period] frequency when the stick is dragged.
  final StickDragCallback onStickUpdate;

  /// Frequency of calling [onStickUpdate] from the moment the stick is dragged.
  final Duration period;

  /// Widget that renders joystick base.
  final Widget base;

  /// Widget that renders joystick stick, it places in the center of [base] widget.
  final Widget stick;

  final JoystickController? controller;

  const Joystick({
    Key? key,
    required this.onStickUpdate,
    this.period = const Duration(milliseconds: 100),
    this.base = const Base(),
    this.stick = const Stick(),
    this.controller,
  }) : super(key: key);

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  final GlobalKey _baseKey = GlobalKey();

  Offset _stickOffset = Offset.zero;
  Timer? _callbackTimer;
  Offset _start = Offset.zero;

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
          child: widget.base,
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
    _start = globalPosition;
  }

  void _stickDragUpdate(Offset globalPosition) {
    final baseRenderBox =
        _baseKey.currentContext!.findRenderObject()! as RenderBox;

    final x = _normalizeOffset(
        (globalPosition.dx - _start.dx) / (baseRenderBox.size.width / 2));
    final y = _normalizeOffset(
        (globalPosition.dy - _start.dy) / (baseRenderBox.size.height / 2));

    setState(() {
      _stickOffset = Offset(x, y);
    });
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
    _start = Offset.zero;
  }

  void _runCallback() {
    _callbackTimer = Timer.periodic(widget.period, (timer) {
      widget.onStickUpdate(StickDragDetails(_stickOffset));
    });
  }

  @override
  void dispose() {
    _callbackTimer?.cancel();
    super.dispose();
  }
}

class Base extends StatelessWidget {
  const Base({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.greenAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}

class Stick extends StatelessWidget {
  const Stick({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}

typedef StickDragCallback = void Function(StickDragDetails details);

class StickDragDetails {
  /// dx or dy can be from -1.0 to +1.0.
  /// dx - the stick offset in the horizontal direction.
  /// dy - the stick offset in the vertical direction.
  final Offset offset;

  StickDragDetails(this.offset);
}
