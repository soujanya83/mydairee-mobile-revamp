import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';
import 'package:mydiaree/core/utils/hexconversion.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
class ObservationModel {
  final String title;
  final String userName;
  final String dateAdded;
  final String? observationsMedia;
  final int? montessoricount;
  final int? eylfcount;
  final String status;

  ObservationModel({
    required this.title,
    required this.userName,
    required this.dateAdded,
    this.observationsMedia,
    this.montessoricount,
    this.eylfcount,
    required this.status,
  });

  factory ObservationModel.fromJson(Map<String, dynamic> json) {
    return ObservationModel(
      title: json['title'],
      userName: json['userName'],
      dateAdded: json['dateAdded'],
      observationsMedia: json['observationsMedia'],
      montessoricount: json['montessoricount'],
      eylfcount: json['eylfcount'],
      status: json['status'],
    );
  }
}

// Your exact ObservationCard widget
class ObservationCard extends StatelessWidget {
  final dynamic observation;
  final VoidCallback onTap;

  const ObservationCard({
    required this.observation,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: PatternBackground(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Prevent vertical overflow
            children: [
              if (observation.title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    observation.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                    maxLines: 2, // Limit title to 2 lines
                    overflow: TextOverflow.ellipsis, // Add ellipsis if overflow
                  ),
                ),

              // Author and Approver row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: _infoRow("Author:", observation.userName),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: _infoRow("Approved by:", observation.userName),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Date row
              _infoRow("Created on:", formattedDate(observation.dateAdded)),
              const SizedBox(height: 12),

              // Media
              if ((observation.observationsMedia) != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      //     gradient: LinearGradient(colors: [
                      //   AppColors.black.withOpacity(.2),
                      //   AppColors.transparent
                      // ]
                      // )
                      color: AppColors.black.withOpacity(.1),
                    ),
                    child: CustomNetworkImage(
                      placeholder: SizedBox(),
                      errorWidget: SizedBox(),
                      imageUrl: observation.observationsMedia!.toString(),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // Chips row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (observation.montessoricount != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildChip(
                          "Montessori: ${observation.montessoricount}",
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    if (observation.eylfcount != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildChip(
                          "EYLF: ${observation.eylfcount}",
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    _buildStatusChip(observation.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    final isPublished = status == 'Published';
    final chipColor = isPublished ? Colors.green : const Color(0xffFFEFB8);
    final textColor = isPublished ? Colors.white : const Color(0xffCC9D00);
    final icon = isPublished ? Icons.check_circle : Icons.drafts;

    return Container(
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status ?? '',
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
