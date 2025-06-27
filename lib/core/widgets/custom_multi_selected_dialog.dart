import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';

class CustomMultiSelectDialog extends StatefulWidget {
  final List<String> itemsId;
  final List<String> itemsName;
  final List<String> initiallySelectedIds;
  final String title;
  final Function(List<String>) onItemTap;

  const CustomMultiSelectDialog({
    super.key,
    required this.itemsId,
    required this.itemsName,
    this.initiallySelectedIds = const [],
    required this.title,
    required this.onItemTap,
 });

  @override
  State<CustomMultiSelectDialog> createState() =>
      _CustomMultiSelectDialogState();
}

class _CustomMultiSelectDialogState extends State<CustomMultiSelectDialog> {
  late List<String> selectedIds;

  @override
  void initState() {
    super.initState();
    selectedIds = List<String>.from(widget.initiallySelectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.itemsId.length,
                  itemBuilder: (context, index) {
                    final id = widget.itemsId[index];
                    final name = widget.itemsName[index];
                    final isChecked = selectedIds.contains(id);
                    return CheckboxListTile(
                      value: isChecked,
                      title: Text(name),
                      activeColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onChanged: (val) {
                        print(selectedIds.toString());
                        print(val.toString());
                        setState(() {
                          if (val == true) {
                            if (!selectedIds.contains(id)) {
                              selectedIds.add(id);
                            }
                          } else {
                            selectedIds.removeWhere((element) => element == id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    widget.onItemTap(selectedIds); // <-- Call the callback
                    Navigator.pop(context);
                  },
                  child:
                      const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
