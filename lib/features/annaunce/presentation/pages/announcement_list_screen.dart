import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_list_model.dart' hide Center;
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_anounce_bloc.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_room_event.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_room_state.dart';
import 'package:mydiaree/features/annaunce/presentation/pages/add_announcement_screen.dart';
import 'package:mydiaree/features/annaunce/presentation/pages/view_announcement_screen.dart';
import 'package:mydiaree/features/room/presentation/widget/room_list_custom_widgets.dart';
import 'package:mydiaree/main.dart';

class AnnouncementsListScreen extends StatefulWidget {
  const AnnouncementsListScreen({super.key});

  @override
  State<AnnouncementsListScreen> createState() => _AnnouncementsListScreenState();
}

class _AnnouncementsListScreenState extends State<AnnouncementsListScreen> {
  final TextEditingController searchController = TextEditingController();
  String? selectedCenterId;
  List<String> selectedAnnouncementIds = [];
  String userId = '1'; // Replace with actual user ID from auth

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedCenterId = '1'; // Default center ID
      _loadAnnouncements();
    });
  }

  void _loadAnnouncements() {
    if (selectedCenterId != null) {
      context.read<AnnounceListBloc>().add(
        FetchAnnounceEvent(
          centerId: selectedCenterId!,
          searchQuery: searchController.text.isEmpty ? null : searchController.text,
        ),
      );
    }
  }

  void _onCenterChanged(Datum center) {
    setState(() {
      selectedCenterId = center.id.toString();
      selectedAnnouncementIds.clear();
    });
    _loadAnnouncements();
  }

  void _onSearchChanged(String value) {
    _loadAnnouncements();
  }

  void showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete the selected announcement(s)?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text("DELETE"),
          ),
        ],
      ),
    );
  }

  String _getRelativeTime(String eventDate) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(eventDate);
      final now = DateTime.now();
      final difference = now.difference(date);
      if (difference.isNegative) {
        final days = (-difference.inDays);
        if (days == 0) {
          return 'Today';
        }
        if (days < 30) {
          return '$days days ago';
        }
        final months = (days / 30).ceil();
        return '$months months from now';
      } else {
        final days = difference.inDays;
        if (days < 30) {
          return '$days days ago';
        }
        final months = (days / 30).floor();
        return '$months months ago';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: "Announcements",
        actions: [
          if (selectedAnnouncementIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDeleteConfirmationDialog(context, () {
                  context.read<AnnounceListBloc>().add(
                    DeleteSelectedAnnounceEvent(
                      announcement: selectedAnnouncementIds,
                      centerId: selectedCenterId ?? '1',
                      userId: userId,
                    ),
                  );
                });
              },
            ),
        ],
      ),
      body: BlocConsumer<AnnounceListBloc, AnnounceListState>(
        listener: (context, state) {
          if (state is AnnouncementDeletedState) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.successColor,
            );
            selectedAnnouncementIds.clear();
          } else if (state is AnnounceListError) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.errorColor,
            );
          }
        },
        builder: (context, state) {
          if (state is AnnounceListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnnounceListError) {
            return Center(child: Text(state.message));
          } else if (state is AnnounceListLoaded) {
            final announcements = state.announcementData.data?.records ?? [];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header and filters
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Announcements',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontSize: 20),
                            ),
                            const Spacer(),
                            CustomButton(
                              text: 'Add',
                              height: 36,
                              width: 80,
                              borderRadius: 8,
                              textAppTextStyles:
                                  Theme.of(context).textTheme.labelMedium,
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddAnnouncementScreen(
                                      screenType: 'add',
                                      centerId: selectedCenterId ?? '1',
                                    ),
                                  ),
                                ).then((_) => _loadAnnouncements());
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CenterDropdown(
                          selectedCenterId: selectedCenterId,
                          onChanged: _onCenterChanged,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormWidget(
                          prefixWidget: const Icon(Icons.search, size: 20),
                          height: 40,
                          contentpadding:
                              const EdgeInsets.only(top: 2, left: 12),
                          hintText: 'Search announcement...',
                          controller: searchController,
                          onChanged: (value){
                            _onSearchChanged(searchController.text);
                          },
                        ),
                        const SizedBox(height: 12),
                        // Stats row
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Total Announcements: ${announcements.length}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              if (selectedAnnouncementIds.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Text(
                                  'Selected: ${selectedAnnouncementIds.length}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Announcement Cards
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final announcement = announcements[index];
                      final isSelected =
                          selectedAnnouncementIds.contains(announcement.id.toString());
                      return _buildAnnouncementCard(
                        context, announcement, index, isSelected);
                    },
                  ),
                  
                  // // Delete button at the bottom
                  // if (selectedAnnouncementIds.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: AppColors.errorColor,
                  //         foregroundColor: Colors.white,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 20, vertical: 12),
                  //         minimumSize: const Size(double.infinity, 44),
                  //       ),
                  //       onPressed: () {
                  //         showDeleteConfirmationDialog(context, () {
                  //           context.read<AnnounceListBloc>().add(
                  //                 DeleteSelectedAnnounceEvent(
                  //                   announcement: selectedAnnouncementIds,
                  //                   centerId: selectedCenterId ?? '1',
                  //                   userId: userId,
                  //                 ),
                  //               );
                  //         });
                  //       },
                  //       child: const Text(
                  //         'Delete Selected',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.w600, fontSize: 14),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select a center to view announcements'),
                const SizedBox(height: 20),
                CenterDropdown(
                  selectedCenterId: selectedCenterId,
                  onChanged: _onCenterChanged,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context,
    Record announcement,
    int index,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: PatternBackground(
        elevation: isSelected ? 4 : 1,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // S.no and Title
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
                  Expanded(
                    child: Text(
                      announcement.title ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: announcement.text?.isEmpty == true
                        ? Text(
                            'No content',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                          )
                        : Text(
                            announcement.text?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                  ),
                  const SizedBox(width: 8),
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check,
                            size: 14, color: AppColors.successColor),
                        const SizedBox(width: 4),
                        Text(
                          announcement.status?.toString() ?? 'Sent',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.successColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (announcement.createdBy?.toString() ?? '')[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            announcement.createdBy?.toString() ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        announcement.eventDate ?? '',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        _getRelativeTime(announcement.eventDate ?? ''),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomActionButton(
                    icon: Icons.visibility,
                    color: AppColors.successColor,
                    tooltip: 'View',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAnnouncementScreen(
                            announcementId: announcement.id.toString(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  CustomActionButton(
                    icon: Icons.edit,
                    color: AppColors.primaryColor,
                    tooltip: 'Edit',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAnnouncementScreen(
                            screenType: 'edit',
                            centerId: selectedCenterId ?? '1',
                            announcementId: announcement.id.toString(),
                          ),
                        ),
                      ).then((_) => _loadAnnouncements());
                    },
                  ),
                  const SizedBox(width: 8),
                  CustomActionButton(
                    icon: Icons.delete,
                    color: AppColors.errorColor,
                    tooltip: 'Delete',
                    onPressed: () {
                      showDeleteConfirmationDialog(context, () {
                        context.read<AnnounceListBloc>().add(
                              DeleteSelectedAnnounceEvent(
                                announcement: [announcement.id.toString()],
                                centerId: selectedCenterId ?? '1',
                                userId: userId,
                              ),
                            );
                      });
                    },
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

// Placeholder for CustomActionButton
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
