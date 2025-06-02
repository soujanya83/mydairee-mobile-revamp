
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:mydiaree/config/app_colors.dart';

class OtpFields extends StatelessWidget {
  const OtpFields({
    super.key,
    required this.focusNode,
    required this.pinController,
    this.onChanged,
    this.onCompleted,
  });

  final FocusNode focusNode;
  final TextEditingController pinController;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;
  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = AppColors.primaryColor;
    const borderColor = AppColors.primaryColor;

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 0.9),
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Pinput(
        autofocus: false,
        showCursor: false,
        length: 4,
        controller: pinController,
        focusNode: focusNode,
        // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
        // listenForMultipleSmsOnAndroid: true,
        defaultPinTheme: defaultPinTheme,
        separatorBuilder: (index) => const SizedBox(width: 10),
        validator: (value) {
          return value == ''
              ? 'Pin is Empty'
              : !(value!.length < 4)
                  ? null
                  : 'Fill all fields';
        },
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        onCompleted: onCompleted,
        onChanged: onChanged,
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 9),
              width: 22,
              height: 1,
              color: focusedBorderColor,
            ),
          ],
        ),
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            borderRadius: BorderRadius.circular(48),
            border: Border.all(color: focusedBorderColor, width: 2),
          ),
        ),
        submittedPinTheme: defaultPinTheme,
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        errorPinTheme: defaultPinTheme.copyBorderWith(
          border: Border.all(color: Colors.redAccent),
        ),
      )
      ],
    );
  }
}