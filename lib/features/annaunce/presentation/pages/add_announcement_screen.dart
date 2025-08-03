import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_view_model.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_create_model.dart';
import 'package:mydiaree/features/annaunce/data/repositories/announcement_repositories.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/add_announcement/add_announce_bloc.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/add_announcement/add_announce_event.dart';
import 'package:mydiaree/main.dart';

class AddAnnouncementScreen extends StatefulWidget {
  final String screenType; // 'add' or 'edit'
  final String centerId;
  final String? announcementId;

  const AddAnnouncementScreen({
    super.key,
    required this.screenType,
    required this.centerId,
    this.announcementId,
  });

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final AnnoucementRepository _repository = AnnoucementRepository();
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  
  AnnouncemenCreateModel? createData;
  Info? editAnnouncementData;
  
  List<int> selectedChildIds = [];
  bool isLoading = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }
  
  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    
    if (widget.screenType == 'add') { 
      final response = await _repository.getCreateAnnouncementData(
        centerId: widget.centerId,
      );
      
      if (response.success && response.data != null) {
        setState(() {
          createData = response.data;
        });
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } else if (widget.screenType == 'edit' && widget.announcementId != null) {
    
      final response = await _repository.viewAnnouncement(
        announcementId: widget.announcementId!,
      );
      
      if (response.success && response.data?.data?.info != null) {
        final info = response.data!.data!.info!;
        setState(() {
          editAnnouncementData = info;
          titleController.text = info.title ?? '';
          descriptionController.text = info.text ?? '';
          dateController.text = info.eventDate ?? '';
        });
         
        final createResponse = await _repository.getCreateAnnouncementData(
          centerId: widget.centerId,
        );
        
        if (createResponse.success && createResponse.data != null) {
          setState(() {
            createData = createResponse.data;
          });
        }
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    }
    
    setState(() => isLoading = false);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  
  Future<void> _submitAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (selectedChildIds.isEmpty) {
      UIHelpers.showToast(
        context,
        message: 'Please select at least one child',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }
    
    setState(() => isSubmitting = true);
    
    try {
      final response = await _repository.addOrEditAnnouncement(
        id: widget.screenType == 'edit' ? widget.announcementId : null,
        title: titleController.text,
        text: descriptionController.text,
        eventDate: dateController.text,
        childIds: selectedChildIds,
        userId: '1', // Replace with actual user ID from auth
        centerId: widget.centerId,
      );
      
      // Set isSubmitting to false regardless of response success
      setState(() => isSubmitting = false);
      
      if (response.success) {
        UIHelpers.showToast(
          context,
          message: widget.screenType == 'add' 
              ? 'Announcement added successfully' 
              : 'Announcement updated successfully',
          backgroundColor: AppColors.successColor,
        );
        Navigator.pop(context); // Return to previous screen only on success
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      UIHelpers.showToast(
        context,
        message: 'An error occurred',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.screenType == 'add' ? "Add Announcement" : "Edit Announcement",
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.screenType == 'add' ? 'Add Announcement' : 'Edit Announcement',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),

                      CustomTextFormWidget(
                        controller: titleController,
                        hintText: 'Title',
                        title: 'Title',
                        validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
                      ),
                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: CustomTextFormWidget(
                            controller: dateController,
                            hintText: 'YYYY-MM-DD',
                            title: 'Event Date',
                            validator: (v) => v == null || v.isEmpty ? 'Select date' : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      CustomTextFormWidget(
                        controller: descriptionController,
                        hintText: 'Description',
                        title: 'Description',
                        maxLines: 5,
                        validator: (v) => v == null || v.isEmpty ? 'Enter description' : null,
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Select Children',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      
                      // Children selection button
                      if (createData?.data?.childrens != null && createData!.data!.childrens!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => CustomMultiSelectDialog(
                                    title: 'Select Children',
                                    itemsId: createData!.data!.childrens!
                                        .map((c) => c.childid.toString())
                                        .toList(),
                                    itemsName: createData!.data!.childrens!
                                        .map((c) => c.name ?? '')
                                        .toList(),
                                    initiallySelectedIds: selectedChildIds.map((id) => id.toString()).toList(),
                                    onItemTap: (ids) {
                                      setState(() {
                                        selectedChildIds = ids.map((id) => int.parse(id)).toList();
                                      });
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                width: 180,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Icon(Icons.add_circle, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text('Select Children',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (selectedChildIds.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: selectedChildIds.map((childId) {
                                  final child = createData!.data!.childrens!.firstWhere(
                                    (c) => c.childid == childId,
                                    // orElse: () => Childrens(childid: null, name: null),
                                  );
                                  return Chip(
                                    label: Text(child.name ?? 'Unknown'),
                                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                                    labelStyle: TextStyle(color: AppColors.primaryColor),
                                  );
                                }).toList(),
                              )
                            else
                              const Text('No children selected',
                                  style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      else
                        const Text('No children available'),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('CANCEL', style: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(width: 16),
                          CustomButton(
                            height: 45,
                            width: 100,
                            text: 'SAVE',
                            isLoading: isSubmitting,
                            ontap: _submitAnnouncement,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
