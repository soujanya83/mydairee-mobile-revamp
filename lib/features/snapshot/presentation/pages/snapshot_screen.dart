import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/snapshot/data/model/snapshot_model.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_bloc.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_events.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_state.dart';
import 'package:mydiaree/features/snapshot/presentation/pages/add_snapshot_screen.dart';
import 'package:mydiaree/features/snapshot/presentation/widget/snapshot_custom.dart';
import 'package:mydiaree/main.dart';

class SnapshotScreen extends StatefulWidget {
  const SnapshotScreen({super.key});

  @override
  _SnapshotScreenState createState() => _SnapshotScreenState();
}

class _SnapshotScreenState extends State<SnapshotScreen> {
  String? selectedCenterId;

  @override
  void initState() {
    super.initState();
    context
        .read<SnapshotBloc>()
        .add(const LoadSnapshotsEvent('1')); // Default: Melbourne Center
  }

  @override
  Widget build(BuildContext context) {
    final bool isParent = UserTypeHelper.isParent;
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Snapshots',
      ),
      body: BlocListener<SnapshotBloc, SnapshotState>(
        listener: (context, state) {
          if (state is SnapshotError) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.errorColor,
            );
          } else if (state is SnapshotLoaded) {
            UIHelpers.showToast(
              context,
              message: 'Snapshots loaded successfully',
              backgroundColor: AppColors.successColor,
            );
          }
        },
        child: Column(
          children: [
            if (!isParent)
              Padding(
                padding:
                    const EdgeInsets.only(right: 15, top: 15, bottom: 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: UIHelpers.addButton(
                    context: context,
                    ontap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddSnapshotScreen(
                          centerId: selectedCenterId ?? '',
                          screenType: 'add',
                        );
                      }));
                    },
                  ),
                ),
              ),
            const SizedBox(width: 8),
            StatefulBuilder(builder: (context, setState) {
              return CenterDropdown(
                selectedCenterId: selectedCenterId,
                onChanged: (value) {
                  setState(
                    () {
                      selectedCenterId = value.id;
                    },
                  );
                },
              );
            }),
            UIHelpers.verticalSpace(10),
            Expanded(
              child: BlocBuilder<SnapshotBloc, SnapshotState>(
                builder: (context, state) {
                  if (state is SnapshotLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SnapshotLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.snapshots.length,
                      itemBuilder: (context, index) {
                        final snapshot = state.snapshots[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: SnapshotCard(
                            id: snapshot.id,
                            title: snapshot.title,
                            status: snapshot.status,
                            images: snapshot.images.isNotEmpty
                                ? snapshot.images
                                : ['https://mydiaree.com.au/.../placeholder.png'],
                            details: snapshot.details,
                            children: snapshot.children,
                            rooms: snapshot.rooms,
                            permissionUpdate: !isParent,
                            permissionDelete: !isParent,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddSnapshotScreen(
                                    centerId: selectedCenterId ?? '',
                                    snapshot: {
                                      'id': snapshot.id.toString(),
                                      'title': snapshot.title,
                                      'about': snapshot.details,
                                      // 'room_id': snapshot.rooms.first.id.toString(),
                                      // 'children': snapshot.children
                                      //     .map((c) => {'id': c.id.toString(), 'name': c.name})
                                      //     .toList(),
                                      'images': snapshot.images,
                                    },
                                    screenType: 'edit',
                                    id: snapshot.id.toString(),
                                  ),
                                ),
                              );
                            },
                            onDelete: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content: const Text(
                                      'This will permanently delete the snapshot.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<SnapshotBloc>()
                                            .add(DeleteSnapshotEvent(snapshot.id));
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is SnapshotError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('No snapshots available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
