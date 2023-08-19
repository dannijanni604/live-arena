import 'package:flutter/material.dart';

class ArenaStausButton extends StatelessWidget {
  const ArenaStausButton({
    Key? key,
    required this.color,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.icon,
  }) : super(key: key);
  final Color color;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.green.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
