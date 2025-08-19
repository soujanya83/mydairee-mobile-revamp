import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mydiaree/features/settings/center_settings/data/model/center_model.dart';
import 'package:mydiaree/features/settings/center_settings/data/repositories/center_repo.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/bloc/center_settings/center_setting_bloc.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/bloc/center_settings/center_setting_event.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/bloc/center_settings/center_setting_state.dart';

class AddCenterLoginScreen extends StatefulWidget {
  final CenterModel? center;

  const AddCenterLoginScreen({
    super.key,
    this.center,
  });

  @override
  State<AddCenterLoginScreen> createState() => _AddCenterLoginScreenState();
}

class _AddCenterLoginScreenState extends State<AddCenterLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController centerNameController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  File? _imageFile;
  final CentersRepository _repository = CentersRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null &&
        result.files.isNotEmpty &&
        result.files.first.path != null) {
      setState(() {
        _imageFile = File(result.files.first.path!);
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    bool success = false;
    try {
      success = await _repository.addCenter(
        centerName: centerNameController.text,
        streetAddress: streetAddressController.text,
        city: cityController.text,
        state: stateController.text,
        zip: zipController.text,
      );
    } catch (e) {
      UIHelpers.showToast(
        context,
        message: e.toString(),
        backgroundColor: AppColors.errorColor,
      );
    }
    setState(() => _isLoading = false);
    if (success) {
      BlocProvider.of<CentersSettingsBloc>(context).add(FetchCentersEvent());
      UIHelpers.showToast(
        context,
        message: 'Center added successfully!',
        backgroundColor: AppColors.successColor,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return DashboardScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Add Center',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Center Details',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              CustomTextFormWidget(
                title: 'Center Name',
                controller: centerNameController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter center name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormWidget(
                title: 'Street Address',
                controller: streetAddressController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter street address' : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormWidget(
                title: 'City',
                controller: cityController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter city' : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormWidget(
                title: 'State',
                controller: stateController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter state' : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormWidget(
                title: 'ZIP Code',
                controller: zipController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter ZIP code' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  CustomButton(
                    text: 'Save',
                    height: 45,
                    width: 100,
                    isLoading: _isLoading,
                    ontap: _isLoading ? null : _submit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    centerNameController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.dispose();
  }
}
