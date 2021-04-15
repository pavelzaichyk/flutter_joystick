import 'dart:async';

import 'package:flutter/material.dart';

class Joystick extends StatefulWidget {
  /// Calling with [period] frequency when the stick is dragged.
  final StickDragCallback onStickUpdate;

  /// Frequency of calling [onStickUpdate] from the moment the stick is dragged.
  final Duration period;

  /// Widget that renders joystick base.
  final Widget base;

  /// Widget that renders joystick stick, it places in the center of [base] widget.
  final Widget stick;

  Joystick({
    required this.onStickUpdate,
    this.period = const Duration(milliseconds: 100),
    this.base = const Base(),
    this.stick = const Stick(),
  });

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  GlobalKey _baseKey = GlobalKey();
  GlobalKey _stickKey = GlobalKey();

  Offset _stickOffset = Offset.zero;
  Timer? _callbackTimer;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment(_stickOffset.dx, _stickOffset.dy),
        children: [
          Container(
            key: _baseKey,
            child: widget.base,
          ),
          GestureDetector(
            onPanStart: (details) {
              _onStickUpdate(details.localPosition);
              _runCallback();
            },
            onPanUpdate: (details) => _onStickUpdate(details.localPosition),
            onPanEnd: (details) {
              setState(() {
                _stickOffset = Offset.zero;
              });

              _callbackTimer?.cancel();
            },
            child: Container(
              key: _stickKey,
              child: widget.stick,
            ),
          ),
        ],
      ),
    );
  }

  void _onStickUpdate(Offset offset) {
    final baseRenderBox =
        _baseKey.currentContext!.findRenderObject() as RenderBox;
    final stickRenderBox =
        _stickKey.currentContext!.findRenderObject() as RenderBox;

    var x = (offset.dx - stickRenderBox.size.width / 2) /
        (baseRenderBox.size.width / 2);
    if (x > 1) {
      x = 1;
    } else if (x < -1) {
      x = -1;
    }
    var y = (offset.dy - stickRenderBox.size.height / 2) /
        (baseRenderBox.size.height / 2);
    if (y > 1) {
      y = 1;
    } else if (y < -1) {
      y = -1;
    }

    setState(() {
      _stickOffset = Offset(x, y);
    });
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
  const Base();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}

class Stick extends StatelessWidget {
  const Stick();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
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
