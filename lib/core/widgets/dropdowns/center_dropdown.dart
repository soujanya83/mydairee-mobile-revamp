import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';

class CenterDropdown extends StatefulWidget {
  final void Function(CenterData selectedCenter)? onChanged;
  final double height;
  final String hint;

  const CenterDropdown({
    super.key,
    this.onChanged,
    this.height = 40,
    this.hint = 'Select Center',
  });

  @override
  State<CenterDropdown> createState() => _CenterDropdownState();
}

class _CenterDropdownState extends State<CenterDropdown> {
  CenterData? selectedCenter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalDataCubit, GlobalDataState>(
      builder: (context, state) {
        final centers = state.centersData?.data ?? [];

        if (centers.isEmpty) {
          return Container(
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text("No centers available"),
            ),
          );
        }

        return DropdownButtonHideUnderline(
          child: Container(
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Builder(builder: (context) {
              try {
                return DropdownButton<CenterData>(
                  isExpanded: true,
                  value: centers.any((c) => c.id == selectedCenter?.id)
                      ? selectedCenter
                      : null,
                  hint: Text(widget.hint),
                  items: centers.map((center) {
                    return DropdownMenuItem<CenterData>(
                      value: center,
                      child: Text(center.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCenter = value;
                      });
                      widget.onChanged?.call(value);
                    }
                  },
                );
              } catch (e) {
                return const SizedBox();
              }
            }),
          ),
        );
      },
    );
  }
}
