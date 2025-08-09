import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:intl/intl.dart'; 

class ObservationFilterDialog extends StatefulWidget {
  final List<Map<String, dynamic>> children;
  final List<Map<String, dynamic>> authors;
  final Function(List<String>, List<String>, String, String, List<String>) onApplyFilters;
  
  // Initial values for filters
  final List<String> initialAuthorIds;
  final List<String> initialChildIds;
  final String initialFromDate;
  final String initialToDate;
  final List<String> initialStatuses;
  
  const ObservationFilterDialog({
    Key? key,
    required this.children,
    required this.authors,
    required this.onApplyFilters,
    this.initialAuthorIds = const [],
    this.initialChildIds = const [],
    this.initialFromDate = '',
    this.initialToDate = '',
    this.initialStatuses = const [],
  }) : super(key: key);

  @override
  State<ObservationFilterDialog> createState() => _ObservationFilterDialogState();
}

class _ObservationFilterDialogState extends State<ObservationFilterDialog> {
  late List<String> _selectedAuthorIds;
  late List<String> _selectedChildIds;
  late TextEditingController _fromDateController;
  late TextEditingController _toDateController;
  late List<String> _selectedStatuses;
  
  final statusOptions = ['Published', 'Draft', 'Archived'];

  @override
  void initState() {
    super.initState();
    // Initialize with the passed-in values
    _selectedAuthorIds = List.from(widget.initialAuthorIds);
    _selectedChildIds = List.from(widget.initialChildIds);
    _fromDateController = TextEditingController(text: widget.initialFromDate);
    _toDateController = TextEditingController(text: widget.initialToDate);
    _selectedStatuses = List.from(widget.initialStatuses);
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with primary color accent
              Row(
                children: [
                  Icon(Icons.filter_list, color: AppColors.primaryColor, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Filter Observations',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              
              // Authors filter
              Text(
                'Authors',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomMultiSelectDialog(
                      itemsId: widget.authors.map((a) => a['id'].toString()).toList(),
                      itemsName: widget.authors.map((a) => a['name'].toString()).toList(),
                      initiallySelectedIds: _selectedAuthorIds,
                      title: 'Select Authors',
                      onItemTap: (selectedIds) {
                        setState(() {
                          _selectedAuthorIds = selectedIds;
                        });
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedAuthorIds.isEmpty
                              ? 'Select Authors'
                              : '${_selectedAuthorIds.length} Authors selected',
                          style: TextStyle(
                            color: _selectedAuthorIds.isEmpty ? Colors.grey.shade600 : Colors.black,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Children filter
              Text(
                'Children',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomMultiSelectDialog(
                      itemsId: widget.children.map((c) => c['id'].toString()).toList(),
                      itemsName: widget.children.map((c) => c['name'].toString()).toList(),
                      initiallySelectedIds: _selectedChildIds,
                      title: 'Select Children',
                      onItemTap: (selectedIds) {
                        setState(() {
                          _selectedChildIds = selectedIds;
                        });
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedChildIds.isEmpty
                              ? 'Select Children'
                              : '${_selectedChildIds.length} Children selected',
                          style: TextStyle(
                            color: _selectedChildIds.isEmpty ? Colors.grey.shade600 : Colors.black,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Date range filter - with unified border
              Text(
                'Date Range',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // From date
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.tryParse(_fromDateController.text) ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primaryColor,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            setState(() {
                              _fromDateController.text = DateFormat('yyyy-MM-dd').format(date);
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 18, color: AppColors.primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _fromDateController.text.isEmpty 
                                      ? 'From Date' 
                                      : _fromDateController.text,
                                  style: TextStyle(
                                    color: _fromDateController.text.isEmpty 
                                        ? Colors.grey.shade600 
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Divider
                    Container(
                      height: 30,
                      width: 1,
                      color: AppColors.primaryColor,
                    ),
                    // To date
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.tryParse(_toDateController.text) ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primaryColor,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            setState(() {
                              _toDateController.text = DateFormat('yyyy-MM-dd').format(date);
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 18, color: AppColors.primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _toDateController.text.isEmpty 
                                      ? 'To Date' 
                                      : _toDateController.text,
                                  style: TextStyle(
                                    color: _toDateController.text.isEmpty 
                                        ? Colors.grey.shade600 
                                        : Colors.black,
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
              ),
              
              const SizedBox(height: 20),
              
              // Status filter
              Text(
                'Status',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: statusOptions.map((status) {
                  final isSelected = _selectedStatuses.contains(status);
                  return FilterChip(
                    label: Text(status),
                    selected: isSelected,
                    selectedColor: AppColors.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedStatuses.add(status);
                        } else {
                          _selectedStatuses.remove(status);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              
              const Divider(height: 32),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedAuthorIds = [];
                        _selectedChildIds = [];
                        _fromDateController.text = '';
                        _toDateController.text = '';
                        _selectedStatuses = [];
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade400,
                    ),
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    height: 40,
                    width: 100,
                    text: 'Apply Filters',
                    ontap: () {
                      widget.onApplyFilters(
                        _selectedAuthorIds.isEmpty ? [] : _selectedAuthorIds,
                        _selectedChildIds.isEmpty ? [] : _selectedChildIds,
                        _fromDateController.text.isEmpty ? '' : _fromDateController.text,
                        _toDateController.text.isEmpty ? '' : _toDateController.text,
                        _selectedStatuses.isEmpty ? [] : _selectedStatuses,
                      );
                      Navigator.of(context).pop();
                    },
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