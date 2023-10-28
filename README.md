# Flutter Joystick

[![Pub Version](https://img.shields.io/pub/v/flutter_joystick.svg)](https://pub.dev/packages/flutter_joystick)
[![License](https://img.shields.io/github/license/pavelzaichyk/flutter_joystick)](https://github.com/pavelzaichyk/flutter_joystick/blob/master/LICENSE)
[![Pub Likes](https://badgen.net/pub/likes/flutter_joystick)](https://pub.dev/packages/flutter_joystick/score)
[![Pub Popularity](https://badgen.net/pub/popularity/flutter_joystick)](https://pub.dev/packages/flutter_joystick/score)
[![Pub Points](https://badgen.net/pub/points/flutter_joystick)](https://pub.dev/packages/flutter_joystick/score)
[![Flutter Platform](https://badgen.net/pub/flutter-platform/flutter_joystick)](https://pub.dev/packages/flutter_joystick)

[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-FFDD00?logo=buymeacoffee)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)

Flutter Joystick is a virtual joystick package for Flutter applications that provides interactive
joystick components for user interface design.

## Table of Contents

1. [Joystick](#joystick)
2. [Joystick Area](#joystick-area)
3. [Customization](#customization)
4. [Donate](#donate)

### Joystick

![Joystick](https://i.giphy.com/media/yd6bBNqinNcSRmOPAC/giphy.gif "Joystick")

The `Joystick` widget is a virtual joystick that allows users to drag a stick within a defined area.
You can customize its behavior and appearance. Here's how you can use it:

```dart
Joystick(listener: (details) {
...
})
```

**`Joystick` Arguments:**

| Parameter  | Description                                                                                                                                                                                                                           |
|------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `listener` | A callback function that is invoked at a specified frequency (`period`) when the joystick stick is dragged. The `listener` parameter, `details`, provides the stick's offset from the center of the base (ranging from -1.0 to +1.0). |
| `period`   | (Optional) The frequency at which the `listener` callback is triggered from the moment the stick is dragged. The default is 100 milliseconds.                                                                                         |
| `mode`     | (Optional) The possible direction mode of the joystick stick. The default mode is `all`, allowing movement in any direction: vertical, horizontal, and diagonal.                                                                      |

This information clarifies the purpose and usage of each parameter for the `Joystick` widget.

| Mode                    | Description                                                                                            |
|-------------------------|--------------------------------------------------------------------------------------------------------|
| `all`                   | Allows movement of the joystick stick in any direction: vertical, horizontal, and diagonal.            |
| `vertical`              | Restricts movement of the joystick stick to the vertical direction only.                               |
| `horizontal`            | Restricts movement of the joystick stick to the horizontal direction only.                             |
| `horizontalAndVertical` | Restricts movement of the joystick stick to both horizontal and vertical directions, but not diagonal. |

These modes define how the joystick stick can be moved, providing flexibility in tailoring the
joystick's behavior to specific requirements.

![Joystick Vertical](https://i.giphy.com/media/FXQG3ttV35Ca5L5ZA7/giphy.gif "Joystick Vertical")
![Joystick Horizontal](https://i.giphy.com/media/SN9YMtBKaHLkw5iIvB/giphy.gif "Joystick Horizontal")
![Joystick Horizontal And Vertical](https://i.giphy.com/media/znAdOQr52MmKTssc91/giphy.gif "Joystick Horizontal And Vertical")

### Joystick Area

![Joystick](https://i.giphy.com/media/2uFUWJcOaaTPFbIFBd/giphy.gif "Joystick Area")

The `JoystickArea` widget allows you to render a joystick anywhere within a designated area when the
user interacts with it. It shares similar properties with the `Joystick` widget.

```dart
JoystickArea(
  listener: (details) {
    ...
  },
  child: ...
)
```

**Additional `JoystickArea` Arguments:**

| Parameter                  | Description                                                                                                                               |
|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `initialJoystickAlignment` | (Optional) Sets the initial alignment of the joystick within the joystick area. By default, it is aligned to `Alignment.bottomCenter`.    |
| `child`                    | (Optional) The widget that is contained within the joystick area, allowing you to place other elements or widgets alongside the joystick. |

These arguments provide additional customization options for the `JoystickArea` widget, allowing you
to control the initial alignment and include child widgets for a more versatile user interface.

### Customization

![Square Joystick](https://i.giphy.com/media/kjGJmILAeBJFXGtcgt/giphy.gif "Square Joystick")

**Customization Options:**

Both the `Joystick` and `JoystickArea` widgets offer a range of customization options, allowing you
to personalize their appearance and behavior to suit your specific requirements.

| Parameter               | Description                                                                                                                                                                                                                            |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `base`                  | (Optional) The widget responsible for rendering the joystick's base. The default is `JoystickBase`.                                                                                                                                    |
| `stick`                 | (Optional) The widget that defines the appearance of the joystick stick. It is centered within the `base` widget. The default is `JoystickStick`.                                                                                      |
| `stickOffsetCalculator` | (Optional) Determines the stick's offset based on the starting position of the stick drag and its current position. The package currently supports circle and rectangle joystick shapes. The default is `CircleStickOffsetCalculator`. |

These customization parameters empower you to create distinctive and unique joystick experiences for
your Flutter applications.

## Donate

If you find this package helpful and want to support the developer, consider making a donation:

[![Donate](https://www.paypalobjects.com/en_US/PL/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=QE4E8RX8FW6P4)
[![Buy Me A Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=rebeloid&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)

Your contributions are greatly appreciated and motivate further development of plugins and packages.
