import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/signup/signup_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/updatepassowd/update_passoword_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/updatepassowd/update_password_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/updatepassowd/update_password_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Screen controller and variables
  final TextEditingController emailController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final ValueNotifier<bool> isNewPasswordObscured = ValueNotifier<bool>(true);

  final ValueNotifier<bool> isConfirmPasswordObscured =
      ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdatePasswordBloc, UpdatePasswordState>(
        listener: (context, state) {
      if (state is UpdatePasswordSuccess) {
        UIHelpers.showToast(context, message: state.message ?? "");
      }
      if (state is UpdatePasswordFailure) {
        UIHelpers.showToast(context, message: state.message ?? '');
      }
    }, builder: (context, state) {
      return StatusBarCustom(
        child: CustomScaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UIHelpers.logoHorizontal(),
                    UIHelpers.verticalSpace(20),
                    const Text(
                      'Set New Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelpers.verticalSpace(20),

                    /// Email Field
                    CustomTextFormWidget(
                      title: 'Your Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter email' : null,
                      onChanged: (val) {},
                    ),
                    UIHelpers.verticalSpace(15),

                    /// New Password Field
                    ValueListenableBuilder<bool>(
                      valueListenable: isNewPasswordObscured,
                      builder: (context, isObscured, child) {
                        return CustomTextFormWidget(
                          title: 'New Password',
                          hintText: 'Enter new password',
                          isObs: isObscured,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password';
                            }
                            return null;
                          },
                          controller: newPasswordController,
                          onChanged: (val) {},
                          suffixWidget: InkWell(
                            onTap: () {
                              isNewPasswordObscured.value = !isObscured;
                            },
                            child: Icon(
                              isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        );
                      },
                    ),
                    UIHelpers.verticalSpace(15),

                    /// Confirm Password Field
                    ValueListenableBuilder<bool>(
                        valueListenable: isConfirmPasswordObscured,
                        builder: (context, isObscured, child) {
                          return CustomTextFormWidget(
                            title: 'Confirm Password',
                            hintText: 'Confirm password',
                            controller: confirmPasswordController,
                            isObs: isConfirmPasswordObscured.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm password';
                              }
                              return null;
                            },
                            onChanged: (val) {},
                            suffixWidget: InkWell(
                              onTap: () {
                                isConfirmPasswordObscured.value = !isObscured;
                              },
                              child: Icon(
                                isObscured
                                    ? Icons.visibility_off
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          );
                        }),
                    UIHelpers.verticalSpace(25),

                    /// Submit Button
                    CustomButton(
                      text: 'Update Password',
                      isLoading: state is UpdatePasswordSubmitting,
                      ontap: state is UpdatePasswordSubmitting
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                if (newPasswordController.text !=
                                    confirmPasswordController.text) {
                                  UIHelpers.showToast(context,
                                      message: "Passwords do not match");
                                  return;
                                }
                                context
                                    .read<UpdatePasswordBloc>()
                                    .add(UpdatePasswordSubmitted(
                                      email: emailController.text,
                                      newPassword: newPasswordController.text,
                                    ));
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
