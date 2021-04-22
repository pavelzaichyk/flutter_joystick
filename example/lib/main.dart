import 'package:flutter/material.dart';
import 'package:joystick/joystick.dart';

void main() {
  runApp(JoystickExampleApp());
}

class JoystickExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Joystick Example'),
        ),
        body: Field(),
      ),
    );
  }
}

class Field extends StatefulWidget {
  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  final _ballSize = 20.0;
  final _step = 10;
  late double _fieldHeight;
  late double _fieldWidth;
  late double _x;
  late double _y;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fieldWidth = MediaQuery.of(context).size.width;
    _fieldHeight = MediaQuery.of(context).size.height;
    setState(() {
      _x = _fieldWidth / 2 - _ballSize / 2;
      _y = _fieldHeight / 2 - _ballSize / 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return JoystickArea(
      initialJoystickAlignment: Alignment(0, 0.9),
      onStickUpdate: _updateJoystick,
      child: Stack(
        children: [
          Container(
            color: Colors.green,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            left: _x,
            top: _y,
            child: Container(
              width: _ballSize,
              height: _ballSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateJoystick(StickDragDetails details) {
    var newX = _x + _step * details.offset.dx;
    var newY = _y + _step * details.offset.dy;
    newX = newX < 0
        ? 0
        : (newX > _fieldWidth - _ballSize ? _fieldWidth - _ballSize : newX);
    newY = newY < 0
        ? 0
        : (newY > _fieldHeight - _ballSize ? _fieldHeight - _ballSize : newY);
    setState(() {
      _x = newX;
      _y = newY;
    });
  }
}
