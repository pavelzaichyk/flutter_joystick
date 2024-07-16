## 0.2.1
- Update an example app
- Update README.md

## 0.2.0
- Introduced the `JoystickBaseDecoration` class, enabling customization of `JoystickBase`.
- Introduced the `JoystickStickDecoration` class, enabling customization of `JoystickStick`.
- Introduced the `JoystickArrowsDecoration` class, enabling customization of `JoystickArrows`.
- Expanded README.md with additional details on customizing the Joystick.

## 0.1.0

- Added animation logic to the `Joystick` to animate the `JoystickStick` on load which can be toggled using `includeInitialAnimation` parameter.
- Added: Support for customizing `arrowsColor`, `boxShadows` and `withBorderCircle` parameter in `JoystickBase`.
- Added: Support for customizing `color` and `shadowColor` parameters in `JoystickStick`.
- Added new `JoystickArrows` widget and removed the current arrow rendering logic from `JoystickBase` widget. The arrows in `JoystickArrows` animate and the animation can be toggled using `enableArrowAnimation` in `JoystickBase` widget.
- Added new `ColorUtils` class which exposes static `darken` and `lighten` methods.

## 0.0.4

- Added: Support for customizing `drawArrows`, `size`, and `color` parameters in `JoystickBase`.
- Added: Support for customizing `size` parameter in `JoystickStick`.

## 0.0.3

- Added a send of zero offset to the joystick listener when the stick is released

## 0.0.2

- Added callbacks that are called when the stick starts and ends movement

## 0.0.1

- Added Joystick widget. Added JoystickArea widget.
