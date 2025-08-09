import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/features/observation/presentation/pages/view_observation_screen.dart';
import 'package:mydiaree/main.dart';

class ChildCard extends StatelessWidget {
  final String childName;
  final int age;
  final String dob;
  final String imageUrl;

  const ChildCard({
    required this.childName,
    required this.age,
    required this.dob,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return PatternBackground(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.account_circle,
                      size: 48,
                      color: AppColors.primaryColor,
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 48,
                    color: AppColors.primaryColor,
                  ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                childName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Age: $age Years',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              Text(
                'DOB: $dob',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
