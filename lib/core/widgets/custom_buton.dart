import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/main.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color,
    this.height,
    this.width,
    this.textAppTextStyles,
    this.borderRadius,
    required this.text,
    this.border,
    this.ontap,
    this.isLowerCase,
    this.isLoading,
    this.isArrowButton,
    this.loading,
  });
  final Color? color;
  final double? height;
  final double? width;
  final TextStyle? textAppTextStyles;
  final double? borderRadius;
  final String text;
  final BoxBorder? border;
  final void Function()? ontap;
  final bool? isLowerCase;
  final bool? isLoading;
  final Widget? loading;
  final bool? isArrowButton;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48,
      width: width ?? screenWidth * .8,
      child: ElevatedButton(
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
            backgroundColor:
                MaterialStateProperty.all(color ?? AppColors.primaryColor),
            overlayColor:
                MaterialStatePropertyAll(AppColors.black.withOpacity(.1)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 30),
              ),
            )),
        onPressed: isArrowButton ?? false ? null : ontap,
        child: Center(
            child: isLoading ?? false
                ? loading ??
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      ),
                    )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isArrowButton ?? false
                          ? const SizedBox(
                              width: 48,
                            )
                          : const SizedBox(),
                      SizedBox(
                        width: width ?? screenWidth * .8,
                        child: Text(
                          isLowerCase != null ? text : text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      isArrowButton ?? false
                          ? SizedBox(
                              width: 48,
                              child: ElevatedButton(
                                onPressed: ontap,
                                style: ButtonStyle(
                                  elevation: WidgetStateProperty.all(8),
                                  padding:
                                      WidgetStateProperty.all(EdgeInsets.zero),
                                  backgroundColor: WidgetStateProperty.all(
                                      AppColors.primaryColor),
                                ),
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(48),
                                    onTap: ontap,
                                    child: const Center(
                                        child: Icon(
                                      Icons.arrow_forward,
                                      size: 28,
                                      color: AppColors.white,
                                    ))),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  )),
      ),
    );
  }
}
