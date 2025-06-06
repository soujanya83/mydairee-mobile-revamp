import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydiaree/core/config/app_colors.dart';

class ProfileImagePicker extends StatelessWidget {
  final XFile? selectedImage;
  final Function(XFile?) onImagePicked;

  const ProfileImagePicker({
    super.key,
    required this.selectedImage,
    required this.onImagePicked,
  });

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onImagePicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primaryColor.withOpacity(0.2),
          backgroundImage: selectedImage != null
              ? Image.file(
                  File(selectedImage!.path),
                  fit: BoxFit.cover,
                ).image
              : null,
          child: selectedImage == null
              ? const Icon(Icons.person, size: 40, color: AppColors.primaryColor)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.primaryColor,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
