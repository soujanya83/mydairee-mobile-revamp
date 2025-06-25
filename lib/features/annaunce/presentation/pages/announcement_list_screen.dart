import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_anounce_bloc.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_room_event.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_room_state.dart';
import 'package:mydiaree/features/annaunce/presentation/pages/add_announcement_screen.dart';
import 'package:mydiaree/features/annaunce/presentation/widget/announcement_list_custom_widgets.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_state.dart'
    hide AnnounceListError;
import 'package:mydiaree/features/room/presentation/pages/add_room_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<AnnounceListBloc>()
          .add(const FetchAnnounceEvent(centerId: '1'));
    });

    return CustomScaffold(
      appBar: const CustomAppBar(title: "Announcements"),
      body: BlocConsumer<AnnounceListBloc, AnnounceListState>(
        listener: (context, state) {
          if (state is AnnouncementDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Announcements deleted successfully")),
            );
          } else if (state is AnnounceListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
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
                  Row(
                    children: [
                      Text('Announcements',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const Spacer(),
                      UIHelpers.addButton(
                        context: context,
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
                  const SizedBox(height: 10),
                  // Center Dropdown
                  StatefulBuilder(builder: (context, setState) {
                    return CenterDropdown(
                      selectedCenterId: selectedCenterId,
                      onChanged: (value) {
                        setState(() {
                          selectedCenterId = value.id;
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 10),

                  // Search Field
                  CustomTextFormWidget(
                    prefixWidget: const Icon(Icons.search),
                    height: 40,
                    contentpadding: EdgeInsets.only(top: 2),
                    hintText: 'Search announcement...',
                    controller: searchController,
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 10),

                  const SizedBox(height: 10),

                  // List of Announcements
                  StatefulBuilder(builder: (context, setState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = announcements[index];
                        final isSelected =
                            selectedAnnouncementIds.contains(announcement.id);

                        return AnnouncementCard(
                          isSelected: isSelected,
                          onSelectionChanged: (selected) {
                            if (selected) {
                              selectedAnnouncementIds.add(announcement.id);
                            } else {
                              selectedAnnouncementIds.remove(announcement.id);
                            }
                            setState(() {});
                          },
                          onEditPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => AddAnnouncementScreen(
                            //       screenType: 'edit',
                            //       centerId: selectedCenterId ?? '',
                            //       announcement: announcement,
                            //     ),
                            //   ),
                            // );
                          },
                          title: announcement.title,
                          text: announcement.text,
                          date: announcement.eventDate,
                          createdBy: announcement.createdBy,
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 20),

                  // Delete Button
                  if (selectedAnnouncementIds.isNotEmpty)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
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
                      child: const Text('Delete Selected'),
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
}
