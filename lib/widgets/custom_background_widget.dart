import 'package:flutter/material.dart';
import 'package:mydiaree/config/app_asset.dart';

class PatternBackground extends StatelessWidget {
  final Widget child;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;
  final double? elevation;

  const PatternBackground(
      {super.key,
      required this.child,
      this.boxShadow,
      this.borderRadius,
      this.elevation});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius:borderRadius?? BorderRadius.circular(12),
      elevation:elevation?? 1,
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(AppAssets.background),
            fit: BoxFit.cover,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          boxShadow: boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: child,
      ),
    );
  }
}
