import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_state.dart';
import 'package:mydiaree/features/program_plan/presentation/pages/program_plan_list_screen.dart';
import 'package:mydiaree/features/room/presentation/pages/room_list_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final TextStyle? drawerTextStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: AppColors.white);
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.kGradient1, AppColors.kGradient2],
          ),
        ),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: Text('Dashboard', style: drawerTextStyle),
              onTap: () {},
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
            ListTile(
              leading: const Icon(Icons.graphic_eq, color: Colors.white),
              title: Text('Observations', style: drawerTextStyle),
              onTap: () {},
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
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
                title: Text('QIP', style: drawerTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Self Assessment', style: drawerTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('QIP Full', style: drawerTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
            ListTile(
              leading: const Icon(Icons.apartment, color: Colors.white),
              title: Text('Rooms', style: drawerTextStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RoomsListScreen();
                }));
              },
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
            ListTile(
              leading: const Icon(Icons.article, color: Colors.white),
              title: Text('Program Plans', style: drawerTextStyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ProgramPlansListScreen();
                }));
              },
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.white),
              title: Text('Media', style: drawerTextStyle),
              onTap: () {},
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
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
                leading: const Icon(Icons.campaign, color: Colors.white),
                title: Text('Announcements', style: drawerTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Announcements', style: drawerTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Survey', style: drawerTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
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
                leading: const Icon(Icons.fastfood, color: Colors.white),
                title: Text('Healthy Eating', style: drawerTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Menu', style: drawerTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Recipes', style: drawerTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
            ListTile(
              leading: const Icon(Icons.local_florist, color: Colors.white),
              title: Text('Resources', style: drawerTextStyle),
              onTap: () {},
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
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
                leading: const Icon(Icons.account_balance_wallet,
                    color: Colors.white),
                title: Text('Daily Journal', style: drawerTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Daily Dairy', style: drawerTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Head Checks', style: drawerTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Sleep Checklist', style: drawerTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Accident', style: drawerTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.white),
              title: Text('Reflection', style: drawerTextStyle),
              onTap: () {},
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
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
                leading: const Icon(Icons.show_chart, color: Colors.white),
                title: Text('Montessori', style: drawerTextStyle),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Progress Plan', style: drawerTextStyle),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Lesson Plan', style: drawerTextStyle),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: Text('Settings', style: drawerTextStyle),
              onTap: () {},
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
            ListTile(
              leading: const Icon(Icons.security_rounded, color: Colors.white),
              title: Text('Service', style: drawerTextStyle),
              onTap: () {},
            ),
            Divider(color: Colors.white.withOpacity(0.8)),
            ListTile(
              leading: const Icon(Icons.settings_power, color: Colors.white),
              title: Text('Logout', style: drawerTextStyle),
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
                        child: Text('Logout',
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
