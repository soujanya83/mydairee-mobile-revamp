import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_text.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/features/auth/parent/presentation/bloc/login/parent_event.dart';
import 'package:mydiaree/features/auth/parent/presentation/bloc/login/parent_login_bloc.dart';
import 'package:mydiaree/features/auth/parent/presentation/bloc/login/parent_login_state.dart';
import 'package:mydiaree/main.dart';

class ParentLoginScreen extends StatefulWidget {
  const ParentLoginScreen({super.key});

  @override
  State<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatusBarCustom(
      child: CustomScaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * .05),
            child: Form(
              key: _formKey,
              child: BlocListener<ParentLoginBloc, ParentLoginState>(
                listener: (context, state) {
                  if (state is ParentLoginError) {
                    UIHelpers.showToast(
                      context,
                      message: state.message,
                      backgroundColor: AppColors.errorColor,
                    );
                  } else if (state is ParentLoginSuccess) {
                    UIHelpers.showToast(
                      context,
                      message: state.message,
                      backgroundColor: AppColors.successColor,
                    );
                  }
                },
                child: BlocBuilder<ParentLoginBloc, ParentLoginState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UIHelpers.verticalSpace(screenHeight * .03),
                        UIHelpers.logoHorizontal(),
                        UIHelpers.verticalSpace(30),
                        Text(
                          'Parent Login',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        UIHelpers.verticalSpace(30),
                        CustomTextFormWidget(
                          title: 'Email',
                          controller: emailController,
                          hintText: 'Enter your email',
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                        UIHelpers.verticalSpace(20),
                        CustomTextFormWidget(
                          title: 'Password',
                          controller: passwordController,
                          hintText: 'Enter your password',
                          isObs: true,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                        UIHelpers.verticalSpace(20),
                        CustomButton(
                          text: AppTexts.login,
                          isLoading: state is ParentLoginLoading,
                          ontap: () {
                            if (state is ParentLoginLoading) return;
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<ParentLoginBloc>().add(
                                    ParentLoginSubmitted(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
