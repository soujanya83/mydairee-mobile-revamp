import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/features/annaunce/presentation/pages/announcement_list_screen.dart';
import 'package:mydiaree/features/observation/presentation/pages/observation_list_screen.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_state.dart';
import 'package:mydiaree/features/program_plan/presentation/pages/program_plan_list_screen.dart';
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
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [AppColors.kGradient1, AppColors.kGradient2],
        //   ),
        // ),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 30),
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.home, color: Colors.white),
              title: Text('Dashboard', style: titleTextStyle),
              onTap: () {},
            ),
            divider,
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.graphic_eq, color: Colors.white),
              title: Text('Observations', style: titleTextStyle),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ObservationListScreen();
                }));
              },
            ),
            divider,
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
                leading: const Icon(Icons.book, color: Colors.white),
                childrenPadding: childrenPadding,
                title: Text('QIP', style: titleTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                tilePadding: contentPadding,
                children: [
                  ListTile(
                    title: Text('Self Assessment', style: childrenTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('QIP Full', style: childrenTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            divider,
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
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.article, color: Colors.white),
              title: Text('Program Plans', style: titleTextStyle),
              onTap: () {
                print('hi');
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProgramPlansListScreen();
                }));
              },
            ),
            divider,
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.image, color: Colors.white),
              title: Text('Media', style: titleTextStyle),
              onTap: () {},
            ),
            divider,
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
                leading: const Icon(Icons.campaign, color: Colors.white),
                title: Text('Announcements', style: titleTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Announcements', style: childrenTextStyle),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AnnouncementsListScreen();
                      }));
                    },
                  ),
                  ListTile(
                    title: Text('Survey', style: childrenTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            divider,
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
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Recipes', style: childrenTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            divider,
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.local_florist, color: Colors.white),
              title: Text('Resources', style: titleTextStyle),
              onTap: () {},
            ),
            divider,
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
                leading: const Icon(Icons.account_balance_wallet,
                    color: Colors.white),
                title: Text('Daily Journal', style: titleTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Daily Dairy', style: childrenTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Head Checks', style: childrenTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Sleep Checklist', style: childrenTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Accident', style: childrenTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            divider,
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.refresh, color: Colors.white),
              title: Text('Reflection', style: titleTextStyle),
              onTap: () {},
            ),
            divider,
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
                leading: const Icon(Icons.show_chart, color: Colors.white),
                title: Text('Montessori', style: titleTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Progress Plan', style: childrenTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Lesson Plan', style: childrenTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            divider,
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.settings, color: Colors.white),
              title: Text('Settings', style: titleTextStyle),
              onTap: () {},
            ),
            divider,
            ListTile(
              contentPadding: contentPadding,
              leading: const Icon(Icons.security_rounded, color: Colors.white),
              title: Text('Service', style: titleTextStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ServiceDetailsScreen();
                }));
              },
            ),
            divider,
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
