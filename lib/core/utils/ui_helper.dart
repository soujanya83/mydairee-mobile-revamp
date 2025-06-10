import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_asset.dart';

class UIHelpers {
  static Widget verticalSpace(double height) => SizedBox(height: height);
  static Widget horizontalSpace(double width) => SizedBox(width: width);

  static Widget logo({double height = 60}) =>
      Image.asset(AppAssets.mydiaree_horizontal, height: height);

  static Widget logoHorizontal({double height = 60, double width = 200}) =>
      Image.asset(
        AppAssets.mydiaree_horizontal,
        height: height,
        width: width,
      );
  static Widget popIcon(BuildContext context) => IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios_new));


      static void showToast(
        BuildContext context, {
        required String message,
        Color backgroundColor = Colors.black87,
        Color textColor = Colors.white,
        double fontSize = 16.0,
        EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(8)),
        ToastGravity gravity = ToastGravity.bottom,
        Duration duration = const Duration(seconds: 2),
      }) {
        final overlay = Overlay.of(context);
        final overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: gravity == ToastGravity.top ? 50 : null,
            bottom: gravity == ToastGravity.bottom ? 50 : null,
            left: 24,
            right: 24,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: borderRadius,
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: textColor, fontSize: fontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );

        overlay.insert(overlayEntry);
        Future.delayed(duration, () {
          overlayEntry.remove();
        });
      }
      }

      enum ToastGravity { top, bottom }
