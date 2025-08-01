import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_list_model.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_anounce_bloc.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_room_event.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_room_state.dart';
import 'package:mydiaree/features/annaunce/presentation/pages/add_announcement_screen.dart';
import 'package:mydiaree/features/room/presentation/widget/room_list_custom_widgets.dart';
import 'package:mydiaree/main.dart';

// ignore: must_be_immutable
class AnnouncementsListScreen extends StatelessWidget {
  AnnouncementsListScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  String? selectedCenterId;
  List<String> selectedAnnouncementIds = [];

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context
    //       .read<AnnounceListBloc>()
    //       .add(const FetchAnnounceEvent(centerId: '1'));
    // });

    return CustomScaffold(
      appBar: CustomAppBar(
        title: "Announcements",
      
      ),
      body: BlocConsumer<AnnounceListBloc, AnnounceListState>(
        listener: (context, state) {
          if (state is AnnouncementDeletedState) {
            UIHelpers.showToast(
              context,
              message: "Announcements deleted successfully",
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
            final announcements = state.announcementData.announcements;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 16, vertical: 12),
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [
                  //         AppColors.primaryColor,
                  //         AppColors.primaryColor.withOpacity(0.8),
                  //       ],
                  //       begin: Alignment.topLeft,
                  //       end: Alignment.bottomRight,
                  //     ),
                  //     borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(12),
                  //       topRight: Radius.circular(12),
                  //     ),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           const Icon(Icons.campaign,
                  //               color: Colors.white, size: 20),
                  //           const SizedBox(width: 8),
                  //           Text(
                  //             'Announcements',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .headlineSmall
                  //                 ?.copyWith(
                  //                   color: Colors.white,
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //           ),
                  //         ],
                  //       ),
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 12, vertical: 6),
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         child: Text(
                  //           '${announcements.length} Total',
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .bodySmall
                  //               ?.copyWith(
                  //                 color: AppColors.primaryColor,
                  //                 fontWeight: FontWeight.w600,
                  //                 fontSize: 12,
                  //               ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Filters
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
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        StatefulBuilder(builder: (context, setState) {
                          return CenterDropdown(
                            selectedCenterId: selectedCenterId,
                            onChanged: (value) {
                              setState(() {
                                selectedCenterId = value.id;
                                context.read<AnnounceListBloc>().add(
                                    FetchAnnounceEvent(centerId: value.id));
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 12),
                        CustomTextFormWidget(
                          prefixWidget: const Icon(Icons.search, size: 20),
                          height: 40,
                          contentpadding:
                              const EdgeInsets.only(top: 2, left: 12),
                          hintText: 'Search announcement...',
                          controller: searchController,
                          onChanged: (value) {
                            // Implement search filtering if needed
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  // Announcement Cards
                  StatefulBuilder(builder: (context, setState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = announcements[index];
                        final isSelected =
                            selectedAnnouncementIds.contains(announcement.id);
                        return _buildAnnouncementCard(
                            context, announcement, index, isSelected, setState);
                      },
                    );
                  }),
                  // Delete Button
                  if (selectedAnnouncementIds.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          minimumSize: const Size(double.infinity, 44),
                        ),
                        onPressed: () {
                          showDeleteConfirmationDialog(context, () {
                            context.read<AnnounceListBloc>().add(
                                  DeleteSelectedAnnounceEvent(
                                    selectedAnnouncementIds,
                                    selectedCenterId ?? '1',
                                  ),
                                );
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          'Delete Selected',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context,
    AnnouncementModel announcement,
    int index,
    bool isSelected,
    StateSetter setState,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: PatternBackground(
        elevation: isSelected ? 4 : 1,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedAnnouncementIds.remove(announcement.id);
              } else {
                selectedAnnouncementIds.add(announcement.id);
              }
            });
          },
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
                        announcement.title,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: announcement.text.isEmpty
                          ? Row(
                              children: [
                                Icon(Icons.image,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  'No media',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            )
                          :   CustomNetworkImage(
                             
                             placeholder: Row(
                              children: [
                                Icon(Icons.image,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  'No media',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                            errorWidget: Row(
                              children: [
                                Icon(Icons.image,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  'No media',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                            height: 60,width: screenWidth*.3
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
                            'Sent',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.successColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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
                                announcement.createdBy.isNotEmpty
                                    ? announcement.createdBy[0]
                                    : 'D',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              announcement.createdBy,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 12),
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
                          announcement.eventDate,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          _getRelativeTime(announcement.eventDate),
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
                        UIHelpers.showToast(
                          context,
                          message: 'View announcement ${announcement.id}',
                          backgroundColor: AppColors.successColor,
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
                              announcement: {},
                            ),
                          ),
                        );
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
                                  [announcement.id],
                                  selectedCenterId ?? '1',
                                ),
                              );
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRelativeTime(String eventDate) {
    try {
      final date = DateFormat('dd MMM yyyy').parse(eventDate);
      final now = DateTime.now();
      final difference = now.difference(date);
      if (difference.isNegative) {
        final months = (-difference.inDays / 30).ceil();
        return '$months months from now';
      } else {
        final months = (difference.inDays / 30).floor();
        return '$months months ago';
      }
    } catch (e) {
      return '';
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.9,
            maxHeight: screenHeight * 0.4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'Logout warning icon',
                child: Icon(
                  Icons.warning_rounded,
                  size: 32,
                  color: AppColors.errorColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                label: 'Confirm Sign Out',
                child: Text(
                  'Confirm Sign Out',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        letterSpacing: 0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Semantics(
                label: 'Are you sure you want to sign out of your account?',
                child: Text(
                  'Are you sure you want to sign out of your account?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Semantics(
                    label: 'Cancel sign out',
                    button: true,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: AppColors.primaryColor, width: 1),
                        ),
                        minimumSize: const Size(100, 40),
                      ),
                      child: Text(
                        'Cancel',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Confirm sign out',
                    button: true,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Perform logout (e.g., clear auth token, navigate to login screen)
                        // context.read<AuthBloc>().add(LogoutEvent());
                        // Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 2,
                        minimumSize: const Size(100, 40),
                      ),
                      child: Text(
                        'Sign Out',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                      ),
                    ),
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
