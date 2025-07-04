import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_asset.dart';

class PatternBackground extends StatelessWidget {
  final Widget child;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final BoxBorder? border;

  const PatternBackground(
      {super.key,
      required this.child,
      this.border,
      this.boxShadow,
      this.borderRadius,
      this.elevation,
      this.padding,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      elevation: elevation ?? 1,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          border: border,
          // margin: const EdgeInsets.all(6),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(10),
          //   side: isSelected
          //       ? const BorderSide(color: AppColors.primaryColor, width: 2)
          //       : BorderSide.none,
          // ),

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
