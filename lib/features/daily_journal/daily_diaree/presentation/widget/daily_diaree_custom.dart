import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/daily_diaree_model.dart';
import 'package:flutter/services.dart';

class ChildCard extends StatelessWidget {
  final ChildElement? child;
  final String imageUrl;
  final VoidCallback onAddEntriesPressed;
  final int activitiesCount;
  final int meals;
  final int naps;
  final bool isCanAdd;

  const ChildCard({
    super.key,
    required this.child,
    required this.onAddEntriesPressed,
    required this.imageUrl,
    required this.activitiesCount,
    required this.meals,
    required this.naps,
    required this.isCanAdd,
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

  /// Generic dialog for both add & edit
  void _openEntryDialog(
    BuildContext context,
    String type, {
    ActivityModel? existing,
    required void Function(ActivityModel result) onSave,
  }) {
    final timeCtrl      = TextEditingController(text: existing?.time);
    final itemCtrl      = TextEditingController(text: existing?.item);
    final commentsCtrl  = TextEditingController(text: existing?.comments);
    final wakeCtrl      = TextEditingController(text: existing?.wakeTime);
    final signatureCtrl = TextEditingController(text: existing?.signature);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${existing == null ? 'Add' : 'Edit'} ${type.replaceAll('-', ' ').capitalize()}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // time field
                if (<String>['breakfast','morning-tea','lunch','afternoon-tea','snacks','sunscreen','toileting']
                        .contains(type)) ...[
                  TextFormField(
                    controller: timeCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) timeCtrl.text = t.format(context);
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // item field
                if (<String>['breakfast','lunch','snacks'].contains(type)) ...[
                  TextFormField(
                    controller: itemCtrl,
                    decoration: const InputDecoration(labelText: 'Item'),
                  ),
                  const SizedBox(height: 12),
                ],

                // wake time (sleep only)
                if (type == 'sleep') ...[
                  TextFormField(
                    controller: timeCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Sleep Time',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) timeCtrl.text = t.format(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: wakeCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Wakeup Time',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) wakeCtrl.text = t.format(context);
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // signature (sunscreen only)
                if (type == 'sunscreen') ...[
                  TextFormField(
                    controller: signatureCtrl,
                    decoration: const InputDecoration(labelText: 'Signature'),
                  ),
                  const SizedBox(height: 12),
                ],

                // comments (all types except toileting uses this same field)
                if (<String>[
                  'breakfast','morning-tea','lunch','afternoon-tea',
                  'snacks','sunscreen','sleep','toileting'
                ].contains(type)) ...[
                  TextFormField(
                    controller: commentsCtrl,
                    decoration: const InputDecoration(labelText: 'Comments'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // simple validation
                        if ((type=='sleep' && (timeCtrl.text.isEmpty || wakeCtrl.text.isEmpty))
                         || (type!='sleep' && timeCtrl.text.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill time fields'))
                          );
                          return;
                        }
                        final result = ActivityModel(
                          type: type,
                          time:      timeCtrl.text,
                          item:      itemCtrl.text,
                          comments:  commentsCtrl.text,
                          sleepTime: type=='sleep' ? timeCtrl.text : null,
                          wakeTime:  type=='sleep' ? wakeCtrl.text : null,
                          signature: signatureCtrl.text,
                        );
                        onSave(result);
                        Navigator.pop(context);
                      },
                      child: Text(existing == null ? 'Add' : 'Save'),
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
            // const SizedBox(height: 12),
            // _buildStats(context),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Breakfast section
                    _buildActivitySection(
                      context,
                      'breakfast',
                      time:      child?.breakfast?.startTime,
                      item:      child?.breakfast?.item,
                      comments:  child?.breakfast?.comments,
                      onAddEntryPressed: () {
                        _openEntryDialog(
                          context,
                          'breakfast',
                          onSave: (act) => _addActivity(act),
                        );
                      },
                    ),
                    _buildActivitySection(
                      context,
                      'morning-tea',
                      time: child?.morningTea?.startTime,
                      onAddEntryPressed: () {
                        // _showItemBasedDialog(context, 'morning-tea');
                      },
                      comments: child?.morningTea?.comments ?? 'Not-Updated',
                    ),
                    _buildActivitySection(
                      context,
                      'lunch',
                      time: child?.lunch?.startTime,
                      onAddEntryPressed: () {
                        // _showItemBasedDialog(context, 'lunch');
                      },
                      item: child?.lunch?.item ?? 'Not-Updated',
                      comments: child?.lunch?.comments ?? 'Not-Updated',
                    ),
                     _buildActivitySectionMultiple( 
                      context,
                      'sleep',
                      isEntriesShow: true,
                      items: List.generate(1, (index) {
                        return ActivityModel(
                          type: 'sleep',
                          sleepTime: 'Not-Updated',
                          wakeTime: 'time', 
                        );
                      }),
                      onAddEntryPressed: () {
                        _openEntryDialog(
                          context,
                          'sleep',
                          onSave: (act) => _addActivity(act),
                        );
                      },
                      onEditEntry: (act) {
                        _openEntryDialog(
                          context,
                          'sleep',
                          existing: act,
                          onSave:   (edited) => _addActivity(edited),
                        );
                      },
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
                   

                    _buildActivitySectionMultiple( 
                      context,
                      'sunscreen',
                      isEntriesShow: false,
                      items: List.generate(1, (index) {
                        return ActivityModel(
                          type: 'sunscreen', comments: 'Not-Updated',
                          time: 'time',
                          signature: 'signature');
                      }),
                      onAddEntryPressed: () => _showSleepDialog(context),
                      onEditEntry: (act) {
                        // open edit dialog with `act`
                        _showSleepDialog(context,);
                      },
                    ),

                    // multiple‐entry section for toileting
                    _buildActivitySectionMultiple(
                      context,
                      'toileting',
                      items: List.generate(1, (index) {
                        return ActivityModel(
                          type: 'toileting',
                          time: '3:14 AM',
                          comments: 'Not-Updated',
                          signature: 'Signature',
                          status: 'Clean',
                        );
                      }),
                      onAddEntryPressed: () => _showToiletingDialog(context, onSave: (ActivityModel act) {
                        // Handle the saved activity model
                      }),
                      onEditEntry: (act) {
                        _showToiletingDialog(context,
                        existing: act, 
                        onSave: (ActivityModel edited) {
                          print('-----------------');
                          print(edited.time);
                          // Handle the edited activity model
                        });
                      },
                    ),
                    _buildActivitySectionMultiple(
                      context,
                      'bottle',
                      items: List.generate(1, (index) {
                        return   ActivityModel(
                          type: 'bottle',
                          comments: 'Not-Updated',
                          time: 'time',
                        );
                      }),
                      onAddEntryPressed: (){},
                      onEditEntry: (act) {
                        // _showBottleDialog(context);
                      },
                    ), 
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
              fullUrl: AppUrls.baseUrl + '/' + imageUrl,
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
              child?.child?.name ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.cakeCandles, size: 13),
                const SizedBox(width: 4),
                Text(
                  'Age: ${_calculateAge(child?.child?.dob)} years',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            // Row(
            //   children: [
            //     const FaIcon(FontAwesomeIcons.clock, size: 13),
            //     const SizedBox(width: 4),
            //     Text(
            //       'Today: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
            //       style: Theme.of(context).textTheme.labelMedium,
            //     ),
            //   ],
            // ),
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
                    if (isCanAdd)
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

  Widget _buildActivitySectionMultiple(
    BuildContext context,
    String type, {
    required List<ActivityModel> items,
    required VoidCallback onAddEntryPressed,
    required Function(ActivityModel) onEditEntry,
    bool isEntriesShow = false
  }) {
    final label = type.replaceAll('-', ' ').capitalize();
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
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 8),
            if (items.isNotEmpty && isEntriesShow)
              Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              child: Text(
                '${items.length} entries',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              ),
            const Spacer(),
           
          ],
        ),
        children:[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 8,bottom: 8),
                child: InkWell(
                  onTap: onAddEntryPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                    ),
                    child: Text(
                      '+ Add',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    ),
                ),
              ),
            ),
          Column(
            children: items.map((activity) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Stack(
                children: [
                  ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (type == 'sleep') ...[
                          Text('Sleep Time: ${activity.sleepTime}'),
                          const SizedBox(width: 16),
                          Text('Wake Time: ${activity.wakeTime}'),
                        ],
                        if (type == 'sunscreen') ...[
                          _buildActivityItem(context,'Time:', activity.time ?? 'Not-Updated' ),
                  
                          _buildActivityItem(context,'Signature:', activity.signature ?? 'Not-Updated' ),
                        ],
                      if (type == 'toileting') ...[
                         Row(
                           children: [
                             Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 _buildActivityItem(context,'Time:', activity.time ?? 'Not-Updated' ),
                                if (activity.status != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: .0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Status: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration( // badge-warning color
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.orange,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            activity.status??'clean',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: Colors.orange),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                               ],
                             ),
                  
                           ],
                         ),
                          _buildActivityItem(context,'Signature:', activity.signature ?? 'Not-Updated' ),
                          const SizedBox(width: 16),
                        ]
                        else ...[
                          _buildActivityItem(context,'Time:', activity.time ?? 'Not-Updated' ),
                        ],
                      ],
                    ),
                    subtitle: _buildActivityItem(context, 'Comments: ', ('${activity.comments}')),
                    // trailing: Container(
                    //   height: 30,width: 30,
                    //   margin: const EdgeInsets.all(2),
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     border: Border.all(
                    //     color: Theme.of(context).primaryColor,
                    //     width: 1,
                    //     ),
                    //   ),
                    //   child: IconButton(
                    //     padding: const EdgeInsets.all(0),
                    //     iconSize: 20,
                    //     icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                    //     onPressed: () => onEditEntry(activity),
                    //   ),
                    // ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                  height: 30,width: 30,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                    ),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    iconSize: 20,
                    icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                    onPressed: () => onEditEntry(activity),
                  ),
                ))
                ],
              ),
            ),
          );
        }).toList(),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActivitySectionForOther(
    BuildContext context,
    String type, {
    String? time,
    String? item,
    String? comments,
    String? status,
    String? sleepTime,
    String? wakeTime,
    String? signature,
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
                            if (signature != null)
                              _buildActivityItem(
                                  context, 'Signature', signature),
                          ],
                        ),
                      ),
                    ),
                    if (isCanAdd)
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
                    !activity.comments!.contains('No '))
                  _buildActivityItem(context, 'Comments', activity.comments??''),
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
      _showToiletingDialog(context, onSave: (ActivityModel act ) {  });
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
    ));
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
    ));
  }

  // void _showToiletingDialog(BuildContext context) {
  //   final timeController = TextEditingController();
  //   final statusController = TextEditingController();
  //   final commentsController = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       child: Container(
  //         padding: const EdgeInsets.all(20),
  //         constraints: BoxConstraints(
  //           maxWidth: MediaQuery.of(context).size.width * 0.9,
  //           maxHeight: MediaQuery.of(context).size.height * 0.5,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Add Toileting',
  //               style: Theme.of(context)
  //                   .textTheme
  //                   .titleLarge
  //                   ?.copyWith(fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 16),
  //             TextFormField(
  //               controller: timeController,
  //               readOnly: true,
  //               decoration: InputDecoration(
  //                 labelText: 'Time',
  //                 border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(8)),
  //                 suffixIcon: const Icon(Icons.access_time),
  //               ),
  //               onTap: () async {
  //                 final time = await showTimePicker(
  //                   context: context,
  //                   initialTime: TimeOfDay.now(),
  //                 );
  //                 if (time != null) {
  //                   timeController.text = time.format(context);
  //                 }
  //               },
  //             ),
  //             const SizedBox(height: 12),
  //             DropdownButtonFormField<String>(
  //               decoration: InputDecoration(
  //                 labelText: 'Status',
  //                 border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(8)),
  //               ),
  //               items: ['Clean', 'Wet', 'Soiled', 'Successful()'].map((status) {
  //                 return DropdownMenuItem(
  //                   value: status,
  //                   child: Text(status),
  //                 );
  //               }).toList(),
  //               onChanged: (value) {
  //                 statusController.text = value ?? 'Wet';
  //               },
  //             ),
  //             const SizedBox(height: 12),
  //             TextFormField(
  //               controller: commentsController,
  //               decoration: InputDecoration(
  //                 labelText: 'Comments',
  //                 border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(8)),
  //               ),
  //               maxLines: 3,
  //             ),
  //             const SizedBox(height: 16),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: const Text('Cancel'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     if (timeController.text.isEmpty ||
  //                         statusController.text.isEmpty) {
  //                       UIHelpers.showToast(
  //                         context,
  //                         message: 'Please select a time and status',
  //                         backgroundColor: AppColors.errorColor,
  //                       );
  //                       return;
  //                     }
  //                     _addActivity(
  //                       ActivityModel(
  //                         type: 'toileting',
  //                         time: timeController.text,
  //                         status: statusController.text,
  //                         comments: commentsController.text.isEmpty
  //                             ? 'Not-Update'
  //                             : commentsController.text,
  //                       ),
  //                     );
  //                     Navigator.pop(context);
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: _getButtonColor('toileting'),
  //                     foregroundColor: Colors.white,
  //                   ),
  //                   child: const Text('Add'),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ));
  // }

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
      ));
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

  // Calculate age from DateTime
  int _calculateAge(DateTime? dob) {
    if (dob == null) return 0;
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  /// Parse a “HH:mm” string into a TimeOfDay
  TimeOfDay _parseTime(String formatted) {
    try {
      print('Parsing time: $formatted');
      final parts = formatted.split(':');
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    } catch (e) {
      print('Error parsing time: $e');
      return TimeOfDay.now();
    }
  }

  void _showToiletingDialog(
    BuildContext context, {
    ActivityModel? existing,
    required void Function(ActivityModel) onSave,
  }) {
    // initialize controllers with existing values (if any)
    final timeCtrl     = TextEditingController(text: existing?.time);
    final statusCtrl   = TextEditingController(text: existing?.status);
    final commentsCtrl = TextEditingController(text: existing?.comments);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${existing == null ? 'Add' : 'Edit'} Toileting',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Time picker field
                TextFormField(
                  controller: timeCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixIcon: const Icon(Icons.access_time),
                  ),
                  onTap: () async {
                    final initial = existing?.time != null
                        ? _parseTime(existing!.time!)
                        : TimeOfDay.now();
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: initial,
                    );
                    if (picked != null) {
                      timeCtrl.text = picked.format(context);
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Status dropdown
                DropdownButtonFormField<String>(
                  value: existing?.status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  items: [
                    'Clean', 'Wet', 'Soiled', 'Successful(Toilet)'
                  ].map((st) => DropdownMenuItem(
                        value: st,
                        child: Text(st),
                      )).toList(),
                  onChanged: (v) => statusCtrl.text = v ?? '',
                ),
                const SizedBox(height: 12),

                // Comments field
                TextFormField(
                  controller: commentsCtrl,
                  decoration: InputDecoration(
                    labelText: 'Comments',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (timeCtrl.text.isEmpty ||
                            statusCtrl.text.isEmpty) {
                          UIHelpers.showToast(
                            context,
                            message:
                              'Please select a time and status',
                            backgroundColor:
                              AppColors.errorColor,
                          );
                          return;
                        }
                        // build a new ActivityModel with updated values
                        final updated = ActivityModel(
                          type: 'toileting',
                          time:     timeCtrl.text,
                          status:   statusCtrl.text,
                          comments: commentsCtrl.text.isEmpty
                            ? 'Not-Update'
                            : commentsCtrl.text,
                        );
                        print(timeCtrl.text);
                        onSave(updated);        // pass back to caller
                        // Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor('toileting'),
                        foregroundColor: Colors.white,
                      ),
                      child:
                        Text(existing == null ? 'Add' : 'Save'),
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


// ensure ActivityModel has nullable fields used above:
class ActivityModel {
  final String type;
  final String? time;
  final String? item;
  final String? comments;
  final String? sleepTime;
  final String? wakeTime;
  final String? signature;
  final String? status;
  ActivityModel( {
    required this.type,
    this.status,
    this.time,
    this.item,
    this.comments,
    this.sleepTime,
    this.wakeTime,
    this.signature,
  });
}
