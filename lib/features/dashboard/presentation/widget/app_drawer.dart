import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/features/annaunce/presentation/pages/announcement_list_screen.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/pages/accident/accident_list_screen.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/pages/accident/sleepcheck_list_screen.dart';
import 'package:mydiaree/features/observation/presentation/pages/observation_list_screen.dart';
import 'package:mydiaree/features/program_plan/presentation/pages/program_plan_list_screen.dart';
import 'package:mydiaree/features/reflection/presentation/pages/reflection_list_screen.dart';
import 'package:mydiaree/features/room/presentation/pages/room_list_screen.dart';
import 'package:mydiaree/features/service_detail/presentation/pages/service_detail_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleTextStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: AppColors.black, fontSize: 15);
    final TextStyle? childrenTextStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: AppColors.black, fontSize: 13);
    final Widget divider = Divider(color: Colors.black.withOpacity(0.8));

    final EdgeInsetsGeometry childrenPadding = EdgeInsets.only(left: 40);
    final EdgeInsetsGeometry contentPadding = EdgeInsets.only(left: 0);

    return Drawer(
      child: PatternBackground(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 30),
            // 1. Dashboard
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.home, color: Colors.white),
              title: Text('Dashboard', style: titleTextStyle),
              onTap: () {},
            ),
            divider,

            // 2. Observation
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.graphic_eq, color: Colors.white),
              title: Text('Observation', style: titleTextStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ObservationListScreen();
                }));
              },
            ),
            divider,

            // 3. Rooms
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.apartment, color: Colors.white),
              title: Text('Rooms', style: titleTextStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RoomsListScreen();
                }));
              },
            ),
            divider,

            // 4. Daily Reflections
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.refresh, color: Colors.white),
              title: Text('Daily Reflections', style: titleTextStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ReflectionListScreen();
                }));
              },
            ),
            divider,

            // 5. Program Plan
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.article, color: Colors.white),
              title: Text('Program Plan', style: titleTextStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProgramPlansListScreen();
                }));
              },
            ),
            divider,

            // 6. Service Details
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.security_rounded, color: Colors.white),
              title: Text('Service Details', style: titleTextStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ServiceDetailsScreen();
                }));
              },
            ),
            divider,

            // 7. Announcements
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.campaign, color: Colors.white),
              title: Text('Announcements', style: titleTextStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AnnouncementsListScreen();
                }));
              },
            ),
            divider,

            // 8. Daily Journal
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
              child: ExpansionTile(
                tilePadding: contentPadding,
                childrenPadding: childrenPadding,
                leading: const Icon(Icons.book, color: Colors.white),
                title: Text('Daily Journal', style: titleTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                  title: Text('Daily Diary', style: childrenTextStyle),
                  onTap: () {}, // Add relevant screen
                  ),
                  ListTile(
                  title: Text('Head Checks', style: childrenTextStyle),
                  onTap: () {}, // Add relevant screen
                  ),
                  ListTile(
                  title: Text('Sleep Checklist', style: childrenTextStyle),
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return const SleepCheckListScreen();
                    }));
                  },
                  ),
                  ListTile(
                  title: Text('Accident', style: childrenTextStyle),
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return AccidentListScreen();
                    }));
                  },
                  ),
                ],
              ),
            ),
            divider,

            // 9. Settings
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.settings, color: Colors.white),
              title: Text('Settings', style: titleTextStyle),
              onTap: () {},
            ),
            divider,

            // 10. Healthy Eating
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
              child: ExpansionTile(
                tilePadding: contentPadding,
                childrenPadding: childrenPadding,
                leading: const Icon(Icons.fastfood, color: Colors.white),
                title: Text('Healthy Eating', style: titleTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Menu', style: childrenTextStyle),
                    onTap: () {}, // Add navigation
                  ),
                  ListTile(
                    title: Text('Recipes', style: childrenTextStyle),
                    onTap: () {}, // Add navigation
                  ),
                ],
              ),
            ),
            divider,

            // Logout
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.settings_power, color: Colors.white),
              title: Text('Logout', style: titleTextStyle),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Perform logout
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
