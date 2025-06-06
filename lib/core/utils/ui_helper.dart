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
      icon: Icon(Icons.arrow_back_ios_new));
}
