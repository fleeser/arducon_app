import 'package:flutter/material.dart';

class GamepadTopButton extends StatelessWidget {

  final void Function()? onPressed;
  final Color color;
  final String title;

  const GamepadTopButton({ 
    super.key,
    this.onPressed,
    required this.color,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight - 16.0,
      child: RawMaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular((kToolbarHeight - 16.0) / 2.0),
          side: BorderSide(
            width: 1.5,
            color: color
          )
        ),
        fillColor: color.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Hind',
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: color
          )
        )
      )
    );
  }
}