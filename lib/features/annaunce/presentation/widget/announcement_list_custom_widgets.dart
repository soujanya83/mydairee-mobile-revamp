import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String text;
  final String date;
  final String createdBy;
  final bool isSelected;
  final Function(bool) onSelectionChanged;
  final VoidCallback onEditPressed;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.text,
    required this.date,
    required this.createdBy, 
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: PatternBackground(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(12),
              // color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: onEditPressed,
                      ),
                      Checkbox(
                        value: isSelected,
                        fillColor:
                            WidgetStateProperty.all(AppColors.primaryColor),
                        onChanged: (val) =>
                            onSelectionChanged(val ?? false),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Announcement text
                  Text(
                    text,
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 10),

                  // Event date & status
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        date,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                    
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Created By
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Created by: $createdBy',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
