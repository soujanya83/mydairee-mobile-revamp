import 'package:flutter/material.dart'; 
import 'package:mydiaree/config/app_asset.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body, this.appBar,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      /// Background Image
      Positioned.fill(
        child: Image.asset(
          AppAssets.background, // replace with your image path
          fit: BoxFit.cover,
        ),
      ),
      Scaffold(
        appBar: appBar,
        backgroundColor: Colors.transparent,
        body: body,
      )
    ]);
  }
}
