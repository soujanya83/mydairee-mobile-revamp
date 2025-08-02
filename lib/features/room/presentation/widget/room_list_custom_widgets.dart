import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/hexconversion.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
class RoomCard extends StatelessWidget {
  final String roomId;
  final String roomName;
  final Color roomColor;
  final String userName;
  final String status;
  final List<String> educators;
  final bool isSelected;
  final bool permissionUpdate;
  final Function(bool) onSelectionChanged;
  final VoidCallback? onEditPressed;

  const RoomCard({
    required this.roomId,
    required this.roomName,
    required this.roomColor,
    required this.userName,
    required this.status,
    required this.educators,
    required this.isSelected,
    required this.permissionUpdate,
    required this.onSelectionChanged,
      this.onEditPressed,
  });

  Color _safeHexColor(String? color) {
    try {
      return HexColor(color ?? "#FFFFFF");
    } catch (e) {
      return HexColor("#FFFFFF"); // Default to white on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: PatternBackground(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  roomColor,
                  Colors.transparent,
                ],
                stops: const [0.02, 0.02],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          roomName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (onEditPressed != null && permissionUpdate)
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: onEditPressed,
                        ),
                      Checkbox(
                        value: isSelected,
                        fillColor:
                            WidgetStateProperty.all(AppColors.primaryColor),
                        onChanged: (val) => onSelectionChanged(val ?? false),
                        overlayColor:
                            WidgetStateProperty.all(AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.child_care, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        educators.isNotEmpty
                            ? educators.length.toString()
                            : '0',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: AppColors.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Text(' (Lead)', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  void showDeleteConfirmationDialog(BuildContext context, 
  void Function()? onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Items?"),
          content: const Text("This action cannot be undone."),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text("Delete"),
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }
