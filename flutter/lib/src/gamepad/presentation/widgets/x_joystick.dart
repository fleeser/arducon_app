import 'package:flutter/material.dart';

import 'package:arducon/core/res/theme/palette.dart';

class XJoystick extends StatefulWidget {

  final Function(double)? onChanged;

  const XJoystick({
    super.key,
    this.onChanged
  });

  @override
  State<XJoystick> createState() => _XJoystickState();
}

class _XJoystickState extends State<XJoystick> {

  final double _stickBackgroundSize = 200.0;
  final double _stickSize = 80.0;

  double _positionX = 0;
  bool _isTouching = false;

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isTouching = true;
      _updatePosition(details.localPosition.dx);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isTouching) {
      _updatePosition(details.localPosition.dx);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isTouching = false;
      _updatePosition(0);
    });
  }

  void _updatePosition(double newX) {
    setState(() { _positionX = _clampPosition(newX); });
    widget.onChanged?.call(_isTouching ? _positionX / 100.0 : 0.0);
  }

  double _clampPosition(double position) {
    double radius = _stickBackgroundSize / 2.0;
    double newPosition = position - 100.0;

    if (newPosition < -radius) {
      newPosition = -radius;
    } else if (newPosition > radius) {
      newPosition = radius;
    }

    return newPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Container(
        width: _stickBackgroundSize,
        height: _stickBackgroundSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Palette.secondaryBackground
        ),
        child: Center(
          child: Transform.translate(
            offset: Offset(_isTouching ? _positionX : 0.0, 0.0),
            child: Container(
              width: _stickSize,
              height: _stickSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.brand
              )
            )
          )
        )
      )
    );
  }
}
