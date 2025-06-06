import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';

class CustomDropdownWidget extends StatelessWidget {
  final List<String> items;
  final String selectedValue;
  final String label;
  final void Function(String?) onChanged;

  const CustomDropdownWidget({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white, // Background of dropdown popup
        cardTheme: const CardThemeData(
          elevation: 6,
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: AppColors.primaryColor, width: 1),
          ),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
          ),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.primaryColor,
        ),
        elevation: 6, // Shadow effect of dropdown popup
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
