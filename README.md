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

[See Examples](https://joystick.rebeloid.com)
[Google Play](https://play.google.com/store/apps/details?id=com.rebeloid.flutter_joystick_example)

## Table of Contents

- [Joystick](#joystick)
- [Joystick Area](#joystick-area)
- [Customization](#customization)
- [Donate](#donate)
- [Contributors](#contributors)

### Joystick

![Joystick](https://i.giphy.com/media/Duip3rpjG1ie6aoCpO/giphy.gif "Joystick")

The `Joystick` widget is a virtual joystick that allows users to drag a stick within a defined area.
You can customize its behavior and appearance. Here's how you can use it:

```dart
Joystick(listener: (details) {
...
})
```

**`Joystick` Arguments:**

| Parameter                 | Description                                                                                                                                                                                                                           |
|---------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `listener`                | A callback function that is invoked at a specified frequency (`period`) when the joystick stick is dragged. The `listener` parameter, `details`, provides the stick's offset from the center of the base (ranging from -1.0 to +1.0). |
| `period`                  | (Optional) The frequency at which the `listener` callback is triggered from the moment the stick is dragged. The default is 100 milliseconds.                                                                                         |
| `mode`                    | (Optional) The possible direction mode of the joystick stick. The default mode is `all`, allowing movement in any direction: vertical, horizontal, and diagonal.                                                                      |
| `includeInitialAnimation` | (Optional) Decides if the stick's initial movement animation should be included. By default [true].                                                                                                                                   |

This information clarifies the purpose and usage of each parameter for the `Joystick` widget.

| Mode                    | Description                                                                                            |
|-------------------------|--------------------------------------------------------------------------------------------------------|
| `all`                   | Allows movement of the joystick stick in any direction: vertical, horizontal, and diagonal.            |
| `vertical`              | Restricts movement of the joystick stick to the vertical direction only.                               |
| `horizontal`            | Restricts movement of the joystick stick to the horizontal direction only.                             |
| `horizontalAndVertical` | Restricts movement of the joystick stick to both horizontal and vertical directions, but not diagonal. |

These modes define how the joystick stick can be moved, providing flexibility in tailoring the
joystick's behavior to specific requirements.

![Joystick Vertical](https://i.giphy.com/media/iB0a2rlSoVELXhLPc7/giphy.gif "Joystick Vertical")
![Joystick Horizontal](https://i.giphy.com/media/HoSUrgXNYHwd4QGhqv/giphy.gif "Joystick Horizontal")
![Joystick Horizontal And Vertical](https://i.giphy.com/media/CbUaPqNGNq1x7AhlQD/giphy.gif "Joystick Horizontal And Vertical")

### Joystick Area

![Joystick](https://i.giphy.com/media/yrh41z8I7t7Zo8ib9D/giphy.gif "Joystick Area")

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

**Customization Options:**

The `Joystick` and `JoystickArea` widgets are highly customizable, allowing you to tailor their appearance and behavior to fit your application's unique requirements. Below are the parameters you can adjust:

| Parameter               | Description                                                                                                                                                                                                                                                                                                                                  |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `base`                  | (Optional) The widget responsible for rendering the joystick's base. By default, it uses `JoystickBase`, but you can replace it with any widget to change its look. For example, you can use a custom image or a different shape.                                                                                                            |
| `stick`                 | (Optional) The widget that defines the appearance of the joystick stick. It is centered within the `base` widget. The default is `JoystickStick`, but you can customize it to be any widget, such as an icon, image, or animated widget.                                                                                                     |
| `stickOffsetCalculator` | (Optional) A function that determines the stick's offset based on the starting position of the stick drag and its current position. The package supports circular and rectangular shapes through `CircleStickOffsetCalculator` and `RectangleStickOffsetCalculator` respectively. You can create custom offset calculators for other shapes. |

These customization parameters empower you to create distinctive and unique joystick experiences for
your Flutter applications.

**Examples:**

| Code                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Example                                                                                      |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| <pre>Joystick(<br>  base: JoystickBase(<br>    decoration: JoystickBaseDecoration(<br>      middleCircleColor: Colors.red.shade400,<br>      drawOuterCircle: false,<br>      drawInnerCircle: false,<br>      boxShadowColor: Colors.red.shade100,<br>    ),<br>  ),<br>  stick: JoystickStick(<br>    decoration: JoystickStickDecoration(<br>      color: Colors.red,<br>    ),<br>  ),<br>  listener: (details) {..},<br>)</pre>                                                                                | ![Red Joystick](https://i.giphy.com/media/JXJcWRyq5d8sPQkYJX/giphy.gif "Red Joystick")       |
| <pre>Joystick(<br>  base: JoystickBase(<br>  decoration: JoystickBaseDecoration(<br>    color: Colors.black,<br>    drawOuterCircle: false,<br>  ),<br>  arrowsDecoration: JoystickArrowsDecoration(<br>      color: Colors.blue,<br>    ),<br>  ),<br>  listener: (details) {..},<br>)</pre>                                                                                                                                                                                                                       | ![Black Joystick](https://i.giphy.com/media/OdvkaWwrRCuwX8VgFw/giphy.gif "Black Joystick")   |
| <pre>Joystick(<br>  includeInitialAnimation: false,<br>  base: JoystickBase(<br>    decoration: JoystickBaseDecoration(<br>      color: Colors.orange,<br>    ),<br>    arrowsDecoration: JoystickArrowsDecoration(<br>    color: Colors.grey,<br>    enableAnimation: false,<br>    ),<br>  ),<br>  stick: JoystickStick(<br>    decoration: JoystickStickDecoration(<br>      color: Colors.grey,<br>      shadowColor: Colors.white.withOpacity(0.5)<br>    ),<br>  ),<br>  listener: (details) {..},<br>)</pre> | ![Orange Joystick](https://i.giphy.com/media/Be9jXR9AMAImgDjeAH/giphy.gif "Orange Joystick") |
| <pre>Joystick(<br>  base: JoystickSquareBase(),<br>  stickOffsetCalculator: const RectangleStickOffsetCalculator(),<br>  listener: (details) {..},<br>)</pre>                                                                                                                                                                                                                                                                                                                                                       | ![Square Joystick](https://i.giphy.com/media/72JO9ALy9ZeXgrWKIR/giphy.gif "Square Joystick") |
| <pre>Joystick(<br>  stick: const CircleAvatar(<br>    radius: 30,<br>    child: FlutterLogo(size: 50),<br>  ),<br>  base: Container(<br>    width: 200,<br>    height: 200,<br>    decoration: const BoxDecoration(<br>      color: Colors.grey,<br>      shape: BoxShape.circle,<br>    ),<br>  ),<br>  listener: (details) {..},<br>)</pre>                                                                                                                                                                       | ![Custom Joystick](https://i.giphy.com/media/EZ1MZodAC8RtdYO3jQ/giphy.gif "Custom Joystick") |

These examples highlight the flexibility of the joystick widget and provide a foundation for you to create your own customized joystick designs.

## Donate

If you find this package helpful and would like to support its continued development, please consider making a donation. Your contributions are greatly appreciated and motivate the further enhancement of this and other plugins.

[![Donate](https://www.paypalobjects.com/en_US/PL/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=QE4E8RX8FW6P4)
[![Buy Me A Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=rebeloid&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)

Your support helps in maintaining and improving this package, ensuring it remains up-to-date and useful for the community.

Thank you for your generosity!

## Contributors

<div align="left">
  <a href="https://github.com/pavelzaichyk/flutter_joystick/graphs/contributors">
   <img src="https://contrib.rocks/image?repo=pavelzaichyk/flutter_joystick"/>
  </a>
</div>