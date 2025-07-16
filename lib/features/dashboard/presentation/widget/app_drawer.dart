import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/features/annaunce/presentation/pages/announcement_list_screen.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/pages/accident/accident_list_screen.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/pages/daily_diaree_screen.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/pages/accident/headchecks_list_screen.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/pages/accident/sleepcheck_list_screen.dart';
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

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var divier = const Divider(height: 1, color: AppColors.black);
    return Drawer(
      child: PatternBackground(
        child: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: [
            CustomDrawerTile(
              icon: Icons.home,
              title: 'Dashboard',
              onTap: () {},
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
            divier,
            CustomDrawerTile(
              icon: Icons.campaign,
              title: 'Announcements',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AnnouncementsListScreen())),
            ),
            divier,
            CustomDrawerTile(
              icon: Icons.apartment,
              title: 'Rooms',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => RoomsListScreen())),
            ),
            divier,
            CustomDrawerExpansionTile(
              icon: Icons.fastfood,
              title: 'Healthy Eating',
              children: [
                CustomDrawerTile(title: 'Menu', onTap: () {}),
                CustomDrawerTile(title: 'Recipes', onTap: () {}),
              ],
            ),
            divier,
            CustomDrawerTile(
              icon: Icons.security_rounded,
              title: 'Service Details',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ServiceDetailsScreen())),
            ),
            divier,
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
                    onTap:  () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ManagePermissionsScreen()));
                    }),
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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // perform logout
                        },
                        child: const Text('Logout',
                            style: TextStyle(color: AppColors.errorColor)),
                      ),
                    ],
                  ),
                );
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
