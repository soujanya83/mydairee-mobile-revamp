import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/features/annaunce/presentation/pages/announcement_list_screen.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/login_screen.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/pages/accident/accident_list_screen.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/pages/accident_list_screen.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/pages/daily_diaree_screen.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/pages/accident/headchecks_list_screen.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks%20copy/presentation/pages/accident/sleepcheck_list_screen.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/pages/sleep_check_list_screen.dart';
import 'package:mydiaree/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/pages/ingredient_list_screen.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/pages/menu_screen.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/pages/reciepe_screen.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/pages/learning_and_progress_screen.dart';
import 'package:mydiaree/features/observation/presentation/pages/observation_list_screen.dart';
import 'package:mydiaree/features/program_plan/presentation/pages/program_plan_list_screen.dart';
import 'package:mydiaree/features/reflection/presentation/pages/reflection_list_screen.dart';
import 'package:mydiaree/features/room/presentation/pages/room_list_screen.dart';
import 'package:mydiaree/features/service_detail/presentation/pages/service_detail_screen.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/pages/center_settings_screen.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/pages/manage_permissions_screen.dart';
import 'package:mydiaree/features/settings/parent_setting/presentation/pages/parent_settings_screen.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/pages/staff_settings_screen.dart';
import 'package:mydiaree/features/settings/super_admin_settings/presentation/pages/supere_admin_settings_screen.dart';
import 'package:mydiaree/features/snapshot/presentation/pages/snapshot_screen.dart';
import 'package:mydiaree/main.dart'; 
import 'package:mydiaree/core/services/shared_preference_service.dart';
import 'package:mydiaree/features/settings/profile_setting/presentation/pages/profile_setting_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isParent = UserTypeHelper.isParent;
    var divier = const Divider(height: 1, color: AppColors.black);
    return Drawer(
      child: PatternBackground(
        child: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: [
            CustomDrawerTile(
              icon: Icons.home,
              title: 'Dashboard',
              onTap: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>  DashboardScreen()), (route) => false);
              },
            ),
            divier,
            CustomDrawerExpansionTile(
              icon: Icons.book,
              title: 'Daily Journal',
              children: [
                CustomDrawerTile(
                  showDivider: false,
                  title: 'Daily Diary',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DailyTrackingScreen())),
                ),
                if(!isParent)
                CustomDrawerTile(
                  showDivider: false,
                  title: 'Head Checks',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HeadChecksScreen())),
                ),
                CustomDrawerTile(
                  showDivider: false,
                  title: 'Sleep Checklist',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SleepCheckListScreen())),
                ),
                CustomDrawerTile(
                  title: 'Accident',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AccidentListScreen())),
                ),
              ],
            ),
            divier,
            CustomDrawerTile(
              icon: Icons.article,
              title: 'Program Plan',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ProgramPlansListScreen())),
            ),
            divier,
            CustomDrawerTile(
              icon: Icons.refresh,
              title: 'Daily Reflections',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ReflectionListScreen())),
            ),
            divier,
            CustomDrawerTile(
              icon: Icons.graphic_eq,
              title: 'Observation',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ObservationListScreen())),
            ),
            divier,
            CustomDrawerTile(
              icon: Icons.photo_camera_back_rounded,
              title: 'Snapshots',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SnapshotScreen())),
            ),
             if(!isParent)
            divier,
            if(!isParent)
            CustomDrawerTile(
              icon: Icons.campaign,
              title: 'Announcements',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AnnouncementsListScreen())),
            ), if(!isParent)
            divier, if(!isParent)
            CustomDrawerTile(
              icon: Icons.apartment,
              title: 'Rooms',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => RoomsListScreen())),
            ),
            divier,
            CustomDrawerTile(
              icon: Icons.production_quantity_limits,
              title: 'Lesson Plan',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LearningAndProgressScreen())),
            ),
            divier,
            CustomDrawerExpansionTile(
              icon: Icons.fastfood,
              title: 'Healthy Eating',
              children: [
                CustomDrawerTile(
                    title: 'Menu',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => MenuScreen()));
                    }),
                    if(!isParent)
                CustomDrawerTile(
                    title: 'Recipes',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RecipeScreen()));
                    }),if(!isParent)
                CustomDrawerTile(
                    title: 'Ingredients',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const IngredientListScreen()));
                    }),
              ],
            ), if(!isParent)
            divier, if(!isParent)
            CustomDrawerTile(
              icon: Icons.security_rounded,
              title: 'Service Details',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ServiceDetailsScreen())),
            ), if(!isParent)
            divier, if(!isParent)
            CustomDrawerExpansionTile(
              icon: Icons.book,
              title: 'Settings',
              children: [
                CustomDrawerTile(
                  showDivider: false,
                  title: 'Super-Admin-Settings',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SuperAdminSettingsScreen()));
                  },
                ),
                CustomDrawerTile(
                    showDivider: false,
                    title: 'Center Settings',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CentersSettingsScreen()));
                    }),
                CustomDrawerTile(
                    showDivider: false,
                    title: 'Staff Setting',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => StaffSettingsScreen()));
                    }),

                CustomDrawerTile(
                    showDivider: false,
                    title: 'Parent Setting',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ParentSettingsScreen()));
                    }),
                CustomDrawerTile(
                    showDivider: false,
                    title: 'Manage Permissions',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ManagePermissionsScreen()));
                    }),
                CustomDrawerTile(
                  showDivider: false,
                  title: 'Profile Settings',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileSettingScreen(
                                 
                                )));
                  },
                ),
                // CustomDrawerTile(
                //   title: 'Accident',
                //   onTap: () {}
                // ),
              ],
            ),
            divier,
            CustomDrawerTile(
              icon: Icons.settings_power,
              title: 'Logout',
              onTap: () {
                logoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawerTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const CustomDrawerTile({
    super.key,
    this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = false,
  });

  Widget copyWithDivider(bool value) {
    return CustomDrawerTile(
      icon: icon,
      title: title,
      onTap: onTap,
      showDivider: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleTextStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: AppColors.black, fontSize: 15);
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 0),
          leading: icon != null ? Icon(icon, color: Colors.white) : null,
          title: Text(title, style: titleTextStyle),
          onTap: onTap,
        ),
        if (showDivider) Divider(color: Colors.black.withOpacity(0.8)),
      ],
    );
  }
}

class CustomDrawerExpansionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<CustomDrawerTile> children;

  const CustomDrawerExpansionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleTextStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(
            color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w600);

    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            unselectedWidgetColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.white,
              onSurface: Colors.white,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.white24,
              highlightColor: Colors.white10,
              unselectedWidgetColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Colors.white,
                onSurface: Colors.white,
              ),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.only(left: 0, right: 10),
              childrenPadding: const EdgeInsets.only(left: 50, right: 10),
              leading: Icon(icon, color: Colors.white),
              title: Text(title, style: titleTextStyle),
              trailing: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.white), // custom icon
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              collapsedBackgroundColor: Colors.transparent,
              children: children.map((child) => child).toList(),
            ),
          ),
        ),
        // Divider(color: Colors.black.withOpacity(0.8)),
      ],
    );
  }
}

logoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.9,
          minWidth: screenWidth * 0.6,
          maxHeight: screenHeight * 0.35,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: 'Logout warning icon',
              child: Icon(
                Icons.warning_rounded,
                size: 36,
                color: AppColors.errorColor.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              label: 'Confirm Sign Out',
              child: Text(
                'Confirm Sign Out',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      letterSpacing: 0.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              label: 'Are you sure you want to sign out of your account?',
              child: Text(
                'Are you sure you want to sign out of your account?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Semantics(
                  label: 'Cancel sign out',
                  button: true,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            BorderSide(color: AppColors.primaryColor, width: 1),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                    ),
                  ),
                ),
                Semantics(
                  label: 'Confirm sign out',
                  button: true,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Clear the authentication token
                      await clearToken();

                      // Close the dialog
                      Navigator.pop(context);

                      // Navigate to UserTypeScreen and clear navigation stack
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false, // This removes all previous routes
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Sign Out',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
