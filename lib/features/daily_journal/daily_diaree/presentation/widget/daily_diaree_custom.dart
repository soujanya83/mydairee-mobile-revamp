import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/daily_diaree_model.dart';

class ChildCard extends StatelessWidget {
  final ChildElement? child;
  final String imageUrl;
  final VoidCallback onAddEntriesPressed;
  final int activitiesCount;
  final int meals;
  final int naps;

  const ChildCard({
    super.key,
    required this.child,
    required this.onAddEntriesPressed,
    required this.imageUrl,
    required this.activitiesCount,
    required this.meals,
    required this.naps,
  });

  // Initialize state with the provided child model
  void _addActivity(ActivityModel activity) {
    // setState((){
    //   _child = ChildElement(
    //     id: _child.id,
    //     name: _child.name,
    //     age: _child.age,
    //     avatarPath: _child.avatarPath,
    //     activities: List.from(_child.activities)..add(activity),
    //   );
    // });
    // UIHelpers.showToast(
    //   context,
    //   message: 'Activity added successfully',
    //   backgroundColor: AppColors.successColor,
    // );
  }

  @override
  Widget build(BuildContext context) {
    // Main card layout with background and padding
    return PatternBackground(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 6),
        ),
      ],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChildInfo(context),
            const SizedBox(height: 12),
            _buildStats(context),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Breakfast section
                    _buildActivitySection(
                      context,
                      'breakfast',
                      onAddEntryPressed: () {
                        // _showItemBasedDialog(context, 'breakfast');
                      },
                      time: child?.breakfast?.startTime,
                      item: child?.breakfast?.item,
                      comments: child?.breakfast?.comments,
                    ),
                    _buildActivitySection(
                      context,
                      'morning-tea',
                      time: child?.morningTea?.startTime,
                      onAddEntryPressed: () {
                        // _showItemBasedDialog(context, 'morning-tea');
                      },
                      item: child?.morningTea?.item,
                      comments: child?.morningTea?.comments,
                    ),
                    _buildActivitySection(
                      context,
                      'lunch',
                      time: child?.lunch?.startTime,
                      onAddEntryPressed: () {
                        // _showItemBasedDialog(context, 'lunch');
                      },
                      item: child?.lunch?.item,
                      comments: child?.lunch?.comments,
                    ),
                    _buildActivitySection(
                      context,
                      'afternoon-tea',
                      time: child?.afternoonTea?.startTime,
                      onAddEntryPressed: () {
                        // _showItemBasedDialog(context, 'afternoon-tea');
                      },
                      item: child?.afternoonTea?.item,
                      comments: child?.afternoonTea?.comments,
                    ),
                    // Snacks section
                    _buildActivitySection(
                      context,
                      'snacks',
                      time: child?.snacks?.startTime,
                      onAddEntryPressed: () {
                        // _showItemBasedDialog(context, 'snacks');
                      },
                      item: child?.snacks?.item,
                      comments: child?.snacks?.comments,
                    ),
                    // Sleep section (multiple entries)
                    // _buildActivitySectionMultiple(
                    //   context,
                    //   'sleep',
                    //   onAddEntryPressed: () {
                    //     _showSleepDialog(context);
                    //   },
                    //   comments: 'No Multiple Activities',
                    // ),
                    // Theme(
                    //   data: Theme.of(context)
                    //       .copyWith(dividerColor: AppColors.primaryColor),
                    //   child: ExpansionTile(
                    //     // leading: FaIcon(
                    //     //   _getActivityIcon(type),
                    //     //   size: 20,
                    //     //   color: Theme.of(context).primaryColor,
                    //     // ),
                    //     title: Row(
                    //       children: [
                    //         SizedBox(
                    //           width: 90,
                    //           child: Text(
                    //             '',
                    //             // type.replaceAll('-', ' ').capitalize(),
                    //             style: Theme.of(context).textTheme.titleMedium,
                    //           ),
                    //         ),
                    //         const SizedBox(width: 8),
                    //         // _buildStatusBadge(context, type, status ?? 'Not Update'),
                    //       ],
                    //     ),
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           ElevatedButton(
                    //             onPressed: () {},
                    //             style: ElevatedButton.styleFrom(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 16, vertical: 0),
                    //               backgroundColor: AppColors.white,
                    //               // side: BorderSide(color: _getButtonColor(type)),
                    //               foregroundColor: Colors.white,
                    //             ),
                    //             child: Text(
                    //               'Add',
                    //               style: Theme.of(context)
                    //                   .textTheme
                    //                   .titleMedium
                    //                   ?.copyWith(fontSize: 14),
                    //             ),
                    //           ),
                    //         ],
                    //       ),

                    //       // Padding(
                    //       //   padding:
                    //       //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    //       //   child: Column(
                    //       //     crossAxisAlignment: CrossAxisAlignment.end,
                    //       //     children: [
                    //       //       const SizedBox(height: 8),
                    //       //       ListView.builder(
                    //       //         shrinkWrap: true,
                    //       //         physics: const NeverScrollableScrollPhysics(),
                    //       //         itemCount: ,
                    //       //         itemBuilder: (context, index) {
                    //       //           final activity = _child.activities[index];
                    //       //           return Container(
                    //       //             margin: const EdgeInsets.only(
                    //       //               bottom: 8,
                    //       //             ),
                    //       //             decoration: BoxDecoration(
                    //       //               color: AppColors.white,
                    //       //               borderRadius: BorderRadius.circular(12),
                    //       //               gradient: LinearGradient(
                    //       //                 colors: [
                    //       //                   _getStatusColor(status ?? 'Not Update'),
                    //       //                   AppColors.white,
                    //       //                 ],
                    //       //                 stops: const [0.02, 0.02],
                    //       //               ),
                    //       //             ),
                    //       //             child: Stack(
                    //       //               children: [
                    //       //                 Padding(
                    //       //                   padding: const EdgeInsets.only(
                    //       //                       left: 20, right: 20, top: 16, bottom: 16),
                    //       //                   child: Column(
                    //       //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //       //                     children: [
                    //       //                         _buildActivityItem(context, 'Sleep Time',
                    //       //                             activity.sleepTime ?? 'Not-Update'),
                    //       //                         _buildActivityItem(context, 'Wake Time',
                    //       //                             activity.wakeTime ?? 'Not-Update'),
                    //       //                       // if (type == 'sleep') ...[
                    //       //                       //   _buildActivityItem(context, 'Sleep Time',
                    //       //                       //       activity.sleepTime ?? 'Not-Update'),
                    //       //                       //   _buildActivityItem(context, 'Wake Time',
                    //       //                       //       activity.wakeTime ?? 'Not-Update'),
                    //       //                       // ] else
                    //       //                       //   _buildActivityItem(context, 'Time',
                    //       //                       //       activity.time ?? 'Not-Update'),
                    //       //                       // if (activity.item != null)
                    //       //                       //   _buildActivityItem(
                    //       //                       //       context, 'Item', activity.item!),
                    //       //                       // if (activity.status != null &&
                    //       //                       //     activity.type == 'toileting')
                    //       //                       //   _buildActivityItem(
                    //       //                       //       context, 'Status', activity.status!,
                    //       //                       //       isBadge: true),
                    //       //                       // if (activity.comments != null)
                    //       //                       //   _buildActivityItem(
                    //       //                       //       context, 'Comments', activity.comments!),
                    //       //                     ],
                    //       //                   ),
                    //       //                 ),
                    //       //                 Positioned(
                    //       //                   top: 10,
                    //       //                   right: 10,
                    //       //                   child: CircleAvatar(
                    //       //                     radius: 18,
                    //       //                     backgroundColor:
                    //       //                         _getButtonColor('').withOpacity(.5),
                    //       //                     child: IconButton(
                    //       //                       icon: const Icon(
                    //       //                         Icons.edit_outlined,
                    //       //                         size: 20,
                    //       //                         color: AppColors.black,
                    //       //                       ),
                    //       //                       onPressed: (){},
                    //       //                       color: _getButtonColor(''),
                    //       //                       iconSize: 20,
                    //       //                     ),
                    //       //                   ),
                    //       //                 ),
                    //       //               ],
                    //       //             ),
                    //       //           );
                    //       //         },
                    //       //       ),
                    //       //     ],
                    //       //   ),
                    //       // ),
                    //     ],
                    //   ),
                    // )
                 
                    // Toileting section (multiple entries)
                    // _buildActivitySectionMultiple(
                    //   context,
                    //   'toileting',
                    //   onAddEntryPressed: () {
                    //     _showToiletingDialog(context);
                    //   },
                    //   comments: 'No Multiple Activities',
                    // ),
                    // // Bottle section (multiple entries)
                    // _buildActivitySectionMultiple(
                    //   context,
                    //   'bottle',
                    //   onAddEntryPressed: () {
                    //     _showItemBasedDialog(context, 'bottle');
                    //   },
                    //   comments: 'No Multiple Activities',
                    // ),
                    // // Sunscreen section (multiple entries)
                    // _buildActivitySectionMultiple(
                    //   context,
                    //   'sunscreen',
                    //   onAddEntryPressed: () {
                    //     _showTimeAndCommentDialog(context, 'sunscreen');
                    //   },
                    //   comments: 'No Multiple Activities',
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build child information (avatar, name, age, date)
  Widget _buildChildInfo(BuildContext context) {
    return Row(
      children: [
        // Child avatar
        SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: CustomNetworkImage(
              imageUrl: imageUrl,
              errorWidget: Container(
                height: 50,
                width: 50,
                color: AppColors.greyShade.withOpacity(0.3),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Child details
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'name',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.cakeCandles, size: 13),
                const SizedBox(width: 4),
                Text(
                  'Age: age years',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.clock, size: 13),
                const SizedBox(width: 4),
                Text(
                  'Today: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Build statistics (activities, meals, naps)
  Widget _buildStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(context, '$activitiesCount', 'Activities'),
        _buildStatItem(context, '$meals', 'Meals'),
        _buildStatItem(context, '$naps', 'Naps'),
      ],
    );
  }

  // Build a single stat item
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

  Widget _buildActivitySection(
    BuildContext context,
    String type, {
    String? time,
    String? item,
    String? comments,
    String? status,
    String? sleepTime,
    String? wakeTime,
    required VoidCallback onAddEntryPressed,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: AppColors.primaryColor),
      child: ExpansionTile(
        leading: FaIcon(
          _getActivityIcon(type),
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        title: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                type.replaceAll('-', ' ').capitalize(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 8),
            // _buildStatusBadge(context, type, status ?? 'Not Update'),
          ],
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            _getStatusColor(status ?? 'Not Update'),
                            AppColors.white,
                          ],
                          stops: const [0.02, 0.02],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (type == 'sleep') ...[
                              _buildActivityItem(context, 'Sleep Time',
                                  sleepTime ?? 'Not-Update'),
                              _buildActivityItem(context, 'Wake Time',
                                  wakeTime ?? 'Not-Update'),
                            ] else
                              _buildActivityItem(
                                  context, 'Time', time ?? 'Not-Update'),
                            if (item != null)
                              _buildActivityItem(context, 'Item', item),
                            if (status != null && type == 'toileting')
                              _buildActivityItem(context, 'Status', status,
                                  isBadge: true),
                            if (comments != null)
                              _buildActivityItem(context, 'Comments', comments),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: onAddEntryPressed,
                        color: _getButtonColor(type),
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildActivitySectionMultiple(

  Widget _buildStatusBadge(BuildContext context, String type, String status) {
    final status = 'Not Update';
    return Container(
      decoration: BoxDecoration(
        color: status == '0 Entries' || status == '0 Applications'
            ? Colors.red
            : status == 'In Progress'
                ? Colors.orange
                : Colors.blueAccent,
        borderRadius: BorderRadius.circular(3),
      ),
      child: SizedBox(
        width: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          child: Text(
            status,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  // Build add activity button
  Widget _buildAddActivityButton(BuildContext context, String type) {
    return Semantics(
      label: 'Add ${type.replaceAll('-', ' ').capitalize()}',
      button: true,
      child: ElevatedButton.icon(
        onPressed: () => _showAddActivityDialog(context, type),
        icon: const Icon(Icons.add, size: 16),
        label: Text('Add ${type.replaceAll('-', ' ').capitalize()}'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(type),
          foregroundColor: Colors.white,
          minimumSize: const Size(120, 36),
        ),
      ),
    );
  }

  // Build activity list
  Widget _buildAcjtivityList(
      BuildContext context, List<ActivityModel> typeActivities) {
    return Column(
      children: typeActivities.asMap().entries.map((entry) {
        final index = entry.key;
        final activity = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.greyShadeLight,
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                activity.status != null
                    ? (activity.status == 'Not Update'
                        ? Colors.blueAccent
                        : activity.status == 'In Progress'
                            ? Colors.orange
                            : activity.status == '0 Entries' ||
                                    activity.status == '0 Applications'
                                ? Colors.red
                                : activity.status == 'Pending'
                                    ? Colors.grey
                                    : Colors.grey)
                    : Colors.grey,
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
                _buildActivityItem(
                    context, 'Time', activity.time ?? 'Not-Update'),
                if (activity.sleepTime != null && activity.sleepTime != '')
                  _buildActivityItem(
                      context, 'Sleep Time', activity.sleepTime!),
                if (activity.wakeTime != null && activity.wakeTime != '')
                  _buildActivityItem(context, 'Wake Time', activity.wakeTime!),
                if (activity.item != null && activity.item != 'Not-Update')
                  _buildActivityItem(context, 'Item', activity.item!),
                if (activity.status != null && activity.type == 'toileting')
                  _buildActivityItem(context, 'Status', activity.status!,
                      isBadge: true),
                if (activity.comments != 'Not-Update' &&
                    !activity.comments.contains('No '))
                  _buildActivityItem(context, 'Comments', activity.comments),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Build a single activity item
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

  // Show dialog for adding activities
  void _showAddActivityDialog(BuildContext context, String type) {
    if (type == 'breakfast' ||
        type == 'lunch' ||
        type == 'snacks' ||
        type == 'bottle') {
      _showItemBasedDialog(context, type);
    } else if (type == 'sleep') {
      _showSleepDialog(context);
    } else if (type == 'toileting') {
      _showToiletingDialog(context);
    } else {
      _showTimeAndCommentDialog(context, type);
    }
  }

  // Dialog for activities with Time, Item, and Comments
  void _showItemBasedDialog(BuildContext context, String type) {
    final timeController = TextEditingController();
    final itemController = TextEditingController();
    final commentsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add ${type.replaceAll('-', ' ').capitalize()}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.access_time),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    timeController.text = time.format(context);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: itemController,
                decoration: InputDecoration(
                  labelText: 'Item',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: commentsController,
                decoration: InputDecoration(
                  labelText: 'Comments',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (timeController.text.isEmpty) {
                        UIHelpers.showToast(
                          context,
                          message: 'Please select a time',
                          backgroundColor: AppColors.errorColor,
                        );
                        return;
                      }
                      _addActivity(
                        ActivityModel(
                          type: type,
                          time: timeController.text,
                          item: itemController.text.isEmpty
                              ? 'Not-Update'
                              : itemController.text,
                          comments: commentsController.text.isEmpty
                              ? 'Not-Update'
                              : commentsController.text,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(type),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog for sleep with Sleep Time, Wake Time, and Comments
  void _showSleepDialog(BuildContext context) {
    final sleepTimeController = TextEditingController();
    final wakeTimeController = TextEditingController();
    final commentsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Sleep',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: sleepTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Sleep Time',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.access_time),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    sleepTimeController.text = time.format(context);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: wakeTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Wake Time',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.access_time),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    wakeTimeController.text = time.format(context);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: commentsController,
                decoration: InputDecoration(
                  labelText: 'Comments',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (sleepTimeController.text.isEmpty ||
                          wakeTimeController.text.isEmpty) {
                        UIHelpers.showToast(
                          context,
                          message: 'Please select both sleep and wake times',
                          backgroundColor: AppColors.errorColor,
                        );
                        return;
                      }
                      _addActivity(
                        ActivityModel(
                          type: 'sleep',
                          sleepTime: sleepTimeController.text,
                          wakeTime: wakeTimeController.text,
                          comments: commentsController.text.isEmpty
                              ? 'Not-Update'
                              : commentsController.text,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor('sleep'),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog for toileting with Time, Status, and Comments
  void _showToiletingDialog(BuildContext context) {
    final timeController = TextEditingController();
    final statusController = TextEditingController();
    final commentsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Toileting',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.access_time),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    timeController.text = time.format(context);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                items: ['Wet', 'Dry', 'BM', 'Other'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  statusController.text = value ?? 'Wet';
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: commentsController,
                decoration: InputDecoration(
                  labelText: 'Comments',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (timeController.text.isEmpty ||
                          statusController.text.isEmpty) {
                        UIHelpers.showToast(
                          context,
                          message: 'Please select a time and status',
                          backgroundColor: AppColors.errorColor,
                        );
                        return;
                      }
                      _addActivity(
                        ActivityModel(
                          type: 'toileting',
                          time: timeController.text,
                          status: statusController.text,
                          comments: commentsController.text.isEmpty
                              ? 'Not-Update'
                              : commentsController.text,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor('toileting'),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimeAndCommentDialog(BuildContext context, String type) {
    final timeController = TextEditingController();
    final commentsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add ${type.replaceAll('-', ' ').capitalize()}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.access_time),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    timeController.text = time.format(context);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: commentsController,
                decoration: InputDecoration(
                  labelText: 'Comments',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (timeController.text.isEmpty) {
                        UIHelpers.showToast(
                          context,
                          message: 'Please select a time',
                          backgroundColor: AppColors.errorColor,
                        );
                        return;
                      }
                      _addActivity(
                        ActivityModel(
                          type: type,
                          time: timeController.text,
                          comments: commentsController.text.isEmpty
                              ? 'Not-Update'
                              : commentsController.text,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(type),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get activity icon
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

  // Get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Not Update':
        return Colors.blueAccent;
      case 'In Progress':
        return Colors.orange;
      case '0 Entries':
      case '0 Applications':
        return Colors.red;
      case 'Pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // Get button color
  Color _getButtonColor(String type) {
    switch (type) {
      case 'breakfast':
        return Colors.blueAccent;
      case 'morning-tea':
        return Colors.yellow[700]!;
      case 'lunch':
        return Colors.green;
      case 'sleep':
        return Colors.blue;
      case 'afternoon-tea':
        return Colors.brown;
      case 'snacks':
        return Colors.black;
      case 'sunscreen':
        return Colors.yellow[700]!;
      case 'toileting':
        return Colors.grey;
      case 'bottle':
        return Colors.cyan;
      default:
        return AppColors.primaryColor;
    }
  }
}

extension StringExtension on String {
  // Capitalize each word in a string
  String capitalize() {
    return split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}


  // Widget _buildActivitySectionMultiple(
  //   BuildContext context,
  //   String type, {
  //   String? time,
  //   String? item,
  //   String? comments,
  //   String? status,
  //   String? sleepTime,
  //   String? wakeTime,
  //   required VoidCallback onAddEntryPressed,
  // }) {
  //   return Theme(
  //     data: Theme.of(context).copyWith(dividerColor: AppColors.primaryColor),
  //     child: ExpansionTile(
  //       // leading: FaIcon(
  //       //   _getActivityIcon(type),
  //       //   size: 20,
  //       //   color: Theme.of(context).primaryColor,
  //       // ),
  //       title: Row(
  //         children: [
  //           SizedBox(
  //             width: 90,
  //             child: Text(
  //               type.replaceAll('-', ' ').capitalize(),
  //               style: Theme.of(context).textTheme.titleMedium,
  //             ),
  //           ),
  //           const SizedBox(width: 8),
  //           // _buildStatusBadge(context, type, status ?? 'Not Update'),
  //         ],
  //       ),
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             ElevatedButton(
  //               onPressed: onAddEntryPressed,
  //               style: ElevatedButton.styleFrom(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
  //                 backgroundColor: AppColors.white,
  //                 // side: BorderSide(color: _getButtonColor(type)),
  //                 foregroundColor: Colors.white,
  //               ),
  //               child: Text(
  //                 'Add ${type.replaceAll('-', ' ').capitalize()}',
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .titleMedium
  //                     ?.copyWith(fontSize: 14),
  //               ),
  //             ),
  //           ],
  //         ),
  //         Padding(
  //           padding:
  //               const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               const SizedBox(height: 8),
  //               ListView.builder(
  //                 shrinkWrap: true,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 itemCount: _child.activities.length,
  //                 itemBuilder: (context, index) {
  //                   final activity = _child.activities[index];
  //                   return Container(
  //                     margin: const EdgeInsets.only(
  //                       bottom: 8,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: AppColors.white,
  //                       borderRadius: BorderRadius.circular(12),
  //                       gradient: LinearGradient(
  //                         colors: [
  //                           _getStatusColor(status ?? 'Not Update'),
  //                           AppColors.white,
  //                         ],
  //                         stops: const [0.02, 0.02],
  //                       ),
  //                     ),
  //                     child: Stack(
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.only(
  //                               left: 20, right: 20, top: 16, bottom: 16),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               if (type == 'sleep') ...[
  //                                 _buildActivityItem(context, 'Sleep Time',
  //                                     activity.sleepTime ?? 'Not-Update'),
  //                                 _buildActivityItem(context, 'Wake Time',
  //                                     activity.wakeTime ?? 'Not-Update'),
  //                               ] else
  //                                 _buildActivityItem(context, 'Time',
  //                                     activity.time ?? 'Not-Update'),
  //                               if (activity.item != null)
  //                                 _buildActivityItem(
  //                                     context, 'Item', activity.item!),
  //                               if (activity.status != null &&
  //                                   activity.type == 'toileting')
  //                                 _buildActivityItem(
  //                                     context, 'Status', activity.status!,
  //                                     isBadge: true),
  //                               if (activity.comments != null)
  //                                 _buildActivityItem(
  //                                     context, 'Comments', activity.comments!),
  //                             ],
  //                           ),
  //                         ),
  //                         Positioned(
  //                           top: 10,
  //                           right: 10,
  //                           child: CircleAvatar(
  //                             radius: 18,
  //                             backgroundColor:
  //                                 _getButtonColor(type).withOpacity(.5),
  //                             child: IconButton(
  //                               icon: const Icon(
  //                                 Icons.edit_outlined,
  //                                 size: 20,
  //                                 color: AppColors.black,
  //                               ),
  //                               onPressed: onAddEntryPressed,
  //                               color: _getButtonColor(type),
  //                               iconSize: 20,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
