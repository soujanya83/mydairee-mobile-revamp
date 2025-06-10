import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_state.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_text.dart';
import 'package:mydiaree/main.dart';
import 'package:mydiaree/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:mydiaree/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            child:
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: UIHelpers.logoHorizontal()),
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
                      validator: (value) =>
                          value!.isEmpty ? 'Enter email' : null,
                    ),
                    UIHelpers.verticalSpace(15),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return CustomTextFormWidget(
                          hintText: 'Enter your password',
                          title: AppTexts.passwordHint,
                          isObs: !(state.isPasswordVisible ?? false),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            print('Password changed: $val');
                            context
                                .read<LoginBloc>()
                                .add(PasswordChanged(val!));
                          },
                          suffixWidget: InkWell(
                            onTap: () {
                              context.read<LoginBloc>().add(
                                  PasswordVisibilityChanged(
                                      !(state.isPasswordVisible ?? false)));
                            },
                            child: Icon(
                              (state.isPasswordVisible ?? false)
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          value: state.isRemembered,
                          onChanged: (value) {
                            context
                                .read<LoginBloc>()
                                .add(RememberMeChanged(isRemembered: value!));
                          },
                          fillColor: const WidgetStatePropertyAll(
                              AppColors.primaryColor),
                        ),
                        Text(AppTexts.rememberMe,
                            style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return   ForgotPasswordScreen();
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
                    BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) {
                      if (state is LoginError) {
                        UIHelpers.showToast(
                          context,
                          message: state.errorMessage,
                          backgroundColor: AppColors.errorColor,
                        );
                      } else if (state is LoginSuccess) {
                        UIHelpers.showToast(
                          context,
                          message: state.message,
                          backgroundColor: AppColors.successColor,
                        );
                      }  

                      // if (state is LoginSuccess) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text(state.message)),
                      //   );
                      //   // Navigate to the next screen or perform any action
                      // }

                      //  if (state is LoginLoading) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text('${state.toString()}')),
                      //   );
                      // } else if (state is LoginSuccess) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text(state.message)),
                      //   );
                      //   // Navigate to the next screen or perform any action
                      // } else if (state is LoginError) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text(state.errorMessage)),
                      //   );
                      // } else
                      // if (state is LoginInitial) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('Login Initial State')),
                      //   );
                      // }

                      // else if (state is LoginError) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text(state.errorMessage)),
                      //   );
                      // }
                    }, child: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                      return CustomButton(
                        text: AppTexts.login,
                        isLoading: state is LoginLoading,
                        ontap: () {
                          context
                              .read<LoginBloc>()
                              .add(PasswordChanged('password'));
                          context.read<LoginBloc>().add(EmailChanged('email'));
                          {
                            context.read<LoginBloc>().add(LoginSubmitted(
                                  email: state.email ?? '',
                                  password: state.password ?? '',
                                ));
                          }
                        },
                      );
                    })),
                    UIHelpers.verticalSpace(10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return  SignUpScreen();
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
              );
            }),
          ),
        ),
      ),
    );
  }
}
