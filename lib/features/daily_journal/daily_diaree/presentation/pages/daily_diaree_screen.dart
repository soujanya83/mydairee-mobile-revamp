import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_event.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_state.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/pages/add_entry_dialog.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/widget/daily_diaree_custom.dart';
import 'package:mydiaree/main.dart';

class DailyTrackingScreen extends StatelessWidget {
  const DailyTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DailyTrackingBloc>().add(LoadDailyTrackingEvent());
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Daily Childcare Tracking'),
      body: BlocListener<DailyTrackingBloc, DailyTrackingState>(
        listener: (context, state) {
          if (state is DailyTrackingError) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.errorColor,
            );
          } else if (state is DailyTrackingLoaded && state.isActivitySaved) {
            UIHelpers.showToast(
              context,
              message: 'Activity saved successfully',
              backgroundColor: AppColors.successColor,
            );
          }
        },
        child: BlocBuilder<DailyTrackingBloc, DailyTrackingState>(
          builder: (context, state) {
            if (state is DailyTrackingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DailyTrackingLoaded) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenWidth * .6,
                                    child: Row(
                                      children: [
                                        const FaIcon(FontAwesomeIcons.baby,
                                            size: 24),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: screenWidth * .5,
                                          child: Text(
                                            'Daily Childcare Tracking',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Monitor and track daily activities for all children',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              width: 100,
                              height: 40,
                              text: 'Add',
                              icon: const Icon(FontAwesomeIcons.plus),
                              ontap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AddEntryDialog(
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: state.children.length,
                          itemBuilder: (context, index) {
                            return ChildCard(child: state.children[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is DailyTrackingError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
