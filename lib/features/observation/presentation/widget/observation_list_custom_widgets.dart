import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';
import 'package:mydiaree/core/utils/hexconversion.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';

class ObservationModel {
  final String id;
  final String title;
  final String userName;
  final String dateAdded;
  final String? observationsMedia;
  final int? montessoricount;
  final int? eylfcount;
  final String status;

  ObservationModel({
    required this.id,
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
      id: json['id'],
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

class ObservationCard extends StatelessWidget {
  final String title;
  final String author;
  final String approvedBy;
  final String dateAdded;
  final String? mediaUrl;
  final int? montessoriCount;
  final int? eylfCount;
  final String status;
  final VoidCallback onTap;

  const ObservationCard({
    required this.title,
    required this.author,
    required this.approvedBy,
    required this.dateAdded,
    this.mediaUrl,
    this.montessoriCount,
    this.eylfCount,
    required this.status,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                      child: _infoRow("Author:", author),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: _infoRow("Approved by:", approvedBy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              // Date row
              _infoRow("Created on:", formattedDate(dateAdded)),
              const SizedBox(height: 12),
              // Media
              if (mediaUrl != null && mediaUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(.1),
                    ),
                    child: CustomNetworkImage(
                      placeholder: SizedBox(),
                      errorWidget: SizedBox(),
                      fullUrl: mediaUrl!,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              // Chips row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (montessoriCount != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildChip(
                          "Montessori: $montessoriCount",
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    if (eylfCount != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildChip(
                          "EYLF: $eylfCount",
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    _buildStatusChip(status),
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

class SmallObservationCard extends StatelessWidget {
  final String id;
  final String title;
  final String userName;
  final String? observationsMedia;
  final bool isSelected;
  final bool isLinked;
  final VoidCallback onTap;

  const SmallObservationCard({
    super.key,
    required this.id,
    required this.title,
    required this.userName,
    this.observationsMedia,
    this.isSelected = false,
    this.isLinked = false,
    required this.onTap,
  });

  String get fullImageUrl =>
      (observationsMedia != null && observationsMedia!.isNotEmpty)
          ? (observationsMedia!.startsWith('http')
              ? observationsMedia!
              : 'https://mydiaree.com.au$observationsMedia')
          : '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PatternBackground(
        elevation: 2,
        border: isSelected
            ? Border.all(
                color: AppColors.primaryColor,
                width: 1,
              )
            : null,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.1,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: (fullImageUrl.isNotEmpty)
                    ? Image.network(
                        fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'By: $userName',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // if (!isLinked)
                  Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.all(
                          AppColors.primaryColor,
                        ),
                        value: isSelected,
                        onChanged: (_) => onTap(),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const Text('Select', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
