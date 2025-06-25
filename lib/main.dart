import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/add_announcement/add_announce_bloc.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_anounce_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/otp_verify/otp_verify_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/signup/signup_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/updatepassowd/update_passoword_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/use_type/user_type_bloc.dart';
import 'package:mydiaree/core/config/app_theme.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/user_type_screen.dart';
import 'package:mydiaree/features/auth/parent/presentation/bloc/login/parent_login_bloc.dart';
import 'package:mydiaree/features/auth/staff/presentation/bloc/login/staff_login_bloc.dart';
import 'package:mydiaree/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_bloc.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/add_room/add_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
import 'package:mydiaree/features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

double screenHeight = 0;
double screenWidth = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GlobalDataCubit(GlobleRepository()),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<UserTypeBloc>(
          create: (context) => UserTypeBloc(),
        ),
        BlocProvider<OtpVerifyBloc>(create: (context) => OtpVerifyBloc()),
        BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc()),
        BlocProvider<UpdatePasswordBloc>(
            create: (context) => UpdatePasswordBloc()),
        BlocProvider<SignupBloc>(create: (context) => SignupBloc()),
        BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc()),
        BlocProvider<RoomListBloc>(create: (context) => RoomListBloc()),
        BlocProvider<AddRoomBloc>(create: (context) => AddRoomBloc()),
        BlocProvider<ProgramPlanBloc>(create: (context) => ProgramPlanBloc()),
        BlocProvider<StaffLoginBloc>(create: (context) => StaffLoginBloc()),
        BlocProvider<ParentLoginBloc>(create: (context) => ParentLoginBloc()),
        BlocProvider<AddPlanBloc>(create: (context) => AddPlanBloc()),
        BlocProvider<AnnounceListBloc>(create: (context) => AnnounceListBloc()),
        BlocProvider<AnnounceBloc>(create: (context) => AnnounceBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: RAppTheme.lightTheme,
        darkTheme: RAppTheme.lightTheme,
        themeMode: ThemeMode.system,
        home: SplashScreen(),
      ),
    );
  }
}
