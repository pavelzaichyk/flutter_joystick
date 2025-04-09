import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:joystick_example/main.dart';

class JoystickInScrollView extends StatefulWidget {
  const JoystickInScrollView({super.key});

  @override
  State<JoystickInScrollView> createState() => _JoystickInScrollViewState();
}

class _JoystickInScrollViewState extends State<JoystickInScrollView> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Joystick'),
        actions: [
          JoystickModeDropdown(
            mode: _joystickMode,
            onChanged: (JoystickMode value) {
              setState(() {
                _joystickMode = value;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Ball(_x, _y),
            Align(
              child: Scrollbar(
                thickness: 16.0,
                radius: const Radius.circular(10),
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 400),
                      Center(
                        child: Joystick(
                          mode: _joystickMode,
                          listener: (details) {
                            setState(() {
                              _x = _x + step * details.x;
                              _y = _y + step * details.y;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 800),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
