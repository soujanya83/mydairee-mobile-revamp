import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/auth/presentation/bloc/otp_verify/otp_verify_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/otp_verify/otp_verify_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/otp_verify/otp_verify_state.dart';

class OtpVerifyScreen extends StatelessWidget {
  const OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<OtpVerifyBloc, OtpVerifyState>(
      listener: (context, state) {
        if (state is OtpVerifySuccess) {
          UIHelpers.showToast(context, message: "OTP Verified!");
          // Navigate to next screen or perform success action
        }
        if (state is OtpVerifyFailure) {
          UIHelpers.showToast(context, message: state.error);
        }
      },
      builder: (context, state) {
        return StatusBarCustom(
          child: CustomScaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UIHelpers.logo(),
                        const SizedBox(height: 24),
                        const Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter OTP",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextFormWidget( 
                          hintText: 'Enter OTP',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the OTP';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            context.read<OtpVerifyBloc>().add(OtpChanged(val ?? ''));
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: state is OtpVerifyLoading ? "Verifying..." : "Verify OTP",
                          ontap: state is OtpVerifyLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<OtpVerifyBloc>().add(OtpSubmitted(state.otp ?? ''));
                                  }
                                },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Didn't receive the OTP? "),
                            GestureDetector(
                              onTap: state is OtpVerifyLoading
                                  ? null
                                  : () {
                                      context.read<OtpVerifyBloc>().add(const OtpResendRequested());
                                    },
                              child: const Text(
                                "Resend",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}