import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_text.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_state.dart';
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
  String pin = '';
  String pinErr = '';
  bool isLoading = false;

  bool isFormValid() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      pinErr = pin.length != 4 ? 'Enter 4-digit PIN' : '';
    });

    return isValid && pinErr.isEmpty;
  }

  void onSubmit() {
    if (isFormValid()) {
      // Handle login here
    }
  }

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

                    /// ✅ Employee Code Field with Validator
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

                    /// PIN Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'PIN (4-digit)',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    UIHelpers.verticalSpace(8),
                    Center(
                      child: Pinput(
                        length: 4,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            pin = value;
                            if (value.length == 4) pinErr = '';
                          });
                        },
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: pinErr.isEmpty
                                    ? AppColors.primaryColor
                                    : AppColors.errorColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    if (pinErr.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          pinErr,
                          style: TextStyle(
                              color: AppColors.errorColor, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    UIHelpers.verticalSpace(20),

                    CustomButton(
                      text: AppTexts.login,
                      isLoading: isLoading,
                      ontap: onSubmit,
                    ),
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
