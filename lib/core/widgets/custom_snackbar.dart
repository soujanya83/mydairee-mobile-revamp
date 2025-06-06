
import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}