import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_asset.dart';
import 'package:mydiaree/features/dashboard/presentation/widget/app_drawer.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.extendBodyBehindAppBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  final AppDrawer? drawer;
  final bool? extendBodyBehindAppBar;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
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
        
        drawer: drawer,
        extendBodyBehindAppBar: extendBodyBehindAppBar??false,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
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
