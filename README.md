# Flutter Joystick

[![Pub](https://img.shields.io/pub/v/flutter_joystick.svg)](https://pub.dev/packages/flutter_joystick)
[![License](https://img.shields.io/github/license/pavzay/flutter_unity_ads)](https://github.com/pavzay/flutter_unity_ads/blob/master/LICENSE)
[![Pub likes](https://badgen.net/pub/likes/flutter_joystick)](https://pub.dev/packages/flutter_joystick/score)
[![Pub popularity](https://badgen.net/pub/popularity/flutter_joystick)](https://pub.dev/packages/flutter_joystick/score)
[![Pub points](https://badgen.net/pub/points/flutter_joystick)](https://pub.dev/packages/flutter_joystick/score)
[![Flutter platform](https://badgen.net/pub/flutter-platform/flutter_joystick)](https://pub.dev/packages/flutter_joystick)


[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-FFDD00?logo=buymeacoffee)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)

A virtual joystick for Flutter applications.

- [Joystick](#joystick)
- [Joystick Area](#joystick-area)
- [Customization](#customization) 
- [Donate](#donate)


### Joystick

![Joystick](/example/images/joystick.gif "Joystick")

```dart
Joystick(listener: (details) {
...
})
```

`Joystick` arguments:

Parameter | Description
--- | --- 
listener | callback, which is called with `period` frequency when the stick is dragged. Listener parameter `details` contains the stick offset from the center of the base (can be from -1.0 to +1.0).
period | frequency of calling `listener` from the moment the stick is dragged, by default 100 milliseconds.
mode | possible directions mode of the joystick stick, by default `all`

Possible joystick modes:

Mode | Description
--- | --- 
all | allow move the stick in any direction: vertical, horizontal and diagonal
vertical | allow move the stick only in vertical direction
horizontal | allow move the stick only in horizontal direction
horizontalAndVertical | allow move the stick only in horizontal and vertical directions, not diagonal

![Joystick Vertical](/example/images/joystick_vertical.gif "Joystick Vertical")
![Joystick Horizontal](/example/images/joystick_horizontal.gif "Joystick Horizontal")
![Joystick Horizontal And Vertical](/example/images/joystick_horizontal_and_vertical.gif "Joystick Horizontal And Vertical")

### Joystick Area

![Joystick](/example/images/joystick_area.gif "Joystick Area")

`JoystickArea` allows to render a joystick anywhere in this area where user clicks.

```dart
JoystickArea(
  listener: (details) {
    ...
  },
  child: ...
)
```

`JoystickArea` has the same arguments as `Joystick` (listener, period, mode, etc.).

Additional `JoystickArea` arguments:

Parameter | Description
--- | ---
initialJoystickAlignment | Initial joystick alignment relative to the joystick area, by default `Alignment.bottomCenter`.
child | The `child` contained by the joystick area.

### Customization

![Square Joystick](/example/images/square_joystick.gif "Square Joystick")

`Joystick` and `JoystickArea` have additional arguments that allow to customize their appearance and behaviour.

Parameter | Description
--- | ---
base | Widget that renders joystick base, by default `JoystickBase`.
stick | Widget that renders joystick stick, it places in the center of `base` widget, by default `JoystickStick`.
stickOffsetCalculator | Calculate offset of the stick based on the stick drag start position and the current stick position. The package currently only supports circle and rectangle joystick shapes. By default `CircleStickOffsetCalculator`.

## Donate

If you found this package helpful and would like to thank me:

[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-FFDD00?logo=buymeacoffee)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)
