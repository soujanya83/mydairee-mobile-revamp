import 'package:flutter/material.dart';
import 'package:mydiaree/config/app_colors.dart'; 
import 'package:mydiaree/main.dart';
import 'package:mydiaree/screens/auth/otp_verify_screen.dart';
import 'package:mydiaree/screens/auth/sign_up_screen.dart';
import 'package:mydiaree/utils/ui_helper.dart';
import 'package:mydiaree/widgets/custom_buton.dart';
import 'package:mydiaree/widgets/custom_scaffold.dart';
import 'package:mydiaree/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/widgets/custom_text_field.dart';
import 'package:mydiaree/config/app_asset.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  StatusBarCustom( 
      child:  CustomScaffold( 
        body: 
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.logo, height: 60),
                UIHelpers.verticalSpace(8),
                const Text(
                  "Igniting Curious Mind",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                UIHelpers.verticalSpace(40),
                Text(
                  "Forgot password?",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                ),
                UIHelpers.verticalSpace(20),
                Text(
                  "Enter your email address or phone number or username below and we'll send you password reset OTP on your Email.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                UIHelpers.verticalSpace(20),
                CustomTextFormWidget(
                  hintText: "Enter Email address / Phone number / Username",
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
                  text: "Send OTP",
                  ontap: () {
                    // Handle send OTP logic 
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return OtpScreen(mobileNumber: emailPhoneController.text,);
                    }));
                  },
                ),
                UIHelpers.verticalSpace(10),
                TextButton(
                  onPressed: () {
                    // Handle "Don't have an account" navigation
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const SignUpScreen();
                    }));
                  },
                  child: Text(
                    "Don't have an account?",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.primaryColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
