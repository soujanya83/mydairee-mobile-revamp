import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mydiaree/core/config/app_colors.dart';

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
          statusBarIconBrightness: statusBarBrightness ?? Brightness.light,
        ),
        child: isSafeArea ?? true ? SafeArea(child: child) : child);
  }
}
