import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/main.dart';
import 'package:mydiaree/features/auth/presentation/pages/otp_verify_screen.dart';
import 'package:mydiaree/features/auth/presentation/pages/sign_up_screen.dart';
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
  final TextEditingController emailPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatusBarCustom(
      child: CustomScaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: PatternBackground(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppAssets.mydiaree_horizontal, height: 40),
                      UIHelpers.verticalSpace(30),
                      Text(
                        "Recover my password",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                      ),
                      UIHelpers.verticalSpace(12),
                      Text(
                        "Please enter your email address below to receive instructions(OTP) for resetting password.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                        hintText: "Enter Email address",
                        controller: emailPhoneController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Please enter a valid input";
                          }
                          return null;
                        },
                      ),
                      UIHelpers.verticalSpace(30),
                      CustomButton(
                        text: "RESET PASSWORD",
                        width: screenWidth * 0.7,
                        ontap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return OtpVerifyScreen();
                          }));
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
                                return const SignUpScreen();
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
      ),
    );
  }
}
