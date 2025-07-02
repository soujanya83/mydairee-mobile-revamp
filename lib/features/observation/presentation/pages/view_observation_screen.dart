import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/observation/data/model/observation_model.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_bloc.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_event.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_state.dart';
import 'package:mydiaree/features/observation/presentation/widget/view_observation_custom_widgets.dart';
import 'package:mydiaree/main.dart';

class ViewObservationScreen extends StatefulWidget {
  final String id;

  const ViewObservationScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewObservationScreenState createState() => _ViewObservationScreenState();
}

class _ViewObservationScreenState extends State<ViewObservationScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    // Fetch observation using BLoC
    context
        .read<ViewObservationBloc>()
        .add(FetchObservationEvent(observationId: widget.id));
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget _buildHeader(String? observationTitle) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            observationTitle ?? 'Observation Details',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
          ),
          const CustomButton(
            text: 'Edit',
            height: 35,
            width: 70,
            borderRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String? content) {
    if (content == null || content.trim().isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryColor,
                ),
          ),
          const SizedBox(height: 8),
          PatternBackground(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildTab(
    ObservationModel? _observation,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Child Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _observation?.children != null
                ? _observation!.children
                    .map((child) => ChildCard(
                          childId: child.childId,
                          childName: child.childName,
                          age: 5,
                        ))
                    .toList()
                : [],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTab(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No $title recorded for this observation',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewObservationBloc = BlocProvider.of<ViewObservationBloc>(context);
    viewObservationBloc.add(FetchObservationEvent(observationId: widget.id));
    return BlocListener<ViewObservationBloc, ViewObservationState>(
      listener: (context, state) {
        if (state is ViewObservationLoaded) {}
      },
      child: CustomScaffold(
        appBar: const CustomAppBar(
          title: 'Observation Details',
          showNotifications: null,
          notificationCount: null,
          actions: null,
          toolbarHeight: 60,
        ),
        body: BlocBuilder<ViewObservationBloc, ViewObservationState>(
          builder: (context, state) {
            if (state is ViewObservationLoading) {
              return const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryColor));
            }
            if (state is ViewObservationFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            if (state is ViewObservationLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(
                            state.data.title,
                          ),
                          PatternBackground(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300)),
                                  ),
                                  child: TabBar(
                                    controller: _tabController,
                                    labelColor: AppColors.primaryColor,
                                    unselectedLabelColor: Colors.grey,
                                    indicatorColor: AppColors.primaryColor,
                                    tabs: const [
                                      Tab(
                                          icon: Icon(Icons
                                              .closed_caption_disabled_outlined),
                                          text: 'Observation'),
                                      Tab(
                                          icon: Icon(Icons.child_care),
                                          text: 'Child'),
                                      Tab(
                                          icon: Icon(Icons.school),
                                          text: 'Montessori'),
                                      Tab(icon: Icon(Icons.star), text: 'EYLF'),
                                      Tab(
                                          icon: Icon(Icons.trending_up),
                                          text: 'Development'),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    padding: const EdgeInsets.all(16.0),
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        SingleChildScrollView(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Basic Information',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                ),
                                                const SizedBox(height: 16),
                                                Table(
                                                  defaultColumnWidth:
                                                      const FlexColumnWidth(
                                                          100),
                                                  columnWidths: const {
                                                    0: IntrinsicColumnWidth(),
                                                    1: IntrinsicColumnWidth(),
                                                  },
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  children: [
                                                    TableRow(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 4),
                                                          child: Text('Date:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4),
                                                          child: Text(state
                                                                      .data !=
                                                                  null
                                                              ? DateFormat(
                                                                      'dd MMM yyyy')
                                                                  .format(DateTime
                                                                      .parse(state
                                                                          .data
                                                                          .dateAdded))
                                                              : ''),
                                                        ),
                                                      ],
                                                    ),
                                                    TableRow(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 4),
                                                          child: Text('Time:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4),
                                                          child: Text(state
                                                                      .data !=
                                                                  null
                                                              ? DateFormat(
                                                                      'hh:mm a')
                                                                  .format(DateTime
                                                                      .parse(state
                                                                          .data
                                                                          .dateAdded))
                                                              : ''),
                                                        ),
                                                      ],
                                                    ),
                                                    TableRow(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 4),
                                                          child: Text('Status:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4),
                                                          child: SizedBox(
                                                            width: 100,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: (state.data !=
                                                                            null &&
                                                                        state.data.status ==
                                                                            'Published')
                                                                    ? Colors
                                                                        .green
                                                                    : const Color(
                                                                        0xffFFEFB8),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          6),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    (state.data?.status ==
                                                                            'Published')
                                                                        ? Icons
                                                                            .check_circle
                                                                        : Icons
                                                                            .drafts,
                                                                    size: 14,
                                                                    color: (state.data?.status ==
                                                                            'Published')
                                                                        ? Colors
                                                                            .white
                                                                        : const Color(
                                                                            0xffCC9D00),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 4),
                                                                  Flexible(
                                                                    child: Text(
                                                                      state.data
                                                                              ?.status ??
                                                                          '',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        color: (state.data?.status ==
                                                                                'Published')
                                                                            ? Colors.white
                                                                            : const Color(0xffCC9D00),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    TableRow(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 4),
                                                          child: Text(
                                                              'Added by:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4),
                                                          child: Text(state.data
                                                                  ?.userName ??
                                                              ''),
                                                        ),
                                                      ],
                                                    ),
                                                    if (state.data
                                                            ?.approverName !=
                                                        null)
                                                      TableRow(
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4),
                                                            child: Text(
                                                                'Approved by:',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        3),
                                                            child: Text(state
                                                                .data!
                                                                .approverName!),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 32),
                                                _buildSection(
                                                    'Observation Notes',
                                                    state.data?.notes),
                                                _buildSection('Reflection',
                                                    state.data?.reflection),
                                                _buildSection('Child Voice',
                                                    state.data?.childVoice),
                                                _buildSection('Future Plan',
                                                    state.data?.futurePlan),
                                                const SizedBox(height: 32),
                                                Text(
                                                  'Media Files',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                ),
                                                const SizedBox(height: 16),
                                                if (state.data?.mediaFiles !=
                                                        null &&
                                                    state.data!.mediaFiles
                                                        .isNotEmpty)
                                                  GridView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: state
                                                        .data.mediaFiles.length,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing: 12,
                                                      crossAxisSpacing: 12,
                                                      childAspectRatio: 1,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      final mediaUrl = state
                                                          .data
                                                          .mediaFiles[index];
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.08),
                                                              blurRadius: 12,
                                                              offset:
                                                                  const Offset(
                                                                      0, 6),
                                                            ),
                                                          ],
                                                          border: Border.all(
                                                            color: AppColors
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.2),
                                                            width: 2,
                                                          ),
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.white,
                                                              AppColors
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.08),
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          child: Image.network(
                                                            mediaUrl,
                                                            height: 140,
                                                            width: 140,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                const PatternBackground(
                                                              height: 140,
                                                              width: 140,
                                                              child: SizedBox(),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                              ]),
                                        ),
                                        SingleChildScrollView(
                                            child: _buildChildTab(state.data)),
                                        _buildEmptyTab('Montessori assessments',
                                            Icons.school),
                                        _buildEmptyTab(
                                            'EYLF outcomes', Icons.star),
                                        _buildEmptyTab('Development milestones',
                                            Icons.trending_up),
                                      ],
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: Text('No observation data available'),
            );
          },
        ),
      ),
    );
  }
}
