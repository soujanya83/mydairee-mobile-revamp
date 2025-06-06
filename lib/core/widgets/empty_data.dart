// lib/widgets/empty_state_widget.dart
import 'package:flutter/material.dart';

class EmptyDataWidget extends StatelessWidget {
  final String message;
  final String? imageAsset;
  final double imageHeight;
  final TextStyle? textStyle;

  const EmptyDataWidget({
    super.key,
    required this.message,
    this.imageAsset,
    this.imageHeight = 150,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageAsset != null)
            Image.asset(
              imageAsset!,
              height: imageHeight,
            ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: textStyle ??
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
          ),
        ],
      ),
    );
  }
}
