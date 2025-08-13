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
      appBar: const CustomAppBar(title: "View Progress"),
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
              padding: const EdgeInsets.all(16),
              itemCount: assessments.length,
              itemBuilder: (context, i) {
                final a = assessments[i];
                return AssessmentItemCard(
                  assessment: a,
                  onStatusTap: () {
                    final next = _getNextStatus(a.status);
                    context.read<ViewProgressBloc>().add(
                      UpdateAssessmentStatusEvent(
                        assessmentId: a.id,
                        childId: widget.childId,
                        newStatus: next,
                      ),
                    );
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
    const order = [
      AssessmentStatus.notStarted,
      AssessmentStatus.introduced,
      AssessmentStatus.practicing,
      AssessmentStatus.completed,
    ];
    final idx = order.indexOf(current);
    return order[(idx + 1) % order.length];
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
    final isClickable = assessment.status != AssessmentStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        // only hook up onTap when status != Completed
        onTap: isClickable ? onStatusTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Triangle indicator
              SizedBox(
                width: 30,
                height: 30,
                child: CustomPaint(
                  painter: TrianglePainter(status: assessment.status),
                ),
              ),
              const SizedBox(width: 12),
              // Titles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assessment.activityTitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assessment.subActivityTitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4
                    ),
                decoration: BoxDecoration(

                  border: Border.all(
                    width: 2,
                  color: _statusColor(assessment.status).withOpacity(.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  assessment.status == AssessmentStatus.notStarted
                      ? ''
                      : assessment.status
                          .name
                          .replaceFirst(
                              assessment.status.name[0],
                              assessment.status.name[0].toUpperCase()),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: _statusColor(assessment.status),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(AssessmentStatus s) {
    switch (s) {
      case AssessmentStatus.introduced:
        return Colors.blue;
      case AssessmentStatus.practicing:
      case AssessmentStatus.working:  // mapped same as practicing
        return Colors.orange;
      case AssessmentStatus.completed:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}


// Draws 0–3 colored sides based on status
class TrianglePainter extends CustomPainter {
  final AssessmentStatus status;
  TrianglePainter({required this.status});

  @override
  void paint(Canvas canvas, Size size) {
    final paintBg = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // build triangle path
    final path = Path();
    final cx = size.width / 2, cy = size.height / 2, r = size.width / 2;
    for (var i = 0; i < 3; i++) {
      final angle = (i * 120 - 90) * pi / 180;
      final x = cx + r * cos(angle), y = cy + r * sin(angle);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();

    // fill background
    paintBg.color = Colors.white.withOpacity(1);
    canvas.drawPath(path, paintBg);

    // how many sides to color?
    final colored = _sidesToColor(status);
    // Draw colored borders: bottom (0), left (1), right (2)
    // Triangle points: 0-bottom, 1-left, 2-right (clockwise)
    final points = List.generate(3, (i) {
      final angle = ((i + 1) * 120 - 90) * pi / 180;
      return Offset(cx + r * cos(angle), cy + r * sin(angle));
    });

    // Sides: [bottom, left, right]
    final sideOrder = [
      [points[0], points[1]], // bottom
      [points[1], points[2]], // left
      [points[2], points[0]], // right
    ];

    for (var i = 0; i < 3; i++) {
      stroke.color = (i < colored)
        ? _statusColor(status)
        : Colors.grey.withOpacity(.3)!;
      final p1 = sideOrder[i][0], p2 = sideOrder[i][1];
      canvas.drawLine(p1, p2, stroke);
    }
  }

  int _sidesToColor(AssessmentStatus s) {
    switch (s) {
      case AssessmentStatus.introduced:
        return 1;
      case AssessmentStatus.practicing:
      case AssessmentStatus.working:  // same as practicing
        return 2;
      case AssessmentStatus.completed:
        return 3;
      default:
        return 0;
    }
  }

  Color _statusColor(AssessmentStatus s) {
    switch (s) {
      case AssessmentStatus.introduced:
        return Colors.blue;
      case AssessmentStatus.practicing:
      case AssessmentStatus.working:
        return Colors.orange;
      case AssessmentStatus.completed:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  bool shouldRepaint(covariant TrianglePainter old) =>
      old.status != status;
}
