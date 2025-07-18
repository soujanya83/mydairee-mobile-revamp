import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';

class HeadCheckCard extends StatelessWidget {
  final int index;
  final String hour;
  final String minute;
  final TextEditingController headCountController;
  final TextEditingController signatureController;
  final TextEditingController commentsController;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final Function(String?) onHourChanged;
  final Function(String?) onMinuteChanged;
  final Function() onSave;
  final Function() onCancel;

  const HeadCheckCard({
    super.key,
    required this.index,
    required this.hour,
    required this.minute,
    required this.headCountController,
    required this.signatureController,
    required this.commentsController,
    this.onAdd,
    this.onRemove,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onSave,
    required this.onCancel,
  });

  static final List<String> hours =
      List<String>.generate(12, (counter) => "${counter + 1}h");
  static final List<String> minutes =
      List<String>.generate(60, (counter) => "${counter}m");

  @override
  Widget build(BuildContext context) {
    return PatternBackground(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Time',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onAdd,
                ),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: onRemove,
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    height: 40,
                    value: hour,
                    items: hours,
                    onChanged: onHourChanged,
                    hint: 'Select',

                    // displayText: (value) => value,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomDropdown(
                    height: 40,
                    value: minute,
                    items: minutes,
                    onChanged: onMinuteChanged,
                    hint: 'Select',
                    // displayText: (value) => value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Head Count',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 5),
            CustomTextFormWidget(
              maxLines: 1,
              keyboardType: TextInputType.number,
              controller: headCountController,
            ),
            const SizedBox(height: 15),
            Text(
              'Signature',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 5),
            CustomTextFormWidget(
              maxLines: 1,
              controller: signatureController,
            ),
            const SizedBox(height: 15),
            Text(
              'Comments',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 5),
            CustomTextFormWidget(
              maxLines: 2,
              controller: commentsController,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: onCancel,
                  child: Text(
                    'CANCEL',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 16),
                CustomButton(
                  height: 40,
                  width: 100,
                  text: 'SAVE',
                  ontap: onSave,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DatePickerButton extends StatelessWidget {
  final DateTime? date;
  final Function(DateTime) onDateSelected;

  const DatePickerButton({
    super.key,
    required this.date,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2, borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primaryColor,width: 1.5),
          borderRadius: BorderRadius.circular(5)
        ),
        height: 40,
        width: 140,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Text(
                date != null ? DateFormat("dd-MM-yyyy").format(date!) : '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date ?? DateTime.now(),
                    firstDate: DateTime(1800),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    onDateSelected(selectedDate);
                  }
                },
                child:const Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isPrimary ? null : 80,
        height: 38,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryColor : null,
          border: isPrimary ? null : Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: EdgeInsets.all(isPrimary ? 8.0 : 10.0),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: isPrimary ? Colors.white : Colors.black,
                ),
          ),
        ),
      ),
    );
  }
}
