import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/repositories/daily_diaree_reposiory.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_bloc.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_event.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_state.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/features/room/data/model/childrens_room_model.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';

class AddEntryDialog extends StatefulWidget {
  const AddEntryDialog({super.key, required this.roomId});
  final String roomId;
  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  String _selectedActivity = 'breakfast';
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _itemController = TextEditingController();
  final _commentsController = TextEditingController();
  final _sleepTimeController = TextEditingController();
  final _wakeTimeController = TextEditingController();
  final _nappyStatusController = TextEditingController();
  final _searchController = TextEditingController();
  final _signatureController = TextEditingController();
  bool _selectAll = false;
  Map<String, bool> _selectedChildren = {};

  List<AllChild> _allChildren = [];
  bool _loadingChildren = true;
  String? _childrenError;

  bool isSaveLoading = false;

  final List<Map<String, dynamic>> _activities = [
    {
      'title': 'Breakfast',
      'value': 'breakfast',
      'icon': FontAwesomeIcons.mugSaucer
    },
    {
      'title': 'Morning Tea',
      'value': 'morning-tea',
      'icon': FontAwesomeIcons.mugHot
    },
    {'title': 'Lunch', 'value': 'lunch', 'icon': FontAwesomeIcons.utensils},
    {'title': 'Sleep', 'value': 'sleep', 'icon': FontAwesomeIcons.bed},
    {
      'title': 'Afternoon Tea',
      'value': 'afternoon-tea',
      'icon': FontAwesomeIcons.cookie
    },
    {
      'title': 'Late Snacks',
      'value': 'snacks',
      'icon': FontAwesomeIcons.appleWhole
    },
    {'title': 'Sunscreen', 'value': 'sunscreen', 'icon': FontAwesomeIcons.sun},
    {'title': 'Toileting', 'value': 'toileting', 'icon': FontAwesomeIcons.baby},
    {
      'title': 'Bottle',
      'value': 'bottle',
      'icon': FontAwesomeIcons.bottleWater
    },
  ];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _fetchChildren();
  }

  Future<void> _fetchChildren() async {
    setState(() {
      _loadingChildren = true;
      _childrenError = null;
    });

    // Check if selected date is Saturday or Sunday
    DateTime selectedDate;
    try {
      selectedDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    } catch (_) {
      selectedDate = DateTime.now();
    }
    if (selectedDate.weekday == DateTime.saturday ||
        selectedDate.weekday == DateTime.sunday) {
      setState(() {
        _allChildren = [];
        _selectedChildren = {};
        _loadingChildren = false;
        _childrenError = 'No children available on weekends';
      });
      return;
    }

    try {
      final roomId = widget.roomId;
      final repo = RoomRepository();
      final resp = await repo.getChildrenByRoomId(roomId);
      if (resp.success && resp.data?.allChildren != null) {
        setState(() {
          _allChildren = resp.data!.allChildren ?? [];
          _selectedChildren = {
            for (var c in _allChildren) (c.id?.toString() ?? ''): false
          };
          _loadingChildren = false;
        });
      } else {
        setState(() {
          _childrenError = resp.message ?? 'Failed to load children';
          _loadingChildren = false;
        });
      }
    } catch (e) {
      setState(() {
        _childrenError = 'Error loading children';
        _loadingChildren = false;
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _itemController.dispose();
    _commentsController.dispose();
    _sleepTimeController.dispose();
    _wakeTimeController.dispose();
    _nappyStatusController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title:
            'Add ${_selectedActivity.replaceAll('-', ' ').capitalize()} Entry',
      ),
      body: PatternBackground(
        // width: MediaQuery.of(context).size.width * 0.9,
        // height: MediaQuery.of(context).size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: Text(
              //         'Add ${_selectedActivity.replaceAll('-', ' ').capitalize()} Entry',
              //         style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //               fontWeight: FontWeight.bold,
              //               color: Theme.of(context).primaryColor,
              //             ),
              //       ),
              //     ),
              //     // IconButton(
              //     //   icon: const Icon(Icons.close),
              //     //   onPressed: () => Navigator.pop(context),
              //     // ),
              //   ],
              // ),
              const SizedBox(height: 8),
              CustomDropdown<String>(
                value: _activities
                        .map((e) => e['value'] as String)
                        .contains(_selectedActivity)
                    ? _selectedActivity
                    : null,
                hint: 'Select Activity',
                items: _activities
                    .map((activity) => activity['value'] as String)
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedActivity = value!;
                    // Clear activity-specific fields when changing activity
                    _timeController.clear();
                    _itemController.clear();
                    _sleepTimeController.clear();
                    _wakeTimeController.clear();
                    _nappyStatusController.clear();
                    _commentsController.clear();
                  });
                },
                displayItem: (String value) {
                  final activity = _activities.firstWhere(
                      (a) => a['value'] == value)['title'] as String;
                  return activity;
                },
                height: 48,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // General Information
                        Text(
                          'General Information',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        CustomTextFormWidget(
                          controller: _dateController,
                          hintText: 'Date',
                          title: 'Date',
                          suffixWidget: Icon(Icons.calendar_today,
                              color: AppColors.primaryColor),
                          readOnly: true,
                          ontap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(date);
                              // Refetch children if date changes
                              _fetchChildren();
                            }
                          },
                          validator: (value) =>
                              value!.isEmpty ? 'Please select a date' : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Select Children',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        CustomTextFormWidget(
                          controller: _searchController,
                          hintText: 'Search children...',
                          border: OutlineInputBorder(),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                           fillColor: MaterialStateProperty.all(AppColors.primaryColor),
                          title: Text(
                            'Select All',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: _selectAll,
                          onChanged: (value) {
                            setState(() {
                              _selectAll = value ?? false;
                              _selectedChildren
                                  .updateAll((key, _) => _selectAll);
                            });
                          },
                        ),
                        _loadingChildren
                            ? const Center(child: CircularProgressIndicator())
                            : _childrenError != null
                                ? Center(child: Text(_childrenError!))
                                : SizedBox(
                                    child: Builder(
                                      builder: (context) {
                                        final filteredChildren =
                                            _allChildren.where((child) {
                                          final name =
                                              (child.name ?? '').toLowerCase();
                                          final search = _searchController.text
                                              .toLowerCase();
                                          return name.contains(search);
                                        }).toList();
                                        if (filteredChildren.isEmpty) {
                                          return const Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    'No children available')),
                                          );
                                        }
                                        return SizedBox(
                                          height:
                                          filteredChildren.length > 5
                                              ? 200
                                              : filteredChildren.length * 40.0,
                                          child: ListView.builder(
                                            itemCount: filteredChildren.length,
                                            itemBuilder: (context, index) {
                                              final child =
                                                  filteredChildren[index];
                                              final childId =
                                                  child.id?.toString() ?? '';
                                              return CheckboxListTile(
                                                fillColor: MaterialStateProperty.all(AppColors.primaryColor),                       title: Text(
                                                    '${child.name ?? ''} ${child.lastname ?? ''}'),
                                                value: _selectedChildren[
                                                        childId] ??
                                                    false,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedChildren[childId] =
                                                        value ?? false;
                                                    _selectAll =
                                                        _selectedChildren.values
                                                            .every((selected) =>
                                                                selected);
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                        const SizedBox(height: 16),
                        // Activity Specific Fields
                        Text(
                          'Activity Details',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildActivityForm(context),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            text: 'Cancel',
                            ontap: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityForm(BuildContext context) {
    switch (_selectedActivity) {
      case 'breakfast':
      case 'lunch':
      case 'snacks':
        return Column(
          children: [
            CustomTextFormWidget(
              controller: _timeController,
              hintText: '${_selectedActivity.capitalize()} Time',
              border: const OutlineInputBorder(),
              prefixWidget: const Icon(Icons.lock_clock),
              readOnly: true,
              ontap: () async {
                final time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (time != null) {
                  // ignore: use_build_context_synchronously
                  _timeController.text = time.format(context);
                }
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please select a time' : null,
            ),
            const SizedBox(height: 16),
            CustomTextFormWidget(
              controller: _itemController,
              hintText: '${_selectedActivity.capitalize()} Item',
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an item' : null,
            ),
            const SizedBox(height: 16),
            CustomTextFormWidget(
              controller: _commentsController,
              hintText: 'Comments',
              maxLength: 4,
              minLines: 3,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                text: 'Save ${_selectedActivity.capitalize()} Entry',
                // icon: FontAwesomeIcons.save
                isLoading: isSaveLoading,
                ontap: () async {
                  setState(() {
                    isSaveLoading = true;
                  });
                  await _saveActivity(context);
                  setState(() {
                    isSaveLoading = false;
                  });
                },
              ),
            ),
          ],
        );
      case 'sleep':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFormWidget(
                    prefixWidget: const Icon(Icons.av_timer_outlined),
                    controller: _sleepTimeController,
                    hintText: 'Sleep Time',
                    readOnly: true,
                    ontap: () async {
                      final time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        _sleepTimeController.text = time.format(context);
                      }
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please select a sleep time' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormWidget(
                    controller: _wakeTimeController,
                    hintText: 'Wake Time',
                    prefixWidget: const Icon(Icons.av_timer_outlined),
                    readOnly: true,
                    ontap: () async {
                      final time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        _wakeTimeController.text = time.format(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextFormWidget(
              controller: _commentsController,
              hintText: 'Comments',
              minLines: 3,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                text: 'Save Sleep Entry',
                // icon: FontAwesomeIcons.save,
                ontap: () => _saveActivity(context),
              ),
            ),
          ],
        );
      case 'toileting':
        return Column(
          children: [
            CustomTextFormWidget(
              controller: _timeController,
              hintText: 'Time',
              prefixWidget: const Icon(Icons.av_timer_outlined),
              readOnly: true,
              ontap: () async {
                final time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (time != null) {
                  // ignore: use_build_context_synchronously
                  _timeController.text = time.format(context);
                }
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please select a time' : null,
            ),
            const SizedBox(height: 16),
            // CustomDropdown(
            //   height: 55,
            //   hint: 'Nappy Status',
            //   value: _nappyStatusController.text.isEmpty
            //       ? null
            //       : _nappyStatusController.text,
            //   items: ['Clean', 'Wet', 'Soiled', 'Successful']
            //       .map((status) => DropdownMenuItem(
            //             value: status,
            //             child: Text(status),
            //           ))
            //       .toList(),
            //   onChanged: (value) {
            //     _nappyStatusController.text = value.toString();
            //   },
            // ),
            DropdownButtonFormField<String>(
              value: ['Clean', 'Wet', 'Soiled', 'Successful']
                          .contains(_nappyStatusController.text) &&
                      _nappyStatusController.text.isNotEmpty
                  ? _nappyStatusController.text
                  : null,
              decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.primaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.primaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(8))),
              selectedItemBuilder: (context) => [
                'Clean',
                'Wet',
                'Soiled',
                'Successful'
              ].map((st) => Text(st)).toList(),
              items: ['Clean', 'Wet', 'Soiled', 'Successful']
                  .map((st) => DropdownMenuItem(
                        value: st,
                        child: Text(st),
                      ))
                  .toList(),
              onChanged: (v) => _nappyStatusController.text = v ?? '',
            ),
            const SizedBox(height: 16),
            CustomTextFormWidget(
              controller: _signatureController,
              hintText: 'Signature',
              maxLength: 4,
              minLines: 3,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            CustomTextFormWidget(
              controller: _commentsController,
              hintText: 'Comments',
              minLines: 3,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                text: 'Save Toileting Entry',
                // icon: FontAwesomeIcons.save,
                ontap: () => _saveActivity(context),
              ),
            ),
          ],
        );
      default: // morning-tea, afternoon-tea, sunscreen, bottle
        return Column(
          children: [
            CustomTextFormWidget(
              controller: _timeController,
              hintText: '${_selectedActivity.capitalize()} Time',
              border: const OutlineInputBorder(),
              prefixWidget: const Icon(Icons.lock_clock),
              readOnly: true,
              ontap: () async {
                final time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (time != null) {
                  // ignore: use_build_context_synchronously
                  _timeController.text = time.format(context);
                }
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please select a time' : null,
            ),
            // const SizedBox(height: 16),
            // CustomTextFormWidget(
            //   controller: _signatureController,
            //   hintText: 'Signature',
            //   maxLength: 4,
            //   minLines: 3,
            //   maxLines: 3,
            // ),
            const SizedBox(height: 16),
            CustomTextFormWidget(
              controller: _commentsController,
              hintText: 'Comments',
              maxLength: 4,
              minLines: 3,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                text: 'Save ${_selectedActivity.capitalize()} Entry',
                // icon: FontAwesomeIcons.save,
                ontap: () => _saveActivity(context),
              ),
            ),
          ],
        );
    }
  }

  Future<void> _saveActivity(BuildContext context) async {
    String? _toHHmm(String? time) {
      if (time == null || time.isEmpty) return null;
      // Remove AM/PM and extra spaces
      time = time.replaceAll(RegExp(r'\s*(AM|PM|am|pm)\s*'), '').trim();
      // If already in HH:mm, return as is
      final regex = RegExp(r'^\d{1,2}:\d{2}$');
      if (regex.hasMatch(time)) {
        // Pad hour with zero if needed
        final parts = time.split(':');
        final hour = parts[0].padLeft(2, '0');
        return '$hour:${parts[1]}';
      }
      // Try to parse as TimeOfDay format (e.g., 2:30 PM)
      try {
        final format = DateFormat.jm();
        final dt = format.parse(time);
        return DateFormat('HH:mm').format(dt);
      } catch (_) {
        // fallback: just return original
        return time;
      }
    }

    if (_formKey.currentState!.validate()) {
      final selectedChildIds = _selectedChildren.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      if (selectedChildIds.isEmpty) {
        UIHelpers.showToast(
          context,
          message: 'Please select at least one child',
          backgroundColor: AppColors.errorColor,
        );
        return;
      }

      final repo = DailyTrackingRepository();
      final date = _dateController.text;
      final time = _toHHmm(_timeController.text) ?? '';
      final item = _itemController.text;
      final comments =
          _commentsController.text.isNotEmpty ? _commentsController.text : null;
      final sleepTime = _toHHmm(_sleepTimeController.text) ?? '';
      final wakeTime = _toHHmm(_wakeTimeController.text) ?? '';
      final nappyStatus = _nappyStatusController.text;
      final signature = _signatureController.text.isNotEmpty
          ? _signatureController.text
          : null;

      ApiResponse<dynamic> resp;

      switch (_selectedActivity) {
        case 'breakfast':
          resp = await repo.postBreakfast(
            date: date,
            childIds: selectedChildIds,
            time: time,
            item: item,
            comments: comments,
          );
          break;
        case 'lunch':
          resp = await repo.postLunch(
            date: date,
            childIds: selectedChildIds,
            time: time,
            item: item,
            comments: comments,
          );
          break;
        case 'snacks':
          resp = await repo.postLateSnack(
            date: date,
            childIds: selectedChildIds,
            time: time,
            item: item,
            comments: comments,
          );
          break;
        case 'morning-tea':
          resp = await repo.postMorningTea(
            date: date,
            childIds: selectedChildIds,
            time: time,
            comments: comments,
          );
          break;
        case 'afternoon-tea':
          resp = await repo.postAfternoonTea(
            date: date,
            childIds: selectedChildIds,
            time: time,
            comments: comments,
          );
          break;
        case 'sleep':
          resp = await repo.storeSleep(
            date: date,
            childIds: selectedChildIds,
            sleepTime: _toHHmm(sleepTime) ?? '',
            wakeTime: _toHHmm(wakeTime) ?? '',
            comments: comments,
          );
          break;
        case 'toileting':
          resp = await repo.storeToileting(
            date: date,
            childIds: selectedChildIds,
            time: time,
            status: nappyStatus.toLowerCase(),
            signature: signature,
            comments: comments,
          );
          break;
        case 'sunscreen':
          resp = await repo.storeSunscreen(
            date: date,
            childIds: selectedChildIds,
            time: time,
            comments: comments,
            signature: signature,
          );
          break;
        case 'bottle':
        default:
          resp = await repo.storeBottle(
            date: date,
            childIds: selectedChildIds,
            time: time,
            comments: comments,
          );
          break;
      }

      if (resp.success) {
        UIHelpers.showToast(
          context,
          message: resp.message ?? 'Entry saved successfully',
          backgroundColor: AppColors.successColor,
        );
        Navigator.pop(context);
      } else {
        UIHelpers.showToast(
          context,
          message: resp.message ?? 'Failed to save entry',
          backgroundColor: AppColors.errorColor,
        );
      }
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}
