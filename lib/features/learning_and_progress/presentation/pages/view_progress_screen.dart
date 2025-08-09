import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/learning_and_progress/data/model/assessment_model.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/view_progress/view_progress_bloc.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/view_progress/view_progress_event.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/view_progress/view_progress_state.dart';

class ViewProgressScreen extends StatefulWidget {
  final String childId;
  const ViewProgressScreen({required this.childId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ViewProgressScreenState createState() => _ViewProgressScreenState();
}

class _ViewProgressScreenState extends State<ViewProgressScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<ViewProgressBloc>()
        .add(FetchAssessmentsEvent(childId: widget.childId));
  }

  @override
  Widget build(BuildContext context) {
    
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: "View Progress",
      ),
      body: BlocConsumer<ViewProgressBloc, ViewProgressState>(
        listener: (context, state) {
          if (state is ViewProgressStatusUpdated) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.successColor,
            );
          } else if (state is ViewProgressError) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.errorColor,
            );
          }
        },
        builder: (context, state) {
          if (state is ViewProgressLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ViewProgressError) {
            return Center(child: Text(state.message));
          } else if (state is ViewProgressLoaded) {
            final assessments = state.assessments;
            return ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: assessments.length,
              itemBuilder: (context, index) {
                final assessment = assessments[index];
                return AssessmentItemCard(
                  assessment: assessment,
                  onStatusTap: () {
                    // final nextStatus = _getNextStatus(assessment.status);
                    // showConfirmationDialog(
                    //   context,
                    //   title: 'Update Status',
                    //   message: 'Change status to ${nextStatus.name.replaceFirst(nextStatus.name[0], nextStatus.name[0].toUpperCase())}?',
                    //   onConfirm: () {
                    //     context.read<ViewProgressBloc>().add(
                    //           UpdateAssessmentStatusEvent(
                    //             assessmentId: assessment.id,
                    //             childId: widget.childId,
                    //             newStatus: nextStatus,
                    //           ),
                    //         );
                    //     Navigator.pop(context);
                    //   },
                    // );
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  AssessmentStatus _getNextStatus(AssessmentStatus current) {
    const statuses = [
      AssessmentStatus.notStarted,
      AssessmentStatus.introduced,
      AssessmentStatus.practicing,
      AssessmentStatus.completed,
    ];
    final currentIndex = statuses.indexOf(current);
    return statuses[(currentIndex + 1) % statuses.length];
  }
}

class AssessmentItemCard extends StatelessWidget {
  final AssessmentModel assessment;
  final VoidCallback onStatusTap;

  const AssessmentItemCard({
    required this.assessment,
    required this.onStatusTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onStatusTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Triangle Indicator
              GestureDetector(
                onTap: onStatusTap,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CustomPaint(
                    painter: TrianglePainter(status: assessment.status),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assessment.activityTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assessment.subActivityTitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(assessment.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  assessment.status == AssessmentStatus.notStarted
                      ? ''
                      : assessment.status.name.replaceFirst(
                          assessment.status.name[0],
                          assessment.status.name[0].toUpperCase()),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(assessment.status),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(AssessmentStatus status) {
    switch (status) {
      case AssessmentStatus.notStarted:
        return Colors.grey;
      case AssessmentStatus.introduced:
        return Colors.blue;
      case AssessmentStatus.practicing:
        return Colors.yellow[700]!;
      case AssessmentStatus.completed:
        return Colors.green;
    }
  }
}

class TrianglePainter extends CustomPainter {
  final AssessmentStatus status;

  TrianglePainter({required this.status});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw equilateral triangle
    for (int i = 0; i < 3; i++) {
      final angle = (i * 120 - 90) * (3.14159 / 180);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Background triangle
    paint.color = Colors.grey[200]!;
    canvas.drawPath(path, paint);

    // Draw sides based on status
    final sidePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final sidesToColor = _getSidesToColor();
    for (int i = 0; i < 3; i++) {
      final startAngle = (i * 120 - 90) * (3.14159 / 180);
      final endAngle = ((i + 1) * 120 - 90) * (3.14159 / 180);
      final startX = center.dx + radius * cos(startAngle);
      final startY = center.dy + radius * sin(startAngle);
      final endX = center.dx + radius * cos(endAngle);
      final endY = center.dy + radius * sin(endAngle);

      sidePaint.color =
          i < sidesToColor ? _getStatusColor(status) : Colors.grey;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), sidePaint);
    }
  }

  int _getSidesToColor() {
    switch (status) {
      case AssessmentStatus.notStarted:
        return 0;
      case AssessmentStatus.introduced:
        return 1;
      case AssessmentStatus.practicing:
        return 2;
      case AssessmentStatus.completed:
        return 3;
    }
  }

  Color _getStatusColor(AssessmentStatus status) {
    switch (status) {
      case AssessmentStatus.notStarted:
        return Colors.grey;
      case AssessmentStatus.introduced:
        return Colors.blue;
      case AssessmentStatus.practicing:
        return Colors.yellow[700]!;
      case AssessmentStatus.completed:
        return Colors.green;
    }
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) =>
      oldDelegate.status != status;
}
