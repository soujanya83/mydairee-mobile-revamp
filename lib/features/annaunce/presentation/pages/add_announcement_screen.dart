import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/add_announcement/add_announce_bloc.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/add_announcement/add_announce_event.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/add_announcement/add_room_state.dart'; 

class AddAnnouncementScreen extends StatefulWidget {
  final String screenType;
  final String centerId;
  final Map<String, dynamic>? announcement;

  const AddAnnouncementScreen({
    super.key,
    required this.screenType,
    required this.centerId,
    this.announcement,
  });

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.announcement != null && widget.screenType == 'edit') {
      titleController.text = widget.announcement?['title'] ?? '';
      descriptionController.text = widget.announcement?['text'] ?? '';
      dateController.text = widget.announcement?['eventDate'] ?? '';
    }
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Add Announcement"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Announcement', style: Theme.of(context).textTheme.headlineSmall),
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
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL', style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 16),
                    BlocListener<AnnounceBloc, AddAnnounceState>(
                      listener: (context, state) {
                        if (state is AddAnnounceFailure) {
                          UIHelpers.showToast(context, message: state.error, backgroundColor: AppColors.errorColor);
                        } else if (state is AddAnnounceSuccess) {
                          UIHelpers.showToast(context, message: state.message, backgroundColor: AppColors.successColor);
                          Navigator.pop(context);
                        }
                      },
                      child: BlocBuilder<AnnounceBloc, AddAnnounceState>(
                        builder: (context, state) {
                          return CustomButton(
                            height: 45,
                            width: 100,
                            text: 'SAVE',
                            isLoading: state is AddAnnounceLoading,
                            ontap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AnnounceBloc>().add(
                                  SubmitAddAnnouncementEvent(
                                    // id: widget.screenType == 'edit' ? widget.announcement?['id'] : null,
                                    centerId: widget.centerId,
                                    title: titleController.text,
                                    text: descriptionController.text,
                                    eventDate: dateController.text, status: '', createdBy: '',
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    )
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
