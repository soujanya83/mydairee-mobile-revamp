import 'package:flutter/material.dart';
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
import 'package:mydiaree/features/auth/admin/data/repositories/auth_repository.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/login_screen.dart';
import 'package:mydiaree/features/auth/admin/presentation/pages/admin/otp_verify_screen.dart';
import 'package:mydiaree/features/auth/admin/presentation/widgets/profile_image_picker.dart';

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

  bool isLoading = false;

  String? errorMessage;

  Future<void> _register() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // Validate all fields before API call
    if (nameController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Name is required';
      });
      UIHelpers.showToast(context, message: 'Name is required');
      return;
    }
    if (usernameController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Username is required';
      });
      UIHelpers.showToast(context, message: 'Username is required');
      return;
    }
    if (emailController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Email is required';
      });
      UIHelpers.showToast(context, message: 'Email is required');
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim())) {
      setState(() {
        isLoading = false;
        errorMessage = 'Enter a valid email address';
      });
      UIHelpers.showToast(context, message: 'Enter a valid email address');
      return;
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Password is required';
      });
      UIHelpers.showToast(context, message: 'Password is required');
      return;
    }
    if (passwordController.text.length < 6) {
      setState(() {
        isLoading = false;
        errorMessage = 'Password must be at least 6 characters';
      });
      UIHelpers.showToast(context,
          message: 'Password must be at least 6 characters');
      return;
    }
    if (contactController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Contact number is required';
      });
      UIHelpers.showToast(context, message: 'Contact number is required');
      return;
    }
    if (gender == null || gender == 'Select Gender') {
      setState(() {
        isLoading = false;
        errorMessage = 'Please select a gender';
      });
      UIHelpers.showToast(context, message: 'Please select a gender');
      return;
    }
    if (dobController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Date of birth is required';
      });
      UIHelpers.showToast(context, message: 'Date of birth is required');
      return;
    }

    final repo = AdminAuthenticationRepository();
    final response = await repo.registerUser(
      name: nameController.text.trim(),
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      contact: contactController.text.trim(),
      dob: dobController.text.trim(),
      gender: gender ?? '',
      profileImage: profileImage,
    );
    setState(() {
      isLoading = false;
    });
    if (response.success) {
      UIHelpers.showToast(context, message: response.message,textColor: AppColors.white,backgroundColor: AppColors.successColor);
       Navigator.pop(context);
    } else {
      setState(() {
        errorMessage = response.message;
      });
      final errors = response.data?['errors'];
      String msg = response.message;
      if (errors != null && errors is Map) {
        msg += '\n' +
            errors.entries
                .map((e) => '${e.key}: ${(e.value as List).join(", ")}')
                .join('\n');
      }
      UIHelpers.showToast(
        context,
        message: msg,
        backgroundColor: AppColors.errorColor,
        textColor: AppColors.white,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  ontap: isLoading
                      ? null
                      : () {
                          // Validate all fields before calling _register
                          if (_formKey.currentState?.validate() ?? false) {
                            if (gender == null || gender == 'Select Gender') {
                              UIHelpers.showToast(context,
                                  message: 'Please select a gender');
                              setState(() {
                                errorMessage = 'Please select a gender';
                              });
                              return;
                            }
                            if (dobController.text.trim().isEmpty) {
                              UIHelpers.showToast(context,
                                  message: 'Date of birth is required');
                              setState(() {
                                errorMessage = 'Date of birth is required';
                              });
                              return;
                            }
                            FocusScope.of(context).unfocus();
                            _register();
                          }
                        },
                  isLoading: isLoading,
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
  }
}
