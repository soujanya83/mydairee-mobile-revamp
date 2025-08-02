import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/main.dart';

class CenterDropdown extends StatelessWidget {
  final void Function(Datum selectedCenter)? onChanged;
  final double height;
  final String hint;
  final String? selectedCenterId;

    CenterDropdown({
    super.key,
    this.onChanged,
    this.height = 40,
    this.hint = 'Select Center',
    this.selectedCenterId,
  });
 final GlobalRepository globalRepository = GlobalRepository();
  @override
  Widget build(BuildContext context) {
    final centers = centerDataGloble?.data?.data ?? [];
      WidgetsBinding.instance.addPostFrameCallback((_) async {
     if(centers.isEmpty && centerDataGloble == null)
       {
        centerDataGloble = await globalRepository.getCenters();
      }
    });

    if (centers.isEmpty) {
      return Material(
        elevation: 1.2,
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: height,
          width: screenWidth * .95,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white,
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text("No centers available"),
          ),
        ),
      );
    }

    return DropdownButtonHideUnderline(
      child: Material(
        elevation: 1.2,
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: screenWidth * .95,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<Datum>(
            padding: const EdgeInsets.only(left: 10),
            isExpanded: true,
            value: centers.any((center) => center.id.toString() == selectedCenterId)
                ? centers.firstWhere((center) => center.id.toString() == selectedCenterId)
                : null,
            hint: Text(hint),
            items: centers.map<DropdownMenuItem<Datum>>((center) {
              return DropdownMenuItem<Datum>(
                value: center,
                child: Text(center.centerName ?? ''),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged?.call(value);
              }
            },
          ),
        ),
      ),
    );
  }
}