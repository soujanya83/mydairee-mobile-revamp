import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String? hint;
  final double? width;
  final double? height;
  final Color borderColor;
  final Color? dropdownColor;
  final Color? dropdownIconColor;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? displayItem;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    this.hint,
    this.width,
    this.height = 40,
    this.borderColor = AppColors.primaryColor,
    this.dropdownColor,
    this.onChanged,
    this.displayItem,
    this.dropdownIconColor,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry? borderRadius = BorderRadius.all(Radius.circular(8));
    return Material(
      elevation: 1.2,
      borderRadius: borderRadius,
      child: DropdownButtonHideUnderline(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: dropdownColor ?? AppColors.white,
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Center(
              child: DropdownButton<T>(
                isExpanded: true,
                value: items.contains(value) ? value : null,
                iconEnabledColor: dropdownIconColor ?? AppColors.primaryColor,
                hint: hint != null ? Text(hint!) : null,
                items: items.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      displayItem != null
                          ? displayItem!(item)
                          : item.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}