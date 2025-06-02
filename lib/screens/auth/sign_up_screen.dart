import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:mydiaree/config/app_colors.dart';
import 'package:mydiaree/config/app_text.dart';
import 'package:mydiaree/screens/auth/login_screen.dart';
import 'package:mydiaree/utils/ui_helper.dart';
import 'package:mydiaree/widgets/custom_buton.dart';
import 'package:mydiaree/widgets/custom_scaffold.dart';
import 'package:mydiaree/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/widgets/custom_text_field.dart';
import 'package:mydiaree/config/app_asset.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneCodeController = TextEditingController(text: "+91");

  bool agreeTerms = false;
  bool isPasswordHidden = true;

  Country selectedCountry = Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'India',
    example: 'India',
    displayName: 'India',
    displayNameNoCountryCode: 'IN',
    e164Key: '',
  );

  void openCountryCode(BuildContext context,
      {required Function(Country country) onSelected}) {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.6,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: onSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarCustom(
      child: CustomScaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.logo, height: 60),
                  UIHelpers.verticalSpace(8),
                  const Text("Igniting Curious Mind"),
                  UIHelpers.verticalSpace(12),
                  Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                  ),
                  UIHelpers.verticalSpace(8),
                  const Text("Enter your credentials to continue"),
                  UIHelpers.verticalSpace(20),
                  CustomTextFormWidget(
                    controller: fullNameController,
                    hintText: "Full Name",
                    validator: (val) =>
                        val == null || val.isEmpty ? "Required" : null,
                  ),
                  UIHelpers.verticalSpace(12),

                  /// Username + Phone
                  CustomTextFormWidget(
                    controller: usernameController,
                    hintText: "Username",
                    validator: (String? value) {},
                  ),
                  UIHelpers.verticalSpace(12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          openCountryCode(context, onSelected: (value) {
                            setState(() {
                              selectedCountry = value;
                              phoneCodeController.text =
                                  selectedCountry.countryCode;
                            });
                          });
                        },
                        child: SizedBox(
                          width: 100,
                          child: CustomTextFormWidget(
                            enable: false,
                            controller: phoneCodeController,
                            hintText: "Enter phone code",
                            keyboardType: TextInputType.phone,
                            prefixWidget: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 5, top: 7),
                              child: Text(
                                selectedCountry.flagEmoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            validator: (String? value) {},
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormWidget(
                          controller: phoneController,
                          hintText: "Enter Phone",
                          keyboardType: TextInputType.phone,
                          validator: (String? value) {},
                        ),
                      ),
                    ],
                  ),

                  UIHelpers.verticalSpace(12),
                  CustomTextFormWidget(
                    controller: emailController,
                    hintText: "Email Address",
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) {},
                  ),
                  UIHelpers.verticalSpace(12),

                  /// Password with show/hide
                  CustomTextFormWidget(
                    controller: passwordController,
                    hintText: "Password",
                    isObs: isPasswordHidden,
                    suffixWidget: IconButton(
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => isPasswordHidden = !isPasswordHidden);
                      },
                    ),
                    validator: (String? value) {},
                  ),
                  UIHelpers.verticalSpace(12),

                  /// Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: agreeTerms,
                        onChanged: (value) {
                          setState(() => agreeTerms = value!);
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 13),
                            children: const [
                              TextSpan(text: "Agree with "),
                              TextSpan(
                                text: "Terms & Condition.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  UIHelpers.verticalSpace(10),

                  CustomButton(
                    text: "Sign Up",
                    ontap: () {
                      if (!agreeTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Please agree to Terms & Conditions.")),
                        );
                        return;
                      }

                      // Handle Sign Up logic
                    },
                  ),
                  UIHelpers.verticalSpace(12),
                  GestureDetector(
                    onTap: () {
                       Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    child: Text(
                      "Already have an account?",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
