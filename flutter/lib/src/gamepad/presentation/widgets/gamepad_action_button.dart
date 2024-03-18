import 'package:flutter/material.dart';

import 'package:arducon/core/res/theme/palette.dart';

class GamepadActionButton extends StatelessWidget {

  final void Function()? onPressed;
  final IconData icon;

  const GamepadActionButton({
    super.key,
    this.onPressed,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: RawMaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        fillColor: Palette.secondaryBackground,
        elevation: 0.0,
        focusElevation: 0.0,
        hoverElevation: 0.0,
        disabledElevation: 0.0,
        highlightElevation: 0.0,
        child: Icon(
          icon,
          size: 46.0,
          color: Palette.primaryIcon
        )
      )
    );
  }
}