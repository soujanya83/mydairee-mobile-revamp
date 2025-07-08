import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';
import 'package:mydiaree/main.dart';

class CenterDropdown extends StatelessWidget {
  final void Function(CenterData selectedCenter)? onChanged;
  final double height;
  final String hint;
  final String? selectedCenterId;
  

  const CenterDropdown({
    super.key,
    this.onChanged,
    this.height = 40,
    this.hint = 'Select Center',
    this.selectedCenterId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalDataCubit, GlobalDataState>(
      builder: (context, state) {
        final centers = state.centersData?.data ?? [];
        if (centers.isEmpty)
         {
          return Material(
            elevation: 1.2,
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: height,
              width: screenWidth*.95,
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
               width: screenWidth*.95,
              height: height,
              // padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(builder: (context) {
                print('=================${selectedCenterId.toString()}=========');
                try {
                  return DropdownButton<CenterData>(
                    padding: EdgeInsets.only(left: 10),
                    isExpanded: true,
                    value:
                        centers.any((center) => center.id == selectedCenterId)
                            ? centers.firstWhere(
                                (center) => center.id == selectedCenterId)
                            : null,
                    hint: Text(hint),
                    items: centers.map((center) {
                      return DropdownMenuItem<CenterData>(
                        value: center,
                        child: Text(center.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        print('===========');
                        print(value.name.toString());
                        onChanged?.call(value);
                      }
                    },
                  );
                } catch (e, s) {
                  print(e.toString());
                  print('==============');
                  print(centers.toString());
                  return Text(e.toString());
                }
              }),
            ),
          ),
        );
      },
    );
  }
}
