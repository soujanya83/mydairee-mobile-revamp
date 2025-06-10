import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_text.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_state.dart';
import 'package:mydiaree/features/auth/presentation/bloc/updatepassowd/update_passoword_bloc.dart';
import 'package:mydiaree/main.dart' show screenWidth;

class ResetPasswordScreen extends StatelessWidget {
    ResetPasswordScreen({super.key});
 
  final TextEditingController emailController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return 
    
    Builder(
      builder: (context) {
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
                        controller: emailController,
                        title: 'Your Email',
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter email' : null,
                        onChanged: (val) {
                          context.read<LoginBloc>().add(EmailChanged(val!));
                        },
                      ),
                      UIHelpers.verticalSpace(15),
                
                      /// New Password Field
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return CustomTextFormWidget(
                            controller: newPasswordController,
                            title: 'New Password',
                            hintText: 'Enter new password',
                            isObs: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter new password';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              context
                                  .read<LoginBloc>()
                                  .add(PasswordChanged(val!));
                            },
                            suffixWidget: InkWell(
                              onTap: () { 
                              },
                              child: const Icon(
                                false
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off,
                              ),
                            ),
                          );
                        },
                      ),
                      UIHelpers.verticalSpace(15),
                
                      /// Confirm Password Field
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return CustomTextFormWidget(
                            controller: confirmPasswordController,
                            title: 'Confirm Password',
                            hintText: 'Confirm password',
                            isObs: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm password';
                              } else if (value != newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              // handle confirm password change if needed
                            },
                            suffixWidget: InkWell(
                              onTap: () {
                                
                              },
                              child: const Icon(
                                false
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off,
                              ),
                            ),
                          );
                        },
                      ),
                      UIHelpers.verticalSpace(25),
                      /// Submit Button
                      CustomButton(
                        text: 'Update Password',
                        ontap: () {
                          if (_formKey.currentState!.validate()) {
        
                            // Handle password reset
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
      }
    );
  }
}
