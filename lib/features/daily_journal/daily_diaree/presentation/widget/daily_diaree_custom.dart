import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';

class ChildCard extends StatelessWidget {
  final ChildModel child;

  const ChildCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(60),
                    child: CustomNetworkImage(
                      imageUrl: child.avatarPath,
                      errorWidget: Container(
                        height: 50,
                        width: 50,
                        color: AppColors.greyShade,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.cakeCandles, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Age: ${child.age} years',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.clock, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Today: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, '9', 'Activities'),
                _buildStatItem(context, '3', 'Meals'),
                _buildStatItem(context, '2', 'Naps'),
              ],
            ),
            const SizedBox(height: 12),
            // Activities
            Expanded(
              child: ListView(
                children: child.activities.map((activity) {
                  return _buildActivitySection(context, activity);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildActivitySection(BuildContext context, ActivityModel activity) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: AppColors.primaryColor),
      child: ExpansionTile(
        leading: FaIcon(
          _getActivityIcon(activity.type),
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        title: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                activity.type.replaceAll('-', ' ').capitalize(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                  color: _getStatusColor(activity.status ?? ''),
                  borderRadius: BorderRadius.circular(3)),
              child: SizedBox(
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 7, right: 7),
                  child: Text(
                    activity.status ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.greyShadeLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      _getStatusColor(activity.status ?? ''),
                      Colors.transparent,
                    ],
                    stops: const [0.02, 0.02],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (activity.time != null)
                        _buildActivityItem(context, 'Time', activity.time!),
                      if (activity.sleepTime != null)
                        _buildActivityItem(
                            context, 'Sleep Time', activity.sleepTime!),
                      if (activity.wakeTime != null)
                        _buildActivityItem(
                            context, 'Wake Time', activity.wakeTime!),
                      if (activity.item != null)
                        _buildActivityItem(context, 'Item', activity.item!),
                      if (activity.status != null &&
                          activity.type == 'toileting')
                        _buildActivityItem(context, 'Status', activity.status!,
                            isBadge: true),
                      _buildActivityItem(
                          context, 'Comments', activity.comments),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String label, String value,
      {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          isBadge
              ? Chip(
                  label: Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(value),
                )
              : Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'breakfast':
        return FontAwesomeIcons.mugSaucer;
      case 'morning-tea':
        return FontAwesomeIcons.mugHot;
      case 'lunch':
        return FontAwesomeIcons.utensils;
      case 'sleep':
        return FontAwesomeIcons.bed;
      case 'afternoon-tea':
        return FontAwesomeIcons.cookie;
      case 'snacks':
        return FontAwesomeIcons.appleWhole;
      case 'sunscreen':
        return FontAwesomeIcons.sun;
      case 'toileting':
        return FontAwesomeIcons.baby;
      case 'bottle':
        return FontAwesomeIcons.bottleWater;
      default:
        return FontAwesomeIcons.question;
    }
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    return SizedBox(
      height: 30,
      width: 50,
      child: Chip(
        label: Text(
          status,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: _getStatusColor(status),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Not Update':
        return Colors.blueAccent; // Info color
      case 'In Progress':
        return Colors.orange; // Warning color
      case '0 Entries':
      case '0 Applications':
        return Colors.red; // Danger color
      case 'Pending':
        return Colors.grey; // Secondary color
      default:
        return Colors.grey; // Fallback
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}
