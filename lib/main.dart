import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/otp_verify/otp_verify_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/updatepassowd/update_passoword_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/use_type/user_type_bloc.dart';
import 'package:mydiaree/core/config/app_theme.dart';
import 'package:mydiaree/features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

double screenHeight = 0;
double screenWidth = 0;

class MyApp extends StatelessWidget {
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
        BlocProvider<OtpVerifyBloc>(create: (context) => OtpVerifyBloc()),
        BlocProvider<ForgotPasswordBloc>(create: (context) => ForgotPasswordBloc()),
        BlocProvider<UpdatePasswordBloc>(create: (context) => UpdatePasswordBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: RAppTheme.lightTheme, // Apply the custom light theme
        darkTheme: RAppTheme.lightTheme, // Apply the custom dark theme
        themeMode: ThemeMode.system, // Use the current theme mode from provider
        home: const SplashScreen(),
      ),
    );
  }
}
