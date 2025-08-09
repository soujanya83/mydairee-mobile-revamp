import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/services/shared_preference_service.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/login/login_bloc.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/login/login_event.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/login/login_state.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_text.dart';
import 'package:mydiaree/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mydiaree/main.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/forgot_password_screen.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/sign_up_screen.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  bool isRemembered = false;

  @override
  Widget build(BuildContext context) {
    return StatusBarCustom(
      child: CustomScaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * .05),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                         UIHelpers.verticalSpace(screenHeight * .1),
                      Align(
                          alignment: Alignment.center,
                          child: UIHelpers.logoHorizontal()),
                      UIHelpers.verticalSpace(20),
                      Text('Login to your admin account',
                          style: Theme.of(context).textTheme.bodySmall),
                      UIHelpers.verticalSpace(30),
                      CustomTextFormWidget(
                        title: AppTexts.emailHint,
                        controller: emailController,
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) {},
                        validator: (value) =>
                            value!.isEmpty ? 'Enter email' : null,
                      ),
                      UIHelpers.verticalSpace(15),
                      CustomTextFormWidget(
                        hintText: 'Enter your password',
                        title: AppTexts.passwordHint,
                        isObs: !isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        controller: passwordController,
                        onChanged: (val) {},
                        suffixWidget: InkWell(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      UIHelpers.verticalSpace(10),
                      // Row(
                      //   children: [
                      //     StatefulBuilder(
                      //       builder: (context, setState) {
                      //         return Checkbox(
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(5),
                      //           ),
                      //           value: isRemembered,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               isRemembered = value!;
                      //             });
                      //           },
                      //           fillColor: const WidgetStatePropertyAll(
                      //               AppColors.primaryColor),
                      //         );
                      //       },
                      //     ),
                      //     Text(AppTexts.rememberMe,
                      //         style: Theme.of(context).textTheme.bodySmall),
                      //     const Spacer(),
                      //     GestureDetector(
                      //       onTap: () {
                      //         Navigator.push(context,
                      //             MaterialPageRoute(builder: (context) {
                      //           return const ForgotPasswordScreen();
                      //         }));
                      //       },
                      //       child: Text(AppTexts.forgotPassword,
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .bodySmall!
                      //               .copyWith(color: AppColors.primaryColor)),
                      //     )
                      //   ],
                      // ),
                      UIHelpers.verticalSpace(10),
                      BlocListener<LoginBloc, LoginState>(
                          listener: (context, state)async {
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
                          final token = state.loginData?.token;
                          
                          if (token != null && token.isNotEmpty){
                            print("Token saved: $token");
                            await saveToken(token);
                            await Future.delayed(const Duration(milliseconds: 100));
                            
                            final savedToken = await getToken();
                            if (kDebugMode) {
                              print("Token verification: ${savedToken != null && savedToken.isNotEmpty}");
                            }
                            await UserTypeHelper.saveUserType(state.loginData?.user?.userType??'');
                            // ignore: use_build_context_synchronously
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return DashboardScreen();
                            }));
                          } else {
                            UIHelpers.showToast(
                              context,
                              message: "Authentication failed - Token missing",
                              backgroundColor: AppColors.errorColor,
                            );
                          }
                        }
                      }, child: BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                        return CustomButton(
                          text: AppTexts.login,
                          isLoading: state is LoginLoading,
                          ontap: (){
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(LoginSubmitted(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ));
                            }
                          },
                        );
                      })),
                      UIHelpers.verticalSpace(10),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(context,
                      //         MaterialPageRoute(builder: (context) {
                      //       return SignUpScreen();
                      //     }));
                      //   },
                      //   child: Text(AppTexts.dontHaveAccount,
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .bodySmall!
                      //           .copyWith(color: AppColors.primaryColor)),
                      // )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}