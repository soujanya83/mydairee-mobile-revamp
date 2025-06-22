import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/forgot_password/forgot_password_event.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/forgot_password/forgot_password_state.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/login_screen.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/reset_password_screen.dart';
import 'package:mydiaree/main.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/config/app_asset.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          UIHelpers.showToast(context, message: state.message);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(
                      email: emailController.text,
                    )),
          );
        }
        if (state is ForgotPasswordFailure) {
          UIHelpers.showToast(context, message: state.error.toString());
        }
      },
      builder: (context, state) {
        String? email = '';
        if (state is ForgotPasswordInitial) {}
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
                        Image.asset(AppAssets.mydiaree_horizontal, height: 40),
                        UIHelpers.verticalSpace(30),
                        Text(
                          "Recover my password",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        UIHelpers.verticalSpace(12),
                        Text(
                          "Please enter your email address below to receive instructions(OTP) for resetting password.",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.black87,
                                  ),
                        ),
                        UIHelpers.verticalSpace(20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter Email",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                        UIHelpers.verticalSpace(8),
                        CustomTextFormWidget(
                          controller: emailController,
                          hintText: "Enter Email address",
                          validator: validateEmail,
                          onChanged: (val) {},
                        ),
                        UIHelpers.verticalSpace(30),
                        CustomButton(
                          isLoading: state is ForgotPasswordLoading,
                          text: "RESET PASSWORD",
                          width: screenWidth * 0.7,
                          ontap: state is ForgotPasswordLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ForgotPasswordBloc>().add(
                                          ForgotPasswordSubmitted(email),
                                        );
                                  }
                                },
                        ),
                        UIHelpers.verticalSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Know your password? ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.black54),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }));
                              },
                              child: Text(
                                "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.primaryColor,
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
