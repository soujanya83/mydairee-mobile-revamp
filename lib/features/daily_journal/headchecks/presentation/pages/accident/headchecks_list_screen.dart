import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/repositories/headchecks_repo.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/bloc/accident_list/heachckecks_list_state.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/bloc/accident_list/headchecks_list_bloc.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/bloc/accident_list/headchecks_list_event.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/widget/headchecks_custom_widgets.dart';
import 'package:mydiaree/main.dart';

class HeadChecksScreen extends StatefulWidget {
  const HeadChecksScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HeadChecksScreenState createState() => _HeadChecksScreenState();
}

class _HeadChecksScreenState extends State<HeadChecksScreen> {
  String? selectedCenterId;
  String? selectedRoomId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HeadChecksBloc()..add(LoadHeadChecksInitial(userId: '')),
      child: CustomScaffold(
        appBar: const CustomAppBar(title: 'Head Checks'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                StatefulBuilder(builder: (context, setState) {
                  return CenterDropdown(
                    selectedCenterId: selectedCenterId,
                    onChanged: (value) {
                      setState(() {
                        selectedCenterId = value.id;
                        selectedRoomId = null; // Reset room selection
                      });
                    },
                  );
                }),
                const SizedBox(height: 6),
                StatefulBuilder(builder: (context, setState) {
                  return RoomDropdown(
                    selectedRoomId: selectedRoomId,
                    onChanged: (room) {
                      setState(() {
                        selectedRoomId = room.id;
                      });
                    },
                  );
                }),
                const SizedBox(height: 10),
                BlocBuilder<HeadChecksBloc, HeadChecksState>(
                  builder: (context, state) {
                    if (state is HeadChecksLoading) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state is HeadChecksLoaded) {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.headChecks.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeadCheckCard(
                                  index: index,
                                  hour: state.headChecks[index].hour,
                                  minute: state.headChecks[index].minute,
                                  headCountController: state
                                      .headChecks[index].headCountController,
                                  signatureController: state
                                      .headChecks[index].signatureController,
                                  commentsController: state
                                      .headChecks[index].commentsController,
                                  onAdd: () {
                                    context
                                        .read<HeadChecksBloc>()
                                        .add(AddHeadCheckEvent());
                                  },
                                  onRemove: index == 0
                                      ? null
                                      : () {
                                          context
                                              .read<HeadChecksBloc>()
                                              .add(RemoveHeadCheckEvent(index));
                                        },
                                  onHourChanged: (value) {
                                    if (value != null) {
                                      context.read<HeadChecksBloc>().add(
                                            UpdateHeadCheckEvent(
                                              index: index,
                                              hour: value,
                                              minute: state
                                                  .headChecks[index].minute,
                                            ),
                                          );
                                    }
                                  },
                                  onMinuteChanged: (value) {
                                    if (value != null) {
                                      context.read<HeadChecksBloc>().add(
                                            UpdateHeadCheckEvent(
                                              index: index,
                                              hour:
                                                  state.headChecks[index].hour,
                                              minute: value,
                                            ),
                                          );
                                    }
                                  },
                                  onSave: () {
                                    
                                  },
                                  onCancel: () {
                                    
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildActionButtons(context, state),
                        ],
                      );
                    }
                    if (state is HeadChecksError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<HeadChecksBloc, HeadChecksState>(
      builder: (context, state) {
        DateTime? date =
            state is HeadChecksLoaded ? state.date : DateTime.now();
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Text(
                'Head Checks',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, HeadChecksState state) {
    if (state is! HeadChecksLoaded) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ActionButton(
          label: 'CANCEL',
          onPressed: () => Navigator.pop(context),
          isPrimary: false,
        ),
        const SizedBox(width: 15),
        ActionButton(
          label: 'SAVE',
          onPressed: () {
            context.read<HeadChecksBloc>().add(SaveHeadChecksEvent(
                  userId: '',
                  roomId: selectedRoomId ?? '',
                  date: state.date,
                  headChecks: state.headChecks,
                ));
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
