// lib/widgets/custom_padding.dart
import 'package:flutter/material.dart';

enum PaddingSize { none, small, medium, large, custom }

class CustomPadding extends StatelessWidget {
  final Widget child;
  final PaddingSize? paddingSize;
  final EdgeInsetsGeometry? customPadding;

  const CustomPadding({
    super.key,
    required this.child,
    this.paddingSize = PaddingSize.none,
    this.customPadding,
  });

  EdgeInsetsGeometry _getPadding() {
    switch (paddingSize) {
      case PaddingSize.small:
        return const EdgeInsets.all(8.0);
      case PaddingSize.medium:
        return const EdgeInsets.all(16.0);
      case PaddingSize.large:
        return const EdgeInsets.all(24.0);
      case PaddingSize.custom:
        return customPadding ?? EdgeInsets.zero;
      case PaddingSize.none:
      default:
        return EdgeInsets.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _getPadding(),
      child: child,
    );
  }
}
