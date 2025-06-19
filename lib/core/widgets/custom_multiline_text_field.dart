import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_fonts.dart';

class CustomMultilineTextField extends StatelessWidget {
  final TextEditingController controller;
  final BuildContext context;
  final String? hintText;
  final int minLines;
  final int maxLines;
  final void Function()? onTap;
  final bool readOnly;
  final double? height;
  final double? width;
  final String? title;
  final TextStyle? titleStyle;
  final double? titlePadding;

  const CustomMultilineTextField({
    super.key,
    required this.controller,
    required this.context,
    this.hintText,
    this.minLines = 3,
    this.maxLines = 5,
    this.onTap,
    this.readOnly = true,
    this.height,
    this.width,
    this.title,
    this.titleStyle,
    this.titlePadding,
  });

  @override
  Widget build(BuildContext context) {
    double mw = MediaQuery.of(context).size.width;
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
          height: height,
          width: width ?? mw * .9,
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            minLines: minLines,
            maxLines: maxLines,
            onTap: onTap,
            scrollPadding: const EdgeInsets.only(bottom: 200),
            onTapOutside: (_) => FocusScope.of(this.context).unfocus(),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: hintText,
              focusColor: AppColors.primaryColor,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
