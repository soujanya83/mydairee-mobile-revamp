import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/use_type/user_state.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/use_type/user_type_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/use_type/user_type_event.dart';
import 'package:mydiaree/core/config/app_asset.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/login_screen.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/auth/parent/presentation/pages/parent_login_screen.dart';
import 'package:mydiaree/features/auth/staff/presentation/pages/staff_login_screen.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StatusBarCustom(
      child: CustomScaffold(
        body: BlocBuilder<UserTypeBloc, UserTypeState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  UIHelpers.logoHorizontal(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Select User Type",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSelectableOption(
                    context,
                    "Admin",
                    AppAssets.admin,
                    state.selectedRole == "Admin",
                  ),
                  _buildSelectableOption(
                    context,
                    "Staff",
                    AppAssets.staff,
                    state.selectedRole == "Staff",
                  ),
                  _buildSelectableOption(
                    context,
                    "Parent",
                    AppAssets.parent,
                    state.selectedRole == "Parent",
                  ),
                  const Spacer(),
                  if (state.showNextButton)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(200),
                              onTap: () =>
                                  _navigateBasedOnSelection(context, state),
                              splashColor: Colors.white.withOpacity(0.2),
                              highlightColor: Colors.white.withOpacity(0.1),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectableOption(
      BuildContext context, String role, String iconPath, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(200),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.white,
                    AppColors.white.withOpacity(0.1),
                    AppColors.primaryColor.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(200),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor.withOpacity(0.5)
                : AppColors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(200),
            onTap: () =>
                context.read<UserTypeBloc>().add(SelectUserTypeEvent(role)),
            splashColor: AppColors.primaryColor.withOpacity(0.1),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withOpacity(0.2)
                          : AppColors.greyShadeLight.withOpacity(.5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? AppColors.primaryColor
                            : AppColors.greyShade,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(iconPath),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      role,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.grey.shade800,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.greyShade,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateBasedOnSelection(BuildContext context, UserTypeState state) {
    switch (state.selectedRole) {
      case "Admin":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
        break;
      case "Staff":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => StaffLoginScreen()));
        break;
      case "Parent":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ParentLoginScreen()));
        break;
    }
  }
}
