import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
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
  final GlobalRepository _globalRepo = GlobalRepository();
  List<Datum> _centers = [];
  // bool _loadingCenters = true;
  // start uninitialized; we’ll assign after fetching centers
  String? selectedCenterId;

  @override
  void initState() {
    selectedCenterId = globalSelectedCenterId;
    super.initState();
    _loadCenters();
  }

  Future<void> _loadCenters() async {
    context.read<SnapshotBloc>().add(LoadSnapshotsEvent(selectedCenterId!));
  }

  @override
  Widget build(BuildContext context) {
    final bool isParent = UserTypeHelper.isParent;
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Snapshots'),
      body: Column(
        children: [
          if (!isParent)
            Padding(
              padding: const EdgeInsets.only(right: 15, top: 15, bottom: 15),
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
          // if (_loadingCenters)
          //   const Center(child: CircularProgressIndicator())
          // else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CenterDropdown(
                selectedCenterId: selectedCenterId,
                onChanged: (center) {
                  setState(() {
                    selectedCenterId = center.id.toString();
                  });
                  context
                      .read<SnapshotBloc>()
                      .add(LoadSnapshotsEvent(selectedCenterId!));
                },
              ),
            ),
          UIHelpers.verticalSpace(10),
          Expanded(
            child: BlocBuilder<SnapshotBloc, SnapshotState>(
              builder: (context, state) {
                if (state is SnapshotLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SnapshotLoaded) {
                  if (state.snapshots.isEmpty) {
                    return const Center(
                      child: Text('No snapshots for this center'),
                    );
                  }
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
                          images: snapshot.media.map((m) => m.mediaUrl).toList(),
                          details: snapshot.about,
                          children: snapshot.children
                              .map((c) => PersonItemData(
                                    name: c.child.name,
                                    imageUrl: c.child.imageUrl,
                                  ))
                              .toList(),
                          rooms: snapshot.rooms.map((room) => room.name).toList(),
                          permissionUpdate: !isParent,
                          permissionDelete: !isParent,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSnapshotScreen(
                                  centerId: selectedCenterId ?? '',
                                  snapshotModel: snapshot,
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
                                      context.read<SnapshotBloc>().add(
                                          DeleteSnapshotEvent(snapshot.id));
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
                }
                if (state is SnapshotError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('No snapshots available'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
