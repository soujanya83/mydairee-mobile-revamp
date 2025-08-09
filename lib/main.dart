import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/add_announcement/add_announce_bloc.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_anounce_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/otp_verify/otp_verify_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/signup/signup_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/updatepassowd/update_passoword_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/use_type/user_type_bloc.dart';
import 'package:mydiaree/core/config/app_theme.dart';
import 'package:mydiaree/features/auth/parent/presentation/bloc/login/parent_login_bloc.dart';
import 'package:mydiaree/features/auth/staff/presentation/bloc/login/staff_login_bloc.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_bloc.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_bloc.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/bloc/accident_list/headchecks_list_bloc.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/bloc/accident_list/sleepcheks_list_bloc.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_bloc.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_bloc.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/list/reciepe_bloc.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/list/learning_and_progress_bloc.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/view_progress/view_progress_bloc.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_bloc.dart';
import 'package:mydiaree/features/observation/presentation/bloc/list_room/obsevation_list_bloc.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_bloc.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_bloc.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/add_relection/add_reflection_bloc.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/list_room/reflection_list_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/view_room/vieiw_room_bloc.dart';
import 'package:mydiaree/features/service_detail/presentation/bloc/add_room/service_detail_bloc.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/bloc/center_settings/center_setting_bloc.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/list/manage_permission_bloc.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/users/assigned_user_bloc.dart';
import 'package:mydiaree/features/settings/parent_setting/presentation/bloc/list/parent_setting_bloc.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_bloc.dart';
import 'package:mydiaree/features/settings/super_admin_settings/presentation/bloc/list/super_admin_setting_bloc.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/add_snapshot/add_snapshot_bloc.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_bloc.dart';
import 'package:mydiaree/features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserTypeHelper.init();
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
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<UserTypeBloc>(create: (context) => UserTypeBloc()),
        BlocProvider<OtpVerifyBloc>(create: (context) => OtpVerifyBloc()),
        BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc()),
        BlocProvider<UpdatePasswordBloc>(
            create: (context) => UpdatePasswordBloc()),
        BlocProvider<SignupBloc>(create: (context) => SignupBloc()),
        BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc()),
        BlocProvider<RoomListBloc>(create: (context) => RoomListBloc()),
        BlocProvider<ProgramPlanBloc>(create: (context) => ProgramPlanBloc()),
        BlocProvider<StaffLoginBloc>(create: (context) => StaffLoginBloc()),
        BlocProvider<ParentLoginBloc>(create: (context) => ParentLoginBloc()),
        BlocProvider<AddPlanBloc>(create: (context) => AddPlanBloc()),
        BlocProvider<AnnounceListBloc>(create: (context) => AnnounceListBloc()),
        BlocProvider<AnnounceBloc>(create: (context) => AnnounceBloc()),
        BlocProvider<ServiceDetailBloc>(
            create: (context) => ServiceDetailBloc()),
        BlocProvider<ObservationListBloc>(
            create: (context) => ObservationListBloc()),
        BlocProvider<ViewObservationBloc>(
            create: (context) => ViewObservationBloc()),
        BlocProvider<ReflectionListBloc>(
            create: (context) => ReflectionListBloc()),
        BlocProvider<AddReflectionBloc>(
            create: (context) => AddReflectionBloc()),
        BlocProvider<AccidentListBloc>(create: (context) => AccidentListBloc()),
        BlocProvider<SleepChecklistBloc>(
            create: (context) => SleepChecklistBloc()),
        BlocProvider<HeadChecksBloc>(create: (context) => HeadChecksBloc()),
        BlocProvider<DailyTrackingBloc>(
            create: (context) => DailyTrackingBloc()),
        BlocProvider<SnapshotBloc>(create: (context) => SnapshotBloc()),
        BlocProvider<AddSnapshotBloc>(create: (context) => AddSnapshotBloc()),
        BlocProvider<CentersSettingsBloc>(
            create: (context) => CentersSettingsBloc()),
        BlocProvider<SuperAdminSettingsBloc>(
            create: (context) => SuperAdminSettingsBloc()),
        BlocProvider<StaffSettingsBloc>(
            create: (context) => StaffSettingsBloc()),
        BlocProvider<ParentSettingsBloc>(
            create: (context) => ParentSettingsBloc()),
        BlocProvider<PermissionBloc>(create: (context) => PermissionBloc()),
        BlocProvider<AssignerPermissionUserBloc>(
            create: (context) => AssignerPermissionUserBloc()),
        BlocProvider<MenuBloc>(create: (context) => MenuBloc()),
        BlocProvider<RecipeBloc>(create: (context) => RecipeBloc()),
        BlocProvider<IngredientBloc>(create: (context) => IngredientBloc()),
        BlocProvider<LearningAndProgressBloc>(
            create: (context) => LearningAndProgressBloc()),
        BlocProvider<ViewProgressBloc>(create: (context) => ViewProgressBloc()),
        BlocProvider<ViewRoomBloc>(create: (context) => ViewRoomBloc()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: RAppTheme.lightTheme,
          darkTheme: RAppTheme.lightTheme,
          themeMode: ThemeMode.system,
          home: const SplashScreen()),
    );
  }
}
