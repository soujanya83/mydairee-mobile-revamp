import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/service_detail/presentation/bloc/add_room/service_detail_bloc.dart';
import 'package:mydiaree/features/service_detail/presentation/bloc/add_room/service_detail_event.dart';
import 'package:mydiaree/features/service_detail/presentation/bloc/add_room/service_detail_state.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _approvalNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _suburbController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _faxController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _providerContactController = TextEditingController();
  final TextEditingController _providerTelephoneController = TextEditingController();
  final TextEditingController _providerMobileController = TextEditingController();
  final TextEditingController _providerFaxController = TextEditingController();
  final TextEditingController _providerEmailController = TextEditingController();
  final TextEditingController _supervisorNameController = TextEditingController();
  final TextEditingController _supervisorTelephoneController = TextEditingController();
  final TextEditingController _supervisorMobileController = TextEditingController();
  final TextEditingController _supervisorFaxController = TextEditingController();
  final TextEditingController _supervisorEmailController = TextEditingController();
  final TextEditingController _postalStreetController = TextEditingController();
  final TextEditingController _postalSuburbController = TextEditingController();
  final TextEditingController _postalStateController = TextEditingController();
  final TextEditingController _postalPostcodeController = TextEditingController();
  final TextEditingController _eduLeaderNameController = TextEditingController();
  final TextEditingController _eduLeaderTelephoneController = TextEditingController();
  final TextEditingController _eduLeaderEmailController = TextEditingController();
  final TextEditingController _strengthSummaryController = TextEditingController();
  final TextEditingController _childGroupServiceController = TextEditingController();
  final TextEditingController _personSubmittingQipController = TextEditingController();
  final TextEditingController _educatorsDataController = TextEditingController();
  final TextEditingController _philosophyStatementController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setData();
  }

  void _setData() {
    _serviceNameController.text = '';
    _approvalNumberController.text = '';
    _streetController.text = '';
    _suburbController.text = '';
    _stateController.text = '';
    _postcodeController.text = '';
    _telephoneController.text = '';
    _phoneController.text = '';
    _faxController.text = '';
    _emailController.text = '';
    _providerContactController.text = '';
    _providerTelephoneController.text = '';
    _providerMobileController.text = '';
    _providerFaxController.text = '';
    _providerEmailController.text = '';
    _supervisorNameController.text = '';
    _supervisorTelephoneController.text = '';
    _supervisorMobileController.text = '';
    _supervisorFaxController.text = '';
    _supervisorEmailController.text = '';
    _postalStreetController.text = '';
    _postalSuburbController.text = '';
    _postalStateController.text = '';
    _postalPostcodeController.text = '';
    _eduLeaderNameController.text = '';
    _eduLeaderTelephoneController.text = '';
    _eduLeaderEmailController.text = '';
    _strengthSummaryController.text = '';
    _childGroupServiceController.text = '';
    _personSubmittingQipController.text = '';
    _educatorsDataController.text = '';
    _philosophyStatementController.text = '';
  }

  static const double normalGap = 16;
  static const double titleGap = 24;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Service Details"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelpers.verticalSpace(titleGap),
                Text('Service Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _serviceNameController, title: 'Service Name', maxLines: 3),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _approvalNumberController, title: 'Service Approval Number', maxLines: 3),
                UIHelpers.verticalSpace(titleGap),
                Text('Primary Contacts at Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                UIHelpers.verticalSpace(8),
                Text('Physical Location of Service', style: TextStyle(fontSize: 16)),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _streetController, title: 'Street'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _suburbController, title: 'Suburb'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _stateController, title: 'State/Territory'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _postcodeController, title: 'Postcode', keyboardType: TextInputType.number),
                UIHelpers.verticalSpace(titleGap),
                Text('Physical Location Contact Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _telephoneController, title: 'Telephone', keyboardType: TextInputType.phone),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _phoneController, title: 'Phone', keyboardType: TextInputType.phone),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _faxController, title: 'Fax'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _emailController, title: 'Email', keyboardType: TextInputType.emailAddress),
                UIHelpers.verticalSpace(titleGap),
                Text('Approved Provider', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _providerContactController, title: 'Primary Contact'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _providerTelephoneController, title: 'Telephone', keyboardType: TextInputType.phone),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _providerMobileController, title: 'Mobile', keyboardType: TextInputType.phone),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _providerFaxController, title: 'Fax'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _providerEmailController, title: 'Email', keyboardType: TextInputType.emailAddress),
                UIHelpers.verticalSpace(titleGap),
                Text('Nominated Supervisor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _supervisorNameController, title: 'Name'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _supervisorTelephoneController, title: 'Telephone', keyboardType: TextInputType.phone),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _supervisorMobileController, title: 'Mobile', keyboardType: TextInputType.phone),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _supervisorFaxController, title: 'Fax'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _supervisorEmailController, title: 'Email', keyboardType: TextInputType.emailAddress),
                UIHelpers.verticalSpace(titleGap),
                Text('Postal Address (if different from physical)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _postalStreetController, title: 'Street'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _postalSuburbController, title: 'Suburb'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _postalStateController, title: 'State/Territory'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _postalPostcodeController, title: 'Postcode', keyboardType: TextInputType.number),
                UIHelpers.verticalSpace(titleGap),
                Text('Educational Leader', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _eduLeaderNameController, title: 'Name'),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _eduLeaderTelephoneController, title: 'Telephone', keyboardType: TextInputType.phone),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _eduLeaderEmailController, title: 'Email', keyboardType: TextInputType.emailAddress),
                UIHelpers.verticalSpace(titleGap),
                Text('Additional Information About Your Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _strengthSummaryController, title: 'Summary of strengths for Educational Program and practice', maxLines: 3),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _childGroupServiceController, title: 'How are the children grouped at your service?', maxLines: 3),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _personSubmittingQipController, title: 'Name and position of person(s) responsible for submitting', maxLines: 3),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _educatorsDataController, title: 'Number of educators registered', maxLines: 3),
                UIHelpers.verticalSpace(titleGap),
                Text('Service Statement of Philosophy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                UIHelpers.verticalSpace(normalGap),
                CustomTextFormWidget(controller: _philosophyStatementController, title: 'Insert your service\'s statement of philosophy here.', maxLines: 5),
                UIHelpers.verticalSpace(titleGap),
              Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    OutlinedButton(
      onPressed: () => Navigator.pop(context),
      child: const Text(
        'CANCEL',
        style: TextStyle(color: Colors.black),
      ),
    ),
    const SizedBox(width: 16),
    BlocListener<ServiceDetailBloc, ServiceDetailState>(
      listener: (context, state) {
        if (state is ServiceDetailSuccess) {
          UIHelpers.showToast(
            context,
            message: state.message,
            backgroundColor: AppColors.successColor,
          );
          Navigator.pop(context);
        } else if (state is ServiceDetailFailure) {
          UIHelpers.showToast(
            context,
            message: state.error,
            backgroundColor: AppColors.errorColor,
          );
        }
      },
      child: BlocBuilder<ServiceDetailBloc, ServiceDetailState>(
        builder: (context, state) {
          return CustomButton(
            height: 45,
            width: 100,
            text: 'SAVE',
            isLoading: state is ServiceDetailLoading,
            ontap: () {
              if (_formKey.currentState!.validate()) {
                final Map<String, dynamic> data = {
                  'service_name': _serviceNameController.text,
                  'approval_number': _approvalNumberController.text,
                  'street': _streetController.text,
                  'suburb': _suburbController.text,
                  'state': _stateController.text,
                  'postcode': _postcodeController.text,
                  'statement_of_philosophy': _philosophyStatementController.text
                };
                context
                    .read<ServiceDetailBloc>()
                    .add(SubmitServiceDetailEvent(serviceData: data));
              }
            },
          );
        },
      ),
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
  void dispose() {
    _serviceNameController.dispose();
    _approvalNumberController.dispose();
    _streetController.dispose();
    _suburbController.dispose();
    _stateController.dispose();
    _postcodeController.dispose();
    _telephoneController.dispose();
    _phoneController.dispose();
    _faxController.dispose();
    _emailController.dispose();
    _providerContactController.dispose();
    _providerTelephoneController.dispose();
    _providerMobileController.dispose();
    _providerFaxController.dispose();
    _providerEmailController.dispose();
    _supervisorNameController.dispose();
    _supervisorTelephoneController.dispose();
    _supervisorMobileController.dispose();
    _supervisorFaxController.dispose();
    _supervisorEmailController.dispose();
    _postalStreetController.dispose();
    _postalSuburbController.dispose();
    _postalStateController.dispose();
    _postalPostcodeController.dispose();
    _eduLeaderNameController.dispose();
    _eduLeaderTelephoneController.dispose();
    _eduLeaderEmailController.dispose();
    _strengthSummaryController.dispose();
    _childGroupServiceController.dispose();
    _personSubmittingQipController.dispose();
    _educatorsDataController.dispose();
    _philosophyStatementController.dispose();
    super.dispose();
  }
}
