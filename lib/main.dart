import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/use_type/user_type_bloc.dart';
import 'package:mydiaree/core/config/app_theme.dart';
import 'package:mydiaree/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:mydiaree/features/auth/presentation/pages/login_screen.dart';
import 'package:mydiaree/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:mydiaree/features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

double screenHeight = 0;
double screenWidth = 0;

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
          BlocProvider<UserTypeBloc>(
          create: (context) => UserTypeBloc(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: RAppTheme.lightTheme, // Apply the custom light theme
        darkTheme: RAppTheme.lightTheme, // Apply the custom dark theme
        themeMode: ThemeMode.system, // Use the current theme mode from provider
        home:   const ForgotPasswordScreen(),
      ), 
    );
  }
}