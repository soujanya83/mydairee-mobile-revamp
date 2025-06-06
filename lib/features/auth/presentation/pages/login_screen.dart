import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_state.dart';
import 'package:mydiaree/core/config/app_asset.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_text.dart';
import 'package:mydiaree/main.dart';
import 'package:mydiaree/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:mydiaree/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarCustom(
        child: CustomScaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * .05),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UIHelpers.logoHorizontal(),
                UIHelpers.verticalSpace(20),
                UIHelpers.verticalSpace(10),
                Text('Login to your admin account',
                    style: Theme.of(context).textTheme.bodySmall),
                UIHelpers.verticalSpace(30),
                CustomTextFormWidget(
                  title: AppTexts.emailHint,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    context.read<LoginBloc>().add(EmailChanged(val!));
                  },
                  controller: emailController,
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                UIHelpers.verticalSpace(15),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return CustomTextFormWidget(
                      hintText: 'Enter your password',
                      title: AppTexts.passwordHint,
                      controller: passwordController,
                      focusnode: FocusNode(),
                      isObs: !state.isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        context.read<LoginBloc>().add(PasswordChanged(val!));
                      },
                      suffixWidget: InkWell(
                        onTap: () {
                          context.read<LoginBloc>().add(
                              PasswordVisibilityChanged(
                                  !state.isPasswordVisible));
                        },
                        child: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off,
                        ),
                      ),
                    );
                  },
                ),
                UIHelpers.verticalSpace(10),
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      fillColor:
                          const WidgetStatePropertyAll(AppColors.primaryColor),
                    ),
                    Text(AppTexts.rememberMe,
                        style: Theme.of(context).textTheme.bodySmall),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ForgotPasswordScreen();
                        }));
                      },
                      child: Text(AppTexts.forgotPassword,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: AppColors.primaryColor)),
                    )
                  ],
                ),
                UIHelpers.verticalSpace(10),
                CustomButton(
                  text: AppTexts.login,
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      // Trigger login event
                      
                    }
                  },
                ),
                UIHelpers.verticalSpace(10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignUpScreen();
                      }));
                  },
                  child: Text(AppTexts.dontHaveAccount,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.primaryColor)),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
