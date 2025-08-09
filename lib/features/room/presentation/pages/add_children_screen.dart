import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart'
    show Child;
import 'package:mydiaree/features/room/presentation/bloc/view_room/vieiw_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/view_room/vieiw_room_event.dart';

class AddChildrenScreen extends StatefulWidget {
  final String? childId;
  final String? centerId;
  final Child? child;
  final String roomId;
  const AddChildrenScreen(
      {super.key,
      this.childId,
      this.centerId,
      this.child,
      required this.roomId});

  @override
  State<AddChildrenScreen> createState() => _AddChildrenScreenState();
}

class _AddChildrenScreenState extends State<AddChildrenScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController doj = TextEditingController();

  String status = 'Active';
  String gender = 'Male';
  File? imageFile;

  Map<String, bool> daysAttending = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
  };

  bool isLoading = false;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> submitChild() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final daysMap = {
      'mon': daysAttending['Monday']! ? 'on' : '',
      'tue': daysAttending['Tuesday']! ? 'on' : '',
      'wed': daysAttending['Wednesday']! ? 'on' : '',
      'thu': daysAttending['Thursday']! ? 'on' : '',
      'fri': daysAttending['Friday']! ? 'on' : '',
    };

    // Validate image file for add
    if (imageFile == null && widget.childId == null) {
      UIHelpers.showToast(
        context,
        message: 'Please select an image.',
        backgroundColor: AppColors.errorColor,
      );
      setState(() => isLoading = false);
      return;
    }

    // Prepare API payload
    final Map<String, dynamic> data = {
      'firstname': firstName.text,
      'lastname': lastName.text,
      'dob': dob.text,
      'startDate': doj.text,
      'gender': gender,
      'status': status,
      ...daysMap,
      'centerid': widget.centerId,
    };

    List<String> filesPath = [];
    if (imageFile != null) {
      filesPath.add(imageFile!.path);
    }

    String url;
    if (widget.childId != null && widget.childId!.isNotEmpty) {
      // Edit
      url = '${AppUrls.baseUrl}/api/child/update';
      data['id'] = widget.childId;
      if (widget.child?.room != null) {
        data['roomid'] = widget.child!.room.toString();
      }
    } else {
      // Add
      url = '${AppUrls.baseUrl}/api/add-children';
      if (widget.roomId != null && widget.roomId.isNotEmpty) {
        data['id'] = widget.roomId;
      }
    }

    final response = await postAndParse(
      url,
      data,
      filesPath: filesPath,
      fileField: 'file',
    );

    setState(() => isLoading = false);

    UIHelpers.showToast(
      context,
      message: response.message,
      backgroundColor:
          response.success ? AppColors.successColor : AppColors.errorColor,
    );

    if (response.success) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      final roomId = widget.roomId.isNotEmpty ? widget.roomId : '';
      if (roomId.isNotEmpty) {
        try {
          context.read<ViewRoomBloc>().add(FetchRoomChildrenEvent(roomId));
        } catch (_) {}
      }
    }
  }

  void _initializeFromChildData() {
    final child = widget.child;
    if (child == null) return;

    firstName.text = child.name ?? '';
    lastName.text = child.lastname ?? '';
    // Set DOB
    try {
      if (child.dob != null && child.dob!.isNotEmpty) {
        final parsedDob = DateTime.tryParse(child.dob!);
        dob.text = parsedDob != null
            ? "${parsedDob.year.toString().padLeft(4, '0')}-${parsedDob.month.toString().padLeft(2, '0')}-${parsedDob.day.toString().padLeft(2, '0')}"
            : child.dob!;
      } else {
        dob.text = '';
      }
    } catch (_) {
      dob.text = child.dob ?? '';
    }

    // Set DOJ
    try {
      if (child.startDate != null && child.startDate!.isNotEmpty) {
        final parsedDoj = DateTime.tryParse(child.startDate!);
        doj.text = parsedDoj != null
            ? "${parsedDoj.year.toString().padLeft(4, '0')}-${parsedDoj.month.toString().padLeft(2, '0')}-${parsedDoj.day.toString().padLeft(2, '0')}"
            : child.startDate!;
      } else {
        doj.text = '';
      }
    } catch (_) {
      doj.text = child.startDate ?? '';
    }
    status = child.status is String ? child.status as String : 'Active';
    gender = child.gender is String ? child.gender as String : 'Male';

    daysAttending = {
      'Monday': child.daysAttending?.contains('Monday') ?? false,
      'Tuesday': child.daysAttending?.contains('Tuesday') ?? false,
      'Wednesday': child.daysAttending?.contains('Wednesday') ?? false,
      'Thursday': child.daysAttending?.contains('Thursday') ?? false,
      'Friday': child.daysAttending?.contains('Friday') ?? false,
    };

    // Optionally: set imageFile from network if you want to allow re-upload
    // For now, just show network image in build method
  }

  @override
  initState() {
    super.initState();
    _initializeFromChildData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
          title: widget.childId != null ? 'Edit Child' : 'Add Child'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormWidget(
                controller: firstName,
                hintText: 'First Name *',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextFormWidget(
                controller: lastName,
                hintText: 'Last Name *',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextFormWidget(
                controller: dob,
                hintText: 'Date of Birth *',
                readOnly: true,
                ontap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null)
                    dob.text = picked.toIso8601String().split('T').first;
                },
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextFormWidget(
                controller: doj,
                hintText: 'Date of Join *',
                readOnly: true,
                ontap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null)
                    doj.text = picked.toIso8601String().split('T').first;
                },
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomDropdown<String>(
                value: status,
                items: ['Active', 'Enrolled'],
                hint: 'Select Status',
                onChanged: (val) => setState(() => status = val ?? 'Active'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CustomButton(
                    height: 45,
                    width: 150,
                    textAppTextStyles: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white, fontSize: 12),
                    text: imageFile != null ? 'Change Image' : 'Choose Image',
                    ontap: pickImage,
                  ),
                  const SizedBox(width: 12),
                  if (imageFile != null)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (widget.child?.imageUrl != null &&
                      widget.child!.imageUrl!.isNotEmpty)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        AppUrls.baseUrl +
                            '/' +
                            (widget.child!.imageUrl ?? ''),
                        errorBuilder: (context, error, stackTrace) => SizedBox(
                          width: 60,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Gender *', style: Theme.of(context).textTheme.bodyMedium),
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: gender,
                    activeColor: AppColors.primaryColor,
                    onChanged: (val) => setState(() => gender = val!),
                  ),
                  const Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: gender,
                    activeColor: AppColors.primaryColor,
                    onChanged: (val) => setState(() => gender = val!),
                  ),
                  const Text('Female'),
                  Radio<String>(
                    value: 'Other',
                    groupValue: gender,
                    activeColor: AppColors.primaryColor,
                    onChanged: (val) => setState(() => gender = val!),
                  ),
                  const Text('Other'),
                ],
              ),
              const SizedBox(height: 12),
              Text('Days Attending *',
                  style: Theme.of(context).textTheme.bodyMedium),
              Wrap(
                spacing: 8,
                children: daysAttending.keys.map((day) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return AppColors.primaryColor;
                            }
                            return null;
                          },
                        ),
                        value: daysAttending[day],
                        onChanged: (val) =>
                            setState(() => daysAttending[day] = val ?? false),
                      ),
                      Text(day),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL',
                        style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 16),
                  CustomButton(
                    height: 45,
                    width: 100,
                    text: 'SUBMIT',
                    isLoading: isLoading,
                    ontap: submitChild,
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
