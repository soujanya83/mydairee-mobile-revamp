import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/users/assigned_user_bloc.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/users/assigned_user_event.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/users/assigned_user_state.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/pages/user_permission_dialog.dart';

class AssignedUserListScreen extends StatelessWidget {
  const AssignedUserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context
    //       .read<AssignerPermissionUserBloc>()
    //       .add(FetchUsersAndPermissions());
    // });

    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Assigned Users'),
      body:
          BlocListener<AssignerPermissionUserBloc, AssignerPermissionUserState>(
        listener: (context, state) {
          if (state is AssignerPermissionUserLoaded) {
            UIHelpers.showToast(
              context,
              message: 'loaded',
              backgroundColor: AppColors.successColor,
            );
          } else if (state is AssignerPermissionUserError) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.errorColor,
            );
          }
        },
        child: BlocBuilder<AssignerPermissionUserBloc,
            AssignerPermissionUserState>(
          builder: (context, state) {
            if (state is AssignerPermissionUserLoading ||
                state is AssignerPermissionUserAdded) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AssignerPermissionUserLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PatternBackground(
                      child: ListTile(
                        title: Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        trailing: const Icon(
                          Icons.remove_red_eye,
                          color: AppColors.primaryColor,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => PermissionDialog(
                              user: user,
                              allPermissions: user.permissions,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is AssignerPermissionUserError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Retry',
                      height: 45,
                      width: 100,
                      ontap: () => context
                          .read<AssignerPermissionUserBloc>()
                          .add(FetchUsersAndPermissions()),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No data'));
          },
        ),
      ),
    );
  }
}
