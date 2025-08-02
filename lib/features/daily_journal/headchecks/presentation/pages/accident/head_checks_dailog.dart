import 'package:flutter/material.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';

class HeadCheckEditDialog extends StatefulWidget {
  final String? hour;
  final String? minute;
  final String? headCount;
  final String? signature;
  final String? comments;
  final void Function(String hour, String minute, String headCount, String signature, String comments) onSave;

  const HeadCheckEditDialog({
    super.key,
    this.hour,
    this.minute,
    this.headCount,
    this.signature,
    this.comments,
    required this.onSave,
  });

  @override
  State<HeadCheckEditDialog> createState() => _HeadCheckEditDialogState();
}

class _HeadCheckEditDialogState extends State<HeadCheckEditDialog> {
  late TextEditingController headCountController;
  late TextEditingController signatureController;
  late TextEditingController commentsController;
  String? hour;
  String? minute;

  static final List<String> hours = List<String>.generate(12, (counter) => "${counter + 1}h");
  static final List<String> minutes = List<String>.generate(60, (counter) => "${counter}m");

  @override
  void initState() {
    super.initState();
    hour = widget.hour;
    minute = widget.minute;
    headCountController = TextEditingController(text: widget.headCount ?? '');
    signatureController = TextEditingController(text: widget.signature ?? '');
    commentsController = TextEditingController(text: widget.comments ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.hour == null ? 'Add Head Check' : 'Edit Head Check'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    height: 40,
                    value: hour,
                    items: hours,
                    onChanged: (val) => setState(() => hour = val),
                    hint: 'Hour',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown<String>(
                    height: 40,
                    value: minute,
                    items: minutes,
                    onChanged: (val) => setState(() => minute = val),
                    hint: 'Minute',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextFormWidget(
              controller: headCountController,
              hintText: 'Head Count',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            CustomTextFormWidget(
              controller: signatureController,
              hintText: 'Signature',
            ),
            const SizedBox(height: 12),
            CustomTextFormWidget(
              controller: commentsController,
              hintText: 'Comments',
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          height: 40,
          width: 100,
          text: 'SAVE',
          ontap: () {
            if (hour != null && minute != null) {
              widget.onSave(
                hour!,
                minute!,
                headCountController.text,
                signatureController.text,
                commentsController.text,
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}