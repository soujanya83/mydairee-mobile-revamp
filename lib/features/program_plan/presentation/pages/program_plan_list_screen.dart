import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_bloc.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_event.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_state.dart';
import 'package:mydiaree/features/program_plan/presentation/pages/add_program_plan_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/room/presentation/widget/room_list_custom_widgets.dart';
import 'package:mydiaree/main.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ProgramPlansListScreen extends StatelessWidget {
  ProgramPlansListScreen({super.key});

  String selectedCenterId = '';
  List<String> selectedProgramIds = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ProgramPlanBloc>()
          .add(const FetchProgramPlansEvent(centerId: '1'));
    });
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: "Program Plans",
      ),
      body: BlocConsumer<ProgramPlanBloc, ProgramPlanListState>(
        listener: (context, state) {
          if (state is ProgramPlanDeleted) {
            UIHelpers.showToast(
              context,
              message: "Program plans deleted successfully",
              backgroundColor: AppColors.successColor,
            );
            selectedProgramIds.clear();
            context.read<ProgramPlanBloc>().add(
                  FetchProgramPlansEvent(centerId: selectedCenterId.isEmpty ? '1' : selectedCenterId),
                );
          } else if (state is ProgramPlanError) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.errorColor,
            );
          }
        },
        builder: (context, state) {
          if (state is ProgramPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProgramPlanError) {
            return Center(child: Text(state.message));
          } else if (state is ProgramPlanLoaded) {
            if (state.prgramPlanListData?.data?.programPlans?.isEmpty ?? true) {
              return  const Center(child: Text(' No plans found.'));
            }
            final plans = state.prgramPlanListData!.data!.programPlans!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header

                  // Filters
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Program Plans',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontSize: 20),
                            ),
                            const Spacer(),
                            UIHelpers.addButton(
                              context: context,
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddProgramPlanScreen(
                                      centerId: selectedCenterId.isEmpty
                                          ? '1'
                                          : selectedCenterId,
                                      screenType: 'add',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        StatefulBuilder(builder: (context, setState) {
                          return CenterDropdown(
                            selectedCenterId: selectedCenterId,
                            onChanged: (value) {
                              setState(() {
                                selectedCenterId = value.id;
                                context.read<ProgramPlanBloc>().add(
                                    FetchProgramPlansEvent(centerId: value.id));
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  // Program Plan Cards
                  StatefulBuilder(builder: (context, setState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        final plan = plans[index];
                        final isSelected = selectedProgramIds.contains(plan.id);
                        return ProgramPlanCard(
                          index: index,
                          isSelected: isSelected,
                          onSelect: (selected) {
                            setState(() {
                              if (selected) {
                                selectedProgramIds.add(plan.id.toString());
                              } else {
                                selectedProgramIds.remove(plan.id.toString());
                              }
                            });
                          },
                          onEditPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProgramPlanScreen(
                                  centerId: selectedCenterId.isEmpty
                                      ? '1'
                                      : selectedCenterId,
                                  screenType: 'edit',
                                  programPlan: {},
                                ),
                              ),
                            );
                          },
                          onDeletePressed: () {
                            showDeleteConfirmationDialog(context, () {
                              context.read<ProgramPlanBloc>().add(
                                    DeleteProgramPlanEvent(
                                      planId: plan.id.toString(),
                                    ),
                                  );
                              Navigator.pop(context);
                            });
                          },
                          onPrintPressed: () {
                            UIHelpers.showToast(
                              context,
                              message: 'Print program plan ${plan.id}',
                              backgroundColor: AppColors.successColor,
                            );
                          },
                          id: plan.id?.toString() ?? '',
                          name: plan.room?.name?.name??'',
                          createdBy: plan.creator?.name?.name ?? '',
                          createdAt: plan.createdAt?.toString() ?? '',
                          endDate: plan.updatedAt?.toString() ?? '',
                        );
                      },
                    );
                  }),
                  // Delete Button
                  if (selectedProgramIds.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          minimumSize: const Size(double.infinity, 44),
                        ),
                        onPressed: () {
                          // showDeleteConfirmationDialog(context, () {
                          //   context.read<ProgramPlanBloc>().add(
                          //         DeleteProgramPlansEvent(
                          //           selectedProgramIds,
                          //           selectedCenterId.isEmpty
                          //               ? '1'
                          //               : selectedCenterId,
                          //         ),
                          //       );
                          //   Navigator.pop(context);
                          // });
                        },
                        child: const Text(
                          'Delete Selected',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.9,
            maxHeight: screenHeight * 0.4,
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
                  size: 32,
                  color: AppColors.errorColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                label: 'Confirm Sign Out',
                child: Text(
                  'Confirm Sign Out',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        letterSpacing: 0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Semantics(
                label: 'Are you sure you want to sign out of your account?',
                child: Text(
                  'Are you sure you want to sign out of your account?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
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
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: AppColors.primaryColor, width: 1),
                        ),
                        minimumSize: const Size(100, 40),
                      ),
                      child: Text(
                        'Cancel',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 13,
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
                      onPressed: () {
                        Navigator.pop(context);
                        // Perform logout (e.g., clear auth token, navigate to login screen)
                        // context.read<AuthBloc>().add(LogoutEvent());
                        // Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 2,
                        minimumSize: const Size(100, 40),
                      ),
                      child: Text(
                        'Sign Out',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 13,
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
}
class ProgramPlanCard extends StatelessWidget {
  final int index;
  final String id;
  final String name;
  final String createdBy;
  final String createdAt;
  final String endDate;
  final bool isSelected;
  final Function(bool) onSelect;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onPrintPressed;

  const ProgramPlanCard({
    required this.index,
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.endDate,
    required this.isSelected,
    required this.onSelect,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onPrintPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PatternBackground(
        elevation: isSelected ? 4 : 1,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onSelect(!isSelected),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID and Month
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.successColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${DateTime.tryParse(endDate)?.month != null ? DateFormat('MMMM').format(DateTime.tryParse(endDate)!) : ''} ${DateTime.tryParse(endDate)?.year ?? ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.successColor,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Room
                Text(
                  'Room: $name',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Created By
                Text(
                  'Created By: $createdBy',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Created Date and Updated Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Created: ${DateTime.tryParse(createdAt)?.let((date) => DateFormat('dd MMM yyyy / HH:mm').format(date)) ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Updated: ${DateTime.tryParse(endDate)?.let((date) => DateFormat('dd MMM yyyy / HH:mm').format(date)) ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // CustomActionButton(
                    //   icon: Icons.print,
                    //   color: AppColors.successColor,
                    //   tooltip: 'Print',
                    //   onPressed: onPrintPressed,
                    // ),
                    const SizedBox(width: 8),
                    CustomActionButton(
                      icon: Icons.edit,
                      color: AppColors.primaryColor,
                      tooltip: 'Edit',
                      onPressed: onEditPressed,
                    ),
                    const SizedBox(width: 8),
                    CustomActionButton(
                      icon: Icons.delete,
                      color: AppColors.errorColor,
                      tooltip: 'Delete',
                      onPressed: onDeletePressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String? tooltip;
  final VoidCallback onPressed;

  const CustomActionButton({
    required this.icon,
    required this.color,
    this.tooltip,
    required this.onPressed,
    super.key,
  });

  @override
  _CustomActionButtonState createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.95),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.identity()..scale(_scale),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(0.1),
            border: Border.all(color: widget.color, width: 1),
          ),
          child: Icon(
            widget.icon,
            color: widget.color,
            size: 20,
          ),
        ),
      ),
    );
  }
}

extension on DateTime {
  T? let<T>(T Function(DateTime) cb) => cb(this);
}
