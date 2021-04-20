import 'package:flutter/material.dart';

import './joystick.dart';
import './joystick_controller.dart';

class JoystickArea extends StatefulWidget {
  final Widget? child;
  final StickDragCallback onStickUpdate;
  final Alignment initialJoystickAlignment;

  const JoystickArea({
    Key? key,
    required this.onStickUpdate,
    this.child,
    this.initialJoystickAlignment = Alignment.bottomCenter,
  }) : super(key: key);

  @override
  _JoystickAreaState createState() => _JoystickAreaState();
}

class _JoystickAreaState extends State<JoystickArea> {
  final _areaKey = GlobalKey();
  final _joystickKey = GlobalKey();
  final _controller = JoystickController();
  late Alignment _joystickAlignment;

  @override
  void didChangeDependencies() {
    _joystickAlignment = widget.initialJoystickAlignment;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _areaKey,
      onPanStart: (details) {
        final localPosition = details.localPosition;
        final joystickSize = _joystickKey.currentContext!.size!;

        final areaBox =
            _areaKey.currentContext!.findRenderObject()! as RenderBox;

        final halfWidth = areaBox.size.width / 2;
        final halfHeight = areaBox.size.height / 2;

        final xAlignment = (localPosition.dx - halfWidth) /
            (halfWidth - joystickSize.width / 2);
        final yAlignment = (localPosition.dy - halfHeight) /
            (halfHeight - joystickSize.height / 2);

        setState(() {
          _joystickAlignment = Alignment(xAlignment, yAlignment);
        });
        _controller.start(details.globalPosition);
      },
      onPanUpdate: (details) => _controller.update(details.globalPosition),
      onPanEnd: (details) {
        setState(() {
          _joystickAlignment = widget.initialJoystickAlignment;
        });

        _controller.end();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Stack(
          children: [
            if (widget.child != null) Align(child: widget.child),
            Align(
              alignment: _joystickAlignment,
              child: Joystick(
                key: _joystickKey,
                controller: _controller,
                onStickUpdate: widget.onStickUpdate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
