import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final void Function(BuildContext)? showNotifications;
  final int? notificationCount;
  final String? title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const CustomAppBar(
      {super.key,
      this.onMenuPressed,
      this.showNotifications,
      this.notificationCount,
      this.title,
      this.bottom,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsIconTheme: IconThemeData(color: AppColors.white),
      iconTheme: const IconThemeData(
          color: AppColors.white // Change this to your desired color
          ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.kGradient1, AppColors.kGradient2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),

      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      // leading: onMenuPressed != null
      //     ? IconButton(
      //         icon: const Icon(Icons.menu, color: Colors.white),
      //         onPressed: onMenuPressed,
      //       )
      //     : null,
      title: Text(title ?? '',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontSize: 20,
              )),
      bottom: bottom,
      actions: actions ??
          [
            if (showNotifications != null)
              Stack(
                children: [
                  IconButton(
                      icon:
                          const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {}),
                  if (notificationCount != null && notificationCount! > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
