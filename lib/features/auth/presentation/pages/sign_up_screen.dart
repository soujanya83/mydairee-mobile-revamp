import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_text.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_drop_down_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/auth/presentation/pages/login_screen.dart';
import 'package:mydiaree/features/auth/presentation/widgets/profile_image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  bool isPasswordVisible = false;
  String selectedGender = 'Select Gender';
  XFile? selectedImage;

  final List<String> genderOptions = [
    'Select Gender',
    'Male',
    'Female',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UIHelpers.logoHorizontal(),
            UIHelpers.verticalSpace(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'SuperAdmin Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            UIHelpers.verticalSpace(40),
             Align(
              alignment: Alignment.center,
               child: ProfileImagePicker(
                    selectedImage: selectedImage,
                    onImagePicked: (picked) {
                      setState(() {
                        selectedImage = picked;
                      });
                    },
                  ),
             ),
            UIHelpers.verticalSpace(20),
            Wrap(
              runSpacing: 16,
              spacing: 16,
              children: [
                CustomTextFormWidget(
                  title: 'Name',
                  hintText: 'Enter your name',
                  controller: nameController,
                  validator: (val) => val!.isEmpty ? 'Enter name' : null,
                ),
                CustomTextFormWidget(
                  title: 'Username',
                  hintText: 'Enter your username',
                  controller: usernameController,
                  validator: (val) =>
                      val!.isEmpty ? 'Enter username' : null,
                ),
                CustomTextFormWidget(
                  title: 'Email ID',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (val) => val!.isEmpty ? 'Enter email' : null,
                ),
                CustomTextFormWidget(
                  title: 'Password',
                  hintText: 'Enter your password',
                  isObs: !isPasswordVisible,
                  controller: passwordController,
                  validator: (val) =>
                      val!.isEmpty ? 'Enter password' : null,
                  suffixWidget: IconButton(
                    onPressed: () {
                      setState(
                          () => isPasswordVisible = !isPasswordVisible);
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                CustomTextFormWidget(
                  title: 'Contact No',
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  controller: contactController,
                  validator: (val) =>
                      val!.isEmpty ? 'Enter contact no' : null,
                ),
                Text(
                  'Gender',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                CustomDropdownWidget(
                  items: genderOptions,
                  selectedValue: selectedGender,
                  onChanged: (val) {
                    setState(() => selectedGender = val ?? '');
                  },
                ),
                CustomTextFormWidget(
                  controller: dobController,
                  readOnly: true,
                  ontap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      dobController.text =
                          DateFormat('MM/dd/yyyy').format(picked);
                    }
                  },
                  title: 'Date of Birth',
                  hintText: 'Select your date of birth',
                  validator: (val) =>
                      val!.isEmpty ? 'Select date of birth' : null,
                  suffixWidget: const Icon(Icons.calendar_today,
                      color: AppColors.primaryColor),
                ),
               
              ],
            ),
            UIHelpers.verticalSpace(20),
            CustomButton(
              text: 'Register',
              ontap: () {
                // Add validation and submission logic
              },
            ),
            UIHelpers.verticalSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",
                    style: Theme.of(context).textTheme.bodySmall),
                TextButton(
                  onPressed: () { 
                    
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
