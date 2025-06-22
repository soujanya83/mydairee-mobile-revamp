import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_text.dart';
import 'package:mydiaree/core/config/validators.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/core/widgets/otp_filed.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/login/login_state.dart';
import 'package:mydiaree/features/auth/staff/presentation/bloc/login/staff_event.dart';
import 'package:mydiaree/features/auth/staff/presentation/bloc/login/staff_login_bloc.dart';
import 'package:mydiaree/features/auth/staff/presentation/bloc/login/staff_login_state.dart';
import 'package:mydiaree/main.dart';
import 'package:pinput/pinput.dart';

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController employeeCodeController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StatusBarCustom(
      child: CustomScaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * .05),
            child: Form(
              key: _formKey,
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginLoading) {
                    setState(() => isLoading = true);
                  } else {
                    setState(() => isLoading = false);
                  }

                  if (state is LoginError) {
                    UIHelpers.showToast(
                      context,
                      message: state.message,
                      backgroundColor: AppColors.errorColor,
                    );
                  } else if (state is LoginSuccess) {
                    UIHelpers.showToast(
                      context,
                      message: state.message,
                      backgroundColor: AppColors.successColor,
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UIHelpers.logoHorizontal(),
                    UIHelpers.verticalSpace(30),
                    Text('Staff Login',
                        style: Theme.of(context).textTheme.titleLarge),
                    UIHelpers.verticalSpace(30),
                    CustomTextFormWidget(
                      title: 'Employee Code',
                      controller: employeeCodeController,
                      hintText: 'Enter your employee code',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter employee code';
                        }
                        return null;
                      },
                    ),
                    UIHelpers.verticalSpace(20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'PIN (4-digit)',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    UIHelpers.verticalSpace(8),
                    OtpFields(
                      focusNode: null,
                      pinController: pinCodeController,
                      validator: validatePin,
                    ),
                    UIHelpers.verticalSpace(20),
                    BlocListener<StaffLoginBloc, StaffLoginState>(
                        listener: (context, state) {
                      if (state is StaffLoginError) {
                        UIHelpers.showToast(
                          context,
                          message: state.message,
                          backgroundColor: AppColors.errorColor,
                        );
                      } else if (state is StaffLoginSuccess) {
                        UIHelpers.showToast(
                          context,
                          message: state.message,
                          backgroundColor: AppColors.successColor,
                        );
                      }
                    }, child: BlocBuilder<StaffLoginBloc, StaffLoginState>(
                            builder: (context, state) {
                      return CustomButton(
                        text: AppTexts.login,
                        isLoading: state is StaffLoginLoading,
                        ontap: () {
                          if (state is StaffLoginLoading) return;
                          if (_formKey.currentState?.validate() ?? false) {
                            context
                                .read<StaffLoginBloc>()
                                .add(StaffLoginSubmitted(
                                  employeeCode: employeeCodeController.text,
                                  pin: pinCodeController.text,
                                ));
                          }
                        },
                      );
                    })),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
