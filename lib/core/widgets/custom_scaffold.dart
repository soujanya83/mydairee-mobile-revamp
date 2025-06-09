import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_asset.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Image.asset(
          AppAssets.background,
          fit: BoxFit.cover,
        ),
      ),
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar ??
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: true,
              centerTitle: true,
            ),
        backgroundColor: Colors.transparent,
        body: body,
      )
    ]);
  }
}
