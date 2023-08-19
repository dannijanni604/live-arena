import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final Color? disabledColor;
  final EdgeInsets padding;
  final VoidCallback onPressed;
  final Widget? child;
  final bool isCircle;
  final double minimumWidth;
  final double minimumHeight;

  const RoundedButton({
    Key? key,
    this.text = '',
    this.fontSize = 16,
    this.color,
    this.disabledColor,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    required this.onPressed,
    this.isCircle = false,
    this.minimumWidth = 0,
    this.minimumHeight = 0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        primary: color,
        elevation: 0.0,
        padding: padding,
      ),
      onPressed: onPressed,
      child: text.isNotEmpty
          ? Text(
              text,
              style: TextStyle(fontSize: fontSize, color: Colors.white),
            )
          : child,
    );
  }
}
