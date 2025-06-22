import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_asset.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/user_type_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const UserTypeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height.toString());
    print(MediaQuery.of(context).size.width.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Image.asset(
        errorBuilder: (context, error, stackTrace) {
          return SizedBox();
        },
        AppAssets.splash,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        fit: BoxFit.fill,
      ),
    );
  }
}
