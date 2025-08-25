import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/reflection/data/model/reflection_print_model.dart'
    hide Center;
import 'package:mydiaree/features/reflection/data/repositories/reflection_repository.dart';
import 'package:mydiaree/features/snapshot/presentation/widget/snapshot_custom.dart';
import 'package:mydiaree/main.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';

class ReflectionPrintScreen extends StatefulWidget {
  final String reflectionId;

  const ReflectionPrintScreen({
    super.key,
    required this.reflectionId,
  });

  @override
  State<ReflectionPrintScreen> createState() => _ReflectionPrintScreenState();
}

class _ReflectionPrintScreenState extends State<ReflectionPrintScreen> {
  final ReflectionRepository _repository = ReflectionRepository();
  ReflectionPrintResponse? _reflectionData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchReflectionData();
  }

  Future<void> _fetchReflectionData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final ApiResponse<ReflectionPrintResponse?> response = await _repository
          .getReflectionForPrint(reflectionId: widget.reflectionId);

      if (response.success && response.data != null) {
        setState(() {
          _reflectionData = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? 'Failed to load reflection details';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load reflection details';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Daily Reflection'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchReflectionData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _reflectionData == null
                  ? const Center(child: Text('No data available'))
                  : ListView(
                      padding: const EdgeInsets.all(8),
                      children: [
                        // Header Section
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Image.network(
                                      '${AppUrls.baseUrl}/assets/profile_1739442700.jpeg',
                                      width: 120,
                                      height: 105,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Daily Reflection',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                          ),
                                    ),
                                    const Divider(thickness: 2),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Basic Information Cards
                              _buildInfoCard('Reflection Information', [
                                {
                                  'label': 'Children Name',
                                  'value': _getChildrenNames(),
                                },
                                {
                                  'label': 'Date',
                                  'value': _formatDate(
                                      _reflectionData!.reflection.createdAt),
                                },
                                {
                                  'label': 'Educator\'s Name',
                                  'value': _getEducatorNames(),
                                },
                                {
                                  'label': 'Classroom',
                                  'value':
                                      stripHtml(_reflectionData!.roomNames),
                                },
                              ]),
                              const SizedBox(height: 16),

                              // Daily Reflection Text
                              _buildTextCard('Daily Reflection',
                                  stripHtml(_reflectionData!.reflection.about)),
                              const SizedBox(height: 16),

                              // Child's Photos Section
                              _buildPhotoGalleryCard(),
                              const SizedBox(height: 16),

                              // EYLF Outcomes Section
                              _buildEylfOutcomesCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }

  String _getChildrenNames() {
    return _reflectionData!.reflection.children
        .map((child) => stripHtml(child.childDetails.getFullName()))
        .join(', ');
  }

  String _getEducatorNames() {
    return _reflectionData!.reflection.staff
        .map((staff) => stripHtml(staff.staffDetails.name))
        .join(', ');
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }

  Widget _buildInfoCard(String title, List<Map<String, String>> items) {
    return PatternBackground(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '${stripHtml(item['label'] ?? '')}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item['value'] ?? '',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextCard(String title, String content) {
    return PatternBackground(
      width: screenWidth * 0.95,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGalleryCard() {
    final ScrollController scrollController = ScrollController();
    final List<String> imageUrls = _reflectionData!.reflection.media
        .map((media) => media.getFullMediaUrl())
        .where((url) => url.isNotEmpty)
        .toList();

    if (imageUrls.isEmpty) {
      return PatternBackground(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Child\'s Photos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 150,
                alignment: Alignment.center,
                child: const Text('No photos available'),
              ),
            ],
          ),
        ),
      );
    }

    return PatternBackground(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Child\'s Photos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      final imageUrl = imageUrls[index];

                      return GestureDetector(
                        onTap: () => _showImageDialog(context, imageUrl),
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 48,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (imageUrls.length > 2) ...[
                  // Left arrow
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black45, Colors.transparent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          scrollController.animateTo(
                            scrollController.offset - 120,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Right arrow
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black45],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          scrollController.animateTo(
                            scrollController.offset + 120,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 48,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEylfOutcomesCard() {
    final String eylfText = stripHtml(_reflectionData!.reflection.eylf);

    if (eylfText.isEmpty) {
      return PatternBackground(
        width: screenWidth * 0.95,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'EYLF Outcomes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text('No EYLF outcomes selected for this reflection.'),
            ],
          ),
        ),
      );
    }

    // Parse the EYLF text to extract outcomes and activities
    final List<Map<String, dynamic>> outcomes = _parseEylfText(eylfText);

    return PatternBackground(
      width: screenWidth * 0.95,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EYLF Outcomes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...outcomes.map((outcome) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOutcomeSection(outcome['title'], outcome['activities']),
                  if (outcome != outcomes.last) const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _parseEylfText(String eylfText) {
    final List<Map<String, dynamic>> outcomes = [];
    final lines = eylfText.split('\r\n');

    String? currentOutcome;
    List<String> currentActivities = [];

    for (String line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      if (trimmedLine.startsWith('Outcome ')) {
        // Save previous outcome
        if (currentOutcome != null) {
          outcomes.add({
            'title': currentOutcome,
            'activities': List<String>.from(currentActivities),
          });
        }

        // Start new outcome
        final parts = trimmedLine.split(': ');
        if (parts.length >= 2) {
          currentOutcome = parts[0].trim();
          currentActivities = [parts.sublist(1).join(': ').trim()];
        } else {
          currentOutcome = trimmedLine;
          currentActivities = [];
        }
      } else {
        // This is a continuation or activity under current outcome
        if (currentActivities.isNotEmpty) {
          currentActivities[currentActivities.length - 1] += ' $trimmedLine';
        } else {
          currentActivities.add(trimmedLine);
        }
      }
    }

    // Add the last outcome
    if (currentOutcome != null) {
      outcomes.add({
        'title': currentOutcome,
        'activities': List<String>.from(currentActivities),
      });
    }

    return outcomes;
  }

  Widget _buildOutcomeSection(String outcomeTitle, List<String> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          outcomeTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...activities
            .map((activity) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          activity,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}
