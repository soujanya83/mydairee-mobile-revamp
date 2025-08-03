import 'package:flutter/material.dart'; 
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_view_model.dart';
import 'package:mydiaree/features/annaunce/data/repositories/announcement_repositories.dart';
import 'package:mydiaree/features/annaunce/presentation/pages/add_announcement_screen.dart';

class ViewAnnouncementScreen extends StatefulWidget {
  final String announcementId;

  const ViewAnnouncementScreen({
    super.key,
    required this.announcementId,
  });

  @override
  State<ViewAnnouncementScreen> createState() => _ViewAnnouncementScreenState();
}

class _ViewAnnouncementScreenState extends State<ViewAnnouncementScreen> {
  final AnnoucementRepository _repository = AnnoucementRepository();
  bool isLoading = true;
  Info? announcementInfo;

  @override
  void initState() {
    super.initState();
    _loadAnnouncementDetails();
  }

  Future<void> _loadAnnouncementDetails() async {
    setState(() => isLoading = true);
    
    try {
      final response = await _repository.viewAnnouncement(
        announcementId: widget.announcementId,
      );
      
      if (response.success && response.data?.data?.info != null) {
        setState(() {
          announcementInfo = response.data!.data!.info;
        });
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      UIHelpers.showToast(
        context,
        message: 'Failed to load announcement details',
        backgroundColor: AppColors.errorColor,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteAnnouncement() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this announcement?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              
              setState(() => isLoading = true);
              
              try {
                final response = await _repository.deleteAnnouncement(
                  announcementId: widget.announcementId,
                  userId: '1', // Replace with actual user ID from auth
                );
                
                setState(() => isLoading = false);
                
                if (response.success) {
                  UIHelpers.showToast(
                    context,
                    message: 'Announcement deleted successfully',
                    backgroundColor: AppColors.successColor,
                  );
                  Navigator.pop(context); // Return to list
                } else {
                  UIHelpers.showToast(
                    context,
                    message: response.message,
                    backgroundColor: AppColors.errorColor,
                  );
                }
              } catch (e) {
                setState(() => isLoading = false);
                UIHelpers.showToast(
                  context,
                  message: 'Failed to delete announcement',
                  backgroundColor: AppColors.errorColor,
                );
              }
            },
            child: const Text("DELETE"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: "Announcement Details",
        actions: [
          if (!isLoading && announcementInfo != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAnnouncementScreen(
                      screenType: 'edit',
                      centerId: announcementInfo!.centerid.toString(),
                      announcementId: widget.announcementId,
                    ),
                  ),
                ).then((_) => _loadAnnouncementDetails());
              },
            ),
          if (!isLoading && announcementInfo != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteAnnouncement,
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : announcementInfo == null
              ? const Center(child: Text('Announcement not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                          announcementInfo!.title ?? '',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            announcementInfo!.eventDate ?? 'No date',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                          const Icon(Icons.person, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Created by: ${announcementInfo!.username ?? announcementInfo!.createdBy ?? 'Unknown'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Created: ${announcementInfo!.createdAt ?? 'Unknown date'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                          Icon(
                            Icons.check_circle, 
                            size: 16,
                            color: announcementInfo!.status == 'Sent' 
                              ? AppColors.successColor 
                              : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Status: ${announcementInfo!.status ?? 'Unknown'}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: announcementInfo!.status == 'Sent' 
                              ? AppColors.successColor 
                              : Colors.orange,
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                          ],
                        ),
                        ],
                      ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Content
                      Text(
                      'Announcement Content',
                      style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        minWidth: 40,
                        maxHeight: 80,
                        maxWidth: 200,
                      ),
                      child: _buildContent(announcementInfo!.text),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Actions
                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                        width: 80,
                        height: 36,
                        text: 'Edit', 
                        ontap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAnnouncementScreen(
                            screenType: 'edit',
                            centerId: announcementInfo!.centerid.toString(),
                            announcementId: widget.announcementId,
                            ),
                          ),
                          ).then((_) => _loadAnnouncementDetails());
                        },
                        ),
                        const SizedBox(width: 8),
                        CustomButton(
                        width: 80,
                        height: 36,
                        color: AppColors.errorColor,
                        text: 'Delete', 
                        ontap: _deleteAnnouncement,
                        ),
                      ],
                      ),
                    ],
                  ),
                ),
    );
  }
  
  Widget _buildContent(String? content) {
    if (content == null || content.isEmpty) {
      return const Text('No content available');
    }
    
    return Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
        ),
      );
  }
}