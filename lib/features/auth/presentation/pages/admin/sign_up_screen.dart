import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/validators.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_drop_down_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_status_bar_widget.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart'
    hide validateEmail;
import 'package:mydiaree/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/signup/signup_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/signup/signup_state.dart';
import 'package:mydiaree/features/auth/presentation/pages/admin/login_screen.dart';
import 'package:mydiaree/features/auth/presentation/pages/admin/otp_verify_screen.dart';
import 'package:mydiaree/features/auth/presentation/widgets/profile_image_picker.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final List<String> genderOptions = const [
    'Select Gender',
    'Male',
    'Female',
    'Other'
  ];

  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for each input field
  final TextEditingController nameController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController contactController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  // Other variables
  String? gender = 'Select Gender';

  XFile? profileImage;

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          UIHelpers.showToast(context, message: 'Registration successful!');
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const OtpVerifyScreen()),
            );
          });
        }
        if (state is SignUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return StatusBarCustom(
          child: CustomScaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: UIHelpers.logoHorizontal(),
                    ),
                    UIHelpers.verticalSpace(10),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'SuperAdmin Details',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    UIHelpers.verticalSpace(40),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Align(
                          alignment: Alignment.center,
                          child: ProfileImagePicker(
                            selectedImage: profileImage,
                            onImagePicked: (picked) {
                              setState(() {
                                profileImage = picked;
                              });
                            },
                          ),
                        );
                      },
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
                          onChanged: (val) {},
                          validator: validateName,
                        ),
                        CustomTextFormWidget(
                          title: 'Username',
                          hintText: 'Enter your username',
                          controller: usernameController,
                          onChanged: (val) {},
                          validator: validateUsername,
                        ),
                        CustomTextFormWidget(
                          title: 'Email ID',
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          onChanged: (val) {},
                          validator: validateEmail,
                        ),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return CustomTextFormWidget(
                              title: 'Password',
                              hintText: 'Enter your password',
                              isObs: !isPasswordVisible,
                              controller: passwordController,
                              onChanged: (val) {},
                              validator: validatePassword,
                              suffixWidget: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            );
                          },
                        ),
                        CustomTextFormWidget(
                          title: 'Contact No',
                          hintText: 'Enter your phone number',
                          keyboardType: TextInputType.phone,
                          controller: contactController,
                          onChanged: (val) {},
                          validator: validateContact,
                        ),
                        Text(
                          'Gender',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return CustomDropdownWidget(
                              items: genderOptions,
                              selectedValue: gender ?? 'Select Gender',
                              onChanged: (val) {
                                setState(() {
                                  gender = val;
                                });
                              },
                            );
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
                          validator: validateDob,
                          suffixWidget: const Icon(Icons.calendar_today,
                              color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                    UIHelpers.verticalSpace(20),
                    CustomButton(
                      text: 'Register',
                      ontap: (state is SignUpLoading)
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (gender == null ||
                                    gender == 'Select Gender') {
                                  UIHelpers.showToast(context,
                                      message: 'Please select a gender');
                                  return;
                                }
                                // if (profileImage == null) {
                                //   UIHelpers.showToast(context,
                                //       message: 'Please select a profile image');
                                //   return;
                                // }
                                FocusScope.of(context).unfocus();
                                context.read<SignupBloc>().add(
                                      SignupSubmitted(
                                        name: nameController.text,
                                        username: usernameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        contact: contactController.text,
                                        dob: dobController.text,
                                        gender: gender ?? '',
                                        profileImage: profileImage,
                                      ),
                                    );
                              }
                            },
                      isLoading: state is SignUpLoading,
                    ),
                    UIHelpers.verticalSpace(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                            style: Theme.of(context).textTheme.bodySmall),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
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
            ),
          ),
        );
      },
    );
  }
}
