import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_fonts.dart';

// ignore: must_be_immutable
class CustomTextFormWidget extends StatelessWidget {
  CustomTextFormWidget({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.focusnode,
      this.validator,
    this.ontap,
    this.onTapOutside,
    this.ontSaved,
    this.maxLength,
    this.keyboardType,
    this.onFieldSubmitted,
    this.fillColor,
    this.borderRadius,
    this.focusedBorder,
    this.enabledBorder,
    this.border,
    this.borderSide,
    this.title,
    this.height,
    this.width,
    this.scrollPaddingBottom,
    this.prefixWidget,
    this.isObs,
    this.suffixWidget,
    this.maxLines,
    this.contentpadding,
    this.titlePadding,
    this.readOnly,
    this.hintStyle,
    this.contentStyle,
    this.titleStyle,
    this.isDense,
    this.enable,
  });

  final TextEditingController? controller;
  final FocusNode? focusnode;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final VoidCallback? ontap;
  final Function(PointerDownEvent)? onTapOutside;
  final void Function(String?)? ontSaved;
  final int? maxLength;
  double c = 0;
  final String hintText;
  final TextInputType? keyboardType;
  final Function(String)? onFieldSubmitted;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? border;
  final BorderSide? borderSide;
  final String? title;
  final double? height;
  final double? width;
  final double? scrollPaddingBottom;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool? isObs;
  final bool? isDense;
  final bool? enable;
  final int? maxLines;
  final EdgeInsetsGeometry? contentpadding;
  final double? titlePadding;
  final bool? readOnly;
  final TextStyle? hintStyle;
  final TextStyle? contentStyle;
  final TextStyle? titleStyle;


  
  @override
  Widget build(BuildContext context) {
    double mw = MediaQuery.of(context).size.width;
    //c= (1/mw)*392.72727272727275;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(left: titlePadding ?? 0, bottom: 8),
            child: Text(
              title!,
              style: titleStyle ??
                  Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
            ),
          ),
        SizedBox(
          // height:height??mh*.05,
          height: height,
          width: width ?? mw * .9,
          child: TextFormField(
            readOnly: readOnly ?? false,
            maxLines: maxLines ?? 1,
            obscureText: isObs ?? false,
            cursorColor: Colors.black,
            controller: controller,
            focusNode: focusnode,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            style:
                contentStyle ?? Theme.of(context).textTheme.bodyMedium!.copyWith(),
            onFieldSubmitted: onFieldSubmitted ??
                (value) {
                  FocusScope.of(context).nextFocus();
                },
            scrollPadding: EdgeInsets.only(bottom: scrollPaddingBottom ?? 0),
            keyboardType: keyboardType ?? TextInputType.emailAddress,
            maxLength: maxLength ?? 50,
            decoration: InputDecoration(
              prefixIcon: prefixWidget,
              suffixIcon: suffixWidget,
              filled: true,
              fillColor: fillColor ?? Colors.white,
              counterText: '',
              border: border ??
                  OutlineInputBorder(
                    borderSide: borderSide ??
                        const BorderSide(color: AppColors.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
              focusedBorder: focusedBorder ??
                  OutlineInputBorder(
                    borderSide: borderSide ??
                        const BorderSide(color: AppColors.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
              enabled: enable ?? true,
              enabledBorder: enabledBorder ??
                  OutlineInputBorder(
                    borderSide: borderSide ??
                        const BorderSide(
                          color: AppColors.primaryColor,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                    borderRadius: borderRadius ?? BorderRadius.circular(5.0),
                  ),
              errorStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w200,
                  fontFamily: AppFonts.light),
              errorBorder: OutlineInputBorder(
                borderSide: borderSide ??
                    const BorderSide(
                      color: Colors.red,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                borderRadius: borderRadius ?? BorderRadius.circular(5.0),
              ),
              // label: Text(hintText),
              isDense: isDense ?? false,
              //  focusedBorder: InputBorder.none,
              contentPadding: contentpadding ??
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              hintText: hintText,
              hintStyle: hintStyle ??
                  Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w300),
              disabledBorder: OutlineInputBorder(
                borderSide: borderSide ??
                    const BorderSide(color: AppColors.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
        
            validator: validator,
            onChanged: onChanged,
            onTapOutside: onTapOutside ??
                (event) {
                  FocusScope.of(context).unfocus();
                },
            onSaved: ontSaved ??
                (e) {
                  FocusScope.of(context).unfocus();
                },
            onTap: ontap,
          ),
        ),
      ],
    );
  }
}

String? validatePhone(String? value) {
  if (value!.isEmpty) {
    return 'Enter Mobile Number';
  }
  if (value.length != 10) {
    return 'Mobile number should be 10 digit';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value!.isEmpty) {
    return 'email can not be empty';
  } else if (!value.contains('@') || !value.contains('.')
      // ||
      // !value.contains('com')
      ) {
    return 'please enter  valid email';
  }
  return null;
}

String? validateSimple(String value, {String? fieldName}) {
  if (value.isEmpty) {
    return '${fieldName ?? 'require_field'} cannot be empty';
  }
  return null;
}

// void openCountryCode(BuildContext context,
//     {required Function(Country country) onSelected}) {
//   showCountryPicker(
//       context: context,
//       countryListTheme: CountryListThemeData(
//         flagSize: 25,
//         backgroundColor: Colors.white,
//         textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
//         bottomSheetHeight: screenHeight * .6,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20.0),
//           topRight: Radius.circular(20.0),
//         ),
//         //Optional. Styles the search field.
//         inputDecoration: InputDecoration(
//           labelText: 'Search',
//           hintText: 'Start typing to search',
//           prefixIcon: const Icon(Icons.search),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: const Color(0xFF8C98A8).withOpacity(0.2),
//             ),
//           ),
//         ),
//       ),
//       onSelect: onSelected);
// }