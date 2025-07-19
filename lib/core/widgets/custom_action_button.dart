import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final IconData icon;
  final double? iconSize;
  final VoidCallback onPressed;
  final Color color;
  final EdgeInsetsGeometry? padding;

  const CustomActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
    this.padding, this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: padding ?? const EdgeInsets.all(6),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Icon(icon, color: color, size:iconSize?? 20),
      ),
    );
  }
}
