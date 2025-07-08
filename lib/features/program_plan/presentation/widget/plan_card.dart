import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';
import 'package:mydiaree/core/widgets/custom_action_button.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_card.dart';

class PlanCard extends StatelessWidget {
  final String month;
  final String year;
  final String roomName;
  final String creatorName;  
  final String createdAt;
  final String updatedAt;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const PlanCard({
    super.key,
    required this.month,
    required this.year,
    required this.roomName,
    required this.creatorName,  
    required this.createdAt,
    required this.updatedAt,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PatternBackground(
      elevation: 1.5,
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.2),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4), // down shadow
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.greyShade : AppColors.greyShadeLight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Expanded(
                  //   child: Text(
                  //     "${getMonthName(month)} $year",
                  //     style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  //           color: AppColors.primaryColor,
                  //         ),
                  //   ),
                  // ),
                  CustomButton(
                      height: 30,
                      width: 150,
                      text: '${getMonthName(month)} $year'),
                  const Expanded(
                      child: SizedBox(
                    width: 10,
                  )),
                  Row(
                    children: [
                      CustomActionButton(
                        icon: Icons.edit_rounded,
                        color: AppColors.primaryColor,
                        onPressed: onEditPressed,
                      ),
                      const SizedBox(width: 8),
                      CustomActionButton(
                        icon: Icons.delete,
                        color: AppColors.errorColor,
                        onPressed: onDeletePressed,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              _InfoText(icon: Icons.meeting_room, label: roomName,style:  Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryColor),),
              _InfoText(icon: Icons.person, label: "Created by : $creatorName"), 
              const Divider(height: 20),
              Column(
                children: [
                  _DateLabel("Created", createdAt),
                  const SizedBox(height: 12),
                  _DateLabel("Updated", updatedAt),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _DateLabel(String label, String? dateStr) {
  try {
    final date = DateTime.parse(dateStr ?? '');
    final formatted = "${date.day}/${date.month}/${date.year}";
    return PatternBackground(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      borderRadius: BorderRadius.circular(10), 
      child: Text("$label: $formatted", style: const TextStyle(fontSize: 12)),
    );
  } catch (_) {
    return Text("$label: -");
  }
}

class _InfoText extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextStyle? style;

  const _InfoText({required this.icon, required this.label, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style:style?? Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
