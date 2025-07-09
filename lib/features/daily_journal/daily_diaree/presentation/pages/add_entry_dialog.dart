import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_bloc.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_event.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_state.dart';
import 'package:intl/intl.dart';

class AddEntryDialog extends StatefulWidget {
  const AddEntryDialog({super.key});

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  String _selectedActivity = 'bottle';
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _itemController = TextEditingController();
  final _commentsController = TextEditingController();
  final _sleepTimeController = TextEditingController();
  final _wakeTimeController = TextEditingController();
  final _nappyStatusController = TextEditingController();
  final _searchController = TextEditingController();
  bool _selectAll = false;
  Map<String, bool> _selectedChildren = {};

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
    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: PatternBackground(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Add ${_selectedActivity.replaceAll('-', ' ').capitalize()} Entry',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
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
                          title: Text(
                            'Select All',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: _selectAll,
                          onChanged: (value) {
                            setState(() {
                              _selectAll = value!;
                              _selectedChildren.updateAll((key, _) => value);
                            });
                          },
                        ),
                        BlocBuilder<DailyTrackingBloc, DailyTrackingState>(
                          builder: (context, state) {
                            if (state is DailyTrackingLoaded) {
                              final filteredChildren =
                                  state.children.where((child) {
                                return child.name.toLowerCase().contains(
                                    _searchController.text.toLowerCase());
                              }).toList();
                              return SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  itemCount: filteredChildren.length,
                                  itemBuilder: (context, index) {
                                    final child = filteredChildren[index];
                                    return CheckboxListTile(
                                      title: Text(child.name),
                                      value:
                                          _selectedChildren[child.id] ?? false,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedChildren[child.id] = value!;
                                          _selectAll = _selectedChildren.values
                                              .every((selected) => selected);
                                        });
                                      },
                                    );
                                  },
                                ),
                              );
                            }
                            return const Center(
                                child: Text('No children available'));
                          },
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
            Row(
              children: [
                Expanded(
                  child: CustomTextFormWidget(
                    controller: _timeController,
                    hintText: '${_selectedActivity.capitalize()} Time',
                    border: const OutlineInputBorder(),
                    readOnly: true,
                    ontap: () async {
                      final time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        _timeController.text = time.format(context);
                      }
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please select a time' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormWidget(
                    controller: _itemController,
                    hintText: '${_selectedActivity.capitalize()} Item',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter an item' : null,
                  ),
                ),
              ],
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
                // icon: FontAwesomeIcons.save,
                ontap: () => _saveActivity(context),
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
                  child: TextFormField(
                    controller: _sleepTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Sleep Time',
                      prefixIcon: FaIcon(FontAwesomeIcons.moon),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
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
                  child: TextFormField(
                    controller: _wakeTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Wake Time',
                      prefixIcon: FaIcon(FontAwesomeIcons.sun),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
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
            TextFormField(
              controller: _commentsController,
              decoration: const InputDecoration(
                labelText: 'Comments',
                prefixIcon: FaIcon(FontAwesomeIcons.comment),
                border: OutlineInputBorder(),
              ),
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      prefixIcon: FaIcon(FontAwesomeIcons.clock),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        _timeController.text = time.format(context);
                      }
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please select a time' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Nappy Status',
                      prefixIcon: FaIcon(FontAwesomeIcons.baby),
                      border: OutlineInputBorder(),
                    ),
                    value: _nappyStatusController.text.isEmpty
                        ? null
                        : _nappyStatusController.text,
                    items: ['Clean', 'Wet', 'Soiled', 'Successful (Toilet)']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      _nappyStatusController.text = value ?? '';
                    },
                    validator: (value) =>
                        value == null ? 'Please select a status' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _commentsController,
              decoration: const InputDecoration(
                labelText: 'Comments',
                prefixIcon: FaIcon(FontAwesomeIcons.comment),
                border: OutlineInputBorder(),
              ),
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
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                prefixIcon: FaIcon(FontAwesomeIcons.clock),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (time != null) {
                  _timeController.text = time.format(context);
                }
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please select a time' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _commentsController,
              decoration: const InputDecoration(
                labelText: 'Comments',
                prefixIcon: FaIcon(FontAwesomeIcons.comment),
                border: OutlineInputBorder(),
              ),
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

  void _saveActivity(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedChildren.values.every((selected) => !selected)) {
        UIHelpers.showToast(
          context,
          message: 'Please select at least one child',
          backgroundColor: AppColors.errorColor,
        );
        return;
      }
      final activity = ActivityModel(
        type: _selectedActivity,
        date: DateTime.parse(_dateController.text),
        time: _timeController.text.isNotEmpty ? _timeController.text : null,
        item: _itemController.text.isNotEmpty ? _itemController.text : null,
        sleepTime: _sleepTimeController.text.isNotEmpty
            ? _sleepTimeController.text
            : null,
        wakeTime: _wakeTimeController.text.isNotEmpty
            ? _wakeTimeController.text
            : null,
        status: _nappyStatusController.text.isNotEmpty
            ? _nappyStatusController.text
            : null,
        comments: _commentsController.text.isNotEmpty
            ? _commentsController.text
            : 'Not-Update',
      );
      context.read<DailyTrackingBloc>().add(SaveActivityEvent(
            childIds: _selectedChildren.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .toList(),
            activity: activity,
          ));
      Navigator.pop(context);
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
