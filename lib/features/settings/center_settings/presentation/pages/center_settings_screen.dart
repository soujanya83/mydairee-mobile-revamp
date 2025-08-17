import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_action_button.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/settings/center_settings/data/model/center_model.dart';
import 'package:mydiaree/features/settings/center_settings/data/repositories/center_repo.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/bloc/center_settings/center_setting_bloc.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/bloc/center_settings/center_setting_event.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/bloc/center_settings/center_setting_state.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/pages/add_center_screen.dart';
import 'dart:io';

class CentersSettingsScreen extends StatefulWidget {
  const CentersSettingsScreen({super.key});

  @override
  State<CentersSettingsScreen> createState() => _CentersSettingsScreenState();
}

class _CentersSettingsScreenState extends State<CentersSettingsScreen> {
  bool _isDeleting = false;
  final CentersRepository _repository = CentersRepository();

  @override
  void initState() {
    super.initState();
    context.read<CentersSettingsBloc>().add(FetchCentersEvent());
  }

  void _showDeleteConfirmationDialog(int centerId) {
    showDialog(
      context: context,
      barrierDismissible: !_isDeleting,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Stack(
            children: [
              AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('You will not be able to recover this Center!'),
                actions: [
                  TextButton(
                    onPressed: _isDeleting ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
                    onPressed: _isDeleting
                        ? null
                        : () async {
                            setStateDialog(() => _isDeleting = true);
                            Navigator.of(context).pop(); // Close dialog
                            await _deleteCenter(centerId);
                          },
                    child: _isDeleting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Yes, delete it!'),
                  ),
                ],
              ),
              if (_isDeleting)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteCenter(int centerId) async {
    setState(() => _isDeleting = true);
    bool success = false;
    try {
      success = await _repository.deleteCenter(centerId);
    } catch (e) {
      UIHelpers.showToast(context, message: 'Delete failed: $e', backgroundColor: AppColors.errorColor);
    }
    setState(() => _isDeleting = false);
    if (success) {
      UIHelpers.showToast(context, message: 'Center deleted successfully!', backgroundColor: AppColors.successColor);
      context.read<CentersSettingsBloc>().add(FetchCentersEvent());
    } else {
      UIHelpers.showToast(context, message: 'Failed to delete center', backgroundColor: AppColors.errorColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScaffold(
          appBar: const CustomAppBar(title: 'Centers Settings'),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Centers Settings',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    UIHelpers.addButton(
                      ontap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const AddCenterScreen(
                            isEdit: false,
                          );
                        }));
                      },
                      context: context,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            BlocConsumer<CentersSettingsBloc, CentersSettingsState>(
                              listener: (context, state) {
                                if (state is CentersSettingsSuccess) {
                                  UIHelpers.showToast(
                                    context,
                                    message: state.message,
                                    backgroundColor: AppColors.successColor,
                                  );
                                } else if (state is CentersSettingsFailure) {
                                  UIHelpers.showToast(
                                    context,
                                    message: state.message,
                                    backgroundColor: AppColors.errorColor,
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is CentersSettingsLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (state is CentersSettingsLoaded) {
                                  final centers = state.centers;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: centers.length,
                                    itemBuilder: (context, index) {
                                      final center = centers[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: PatternBackground(
                                          elevation: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Sr. No.: ${index + 1}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Center Name: ${center.centerName}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Street: ${center.streetAddress}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'City: ${center.city}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'State: ${center.state}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Zip: ${center.zip}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    CustomActionButton(
                                                      icon: Icons.edit_rounded,
                                                      color: AppColors.primaryColor,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => AddCenterScreen(
                                                              isEdit: true,
                                                              center: center,
                                                            ),
                                                          ),
                                                        ).then((value) {
                                                          if (value == true) {
                                                            context.read<CentersSettingsBloc>().add(FetchCentersEvent());
                                                          }
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(width: 8),
                                                    CustomActionButton(
                                                      icon: Icons.delete,
                                                      color: AppColors.errorColor,
                                                      onPressed: () {
                                                        _showDeleteConfirmationDialog(center.id);
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const Center(
                                    child: Text('No centers available'));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isDeleting)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
