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

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final List<String> genderOptions = const [
    'Select Gender',
    'Male',
    'Female',
    'Other'
  ];

  final _formKey = GlobalKey<FormState>();

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
              MaterialPageRoute(
                  builder: (context) => const OtpVerifyScreen()),
            );
          });
        }
        if (state is SignUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    UIHelpers.verticalSpace(40),
                    Align(
                      alignment: Alignment.center,
                      child: ProfileImagePicker(
                        selectedImage: state.profileImage,
                        onImagePicked: (picked) {
                          context
                              .read<SignupBloc>()
                              .add(SignupImageChanged(picked));
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
                          controller: TextEditingController(text: state.name),
                          onChanged: (val) => context
                              .read<SignupBloc>()
                              .add(SignupNameChanged(val!)),
                          validator: validateName,
                        ),
                        CustomTextFormWidget(
                          title: 'Username',
                          hintText: 'Enter your username',
                          controller:
                              TextEditingController(text: state.username),
                          onChanged: (val) => context
                              .read<SignupBloc>()
                              .add(SignupUsernameChanged(val!)),
                          validator: validateUsername,
                        ),
                        CustomTextFormWidget(
                          title: 'Email ID',
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          controller:
                              TextEditingController(text: state.email),
                          onChanged: (val) => context
                              .read<SignupBloc>()
                              .add(SignupEmailChanged(val!)),
                          validator: validateEmail,
                        ),
                        CustomTextFormWidget(
                          title: 'Password',
                          hintText: 'Enter your password',
                          isObs: !(state.isPasswordVisible ?? false),
                          controller:
                              TextEditingController(text: state.password),
                          onChanged: (val) => context
                              .read<SignupBloc>()
                              .add(SignupPasswordChanged(val!)),
                          validator: validatePassword,
                          suffixWidget: IconButton(
                            onPressed: () => context.read<SignupBloc>().add(
                                  SignupPasswordChanged(
                                    state.password ?? '',
                                  ),
                                ),
                            icon: Icon(
                              state.isPasswordVisible ?? false
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        CustomTextFormWidget(
                          title: 'Contact No',
                          hintText: 'Enter your phone number',
                          keyboardType: TextInputType.phone,
                          controller:
                              TextEditingController(text: state.contact),
                          onChanged: (val) => context
                              .read<SignupBloc>()
                              .add(SignupContactChanged(val!)),
                          validator: validateContact,
                        ),
                        Text(
                          'Gender',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        CustomDropdownWidget(
                          items: genderOptions,
                          selectedValue: state.gender ?? 'Select',
                          onChanged: (val) {
                            context
                                .read<SignupBloc>()
                                .add(SignupGenderChanged(val ?? ''));
                          },
                        ),
                        CustomTextFormWidget(
                          controller: TextEditingController(text: state.dob),
                          readOnly: true,
                          ontap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              context.read<SignupBloc>().add(
                                    SignupDobChanged(DateFormat('MM/dd/yyyy')
                                        .format(picked)),
                                  );
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
                              // if (_formKey.currentState?.validate() ?? false)
                              {
                                FocusScope.of(context).unfocus();
                                context.read<SignupBloc>().add(
                                      const SignupSubmitted(),
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
