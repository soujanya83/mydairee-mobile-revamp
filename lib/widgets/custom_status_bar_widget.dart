import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mydiaree/config/app_colors.dart';

class StatusBarCustom extends StatelessWidget {
  const StatusBarCustom(
      {super.key,
      required this.child,
      this.statusBarColor,
      this.isSafeArea,
      this.statusBarBrightness});
  final Widget child;
  final Brightness? statusBarBrightness;
  final Color? statusBarColor;
  final bool? isSafeArea;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: statusBarColor ?? AppColors.primaryColor,
          statusBarIconBrightness: statusBarBrightness ?? Brightness.dark,
        ),
        child: isSafeArea ?? true ? SafeArea(child: child) : child);
  }
}
