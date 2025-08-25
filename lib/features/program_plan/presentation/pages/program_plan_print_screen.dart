import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_print_model.dart';
import 'package:mydiaree/features/program_plan/data/repositories/program_plan_repository.dart';
import 'package:mydiaree/features/snapshot/presentation/widget/snapshot_custom.dart';
import 'package:mydiaree/main.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';

class ProgramPlanPrintScreen extends StatefulWidget {
  final String id;
  
  const ProgramPlanPrintScreen({
    super.key, 
    required this.id,
  });

  @override
  State<ProgramPlanPrintScreen> createState() => _ProgramPlanPrintScreenState();
}

class _ProgramPlanPrintScreenState extends State<ProgramPlanPrintScreen> {
  final ProgramPlanRepository _repository = ProgramPlanRepository();
  ProgramPlanPrintResponse? _programPlanData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProgramPlanData();
  }

  Future<void> _fetchProgramPlanData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final ApiResponse<ProgramPlanPrintResponse?> response = 
          await _repository.getProgramPlanForPrint(planId: widget.id);

      if (response.success && response.data != null) {
        setState(() {
          _programPlanData = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? 'Failed to load program plan details';
          _isLoading = false;
        });
      }

    } catch (e) {
      setState(() {
        _error = 'Failed to load program plan details';
        _isLoading =
         false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Program Plan View'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchProgramPlanData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _programPlanData == null
                  ? const Center(child: Text('No data available'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Page 1
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Header
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
                                    RichText(
                                      text: TextSpan(
                                        text: 'PROGRAM PLAN ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: '${_programPlanData!.monthName} ${_programPlanData!.plan.years}',
                                            style: const TextStyle(
                                              color: Color(0xFF22b1c4),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Basic Info Cards
                              _buildInfoCard('Room Details', [
                                {'label': 'Room Name', 'value': stripHtml(_programPlanData!.roomName)},
                                {'label': 'Focus Area', 'value': stripHtml(_programPlanData!.plan.focusArea ?? 'Not specified')},
                              ]),
                              const SizedBox(height: 12),

                              _buildInfoCard('Staff & Children', [
                                {'label': 'Educators', 'value': stripHtml(_programPlanData!.educatorNames)},
                                {'label': 'Children', 'value': stripHtml(_programPlanData!.childrenNames)},
                              ]),
                              const SizedBox(height: 16),

                              // Learning Areas Section
                              Text(
                                'Learning Areas',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                              ),
                              const SizedBox(height: 12),

                              // Dynamic Learning Areas
                              if (_programPlanData!.plan.practicalLife.isNotEmpty)
                                _buildLearningAreaCardFromText(
                                  'Practical Life',
                                  stripHtml(_programPlanData!.plan.practicalLife),
                                ),

                              if (_programPlanData!.plan.sensorial.isNotEmpty)
                                _buildLearningAreaCardFromText(
                                  'Sensorial',
                                  stripHtml(_programPlanData!.plan.sensorial),
                                ),

                              if (_programPlanData!.plan.math.isNotEmpty)
                                _buildLearningAreaCardFromText(
                                  'Math',
                                  stripHtml(_programPlanData!.plan.math),
                                ),

                              if (_programPlanData!.plan.language.isNotEmpty)
                                _buildLearningAreaCardFromText(
                                  'Language',
                                  stripHtml(_programPlanData!.plan.language),
                                ),

                              if (_programPlanData!.plan.culture.isNotEmpty)
                                _buildLearningAreaCardFromText(
                                  'Culture',
                                  stripHtml(_programPlanData!.plan.culture),
                                ),

                              if (_programPlanData!.plan.artCraftExperiences?.isNotEmpty == true)
                                _buildLearningAreaCardFromText(
                                  'Art & Craft',
                                  stripHtml(_programPlanData!.plan.artCraftExperiences!),
                                ),

                              const SizedBox(height: 20),

                              // EYLF Section
                              if (_programPlanData!.plan.eylf.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('EYLF:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 12),
                                      Text(
                                        stripHtml(_formatEylfText(_programPlanData!.plan.eylf)),
                                        style: const TextStyle(height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 20),

                              // Footer
                              const Center(
                                child: Text(
                                  '1 Capricorn Road, Truganina, VIC 3029',
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Page 2
                        PatternBackground(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Header
                                Center(
                                  child: Image.network(
                                    '${AppUrls.baseUrl}/assets/profile_1739442700.jpeg',
                                    width: 120,
                                    height: 105,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Outdoor Experiences
                                if (_programPlanData!.plan.outdoorExperiences?.isNotEmpty == true)
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Outdoor Experiences:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 12),
                                        Text(stripHtml(_programPlanData!.plan.outdoorExperiences!)),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 20),

                                // Topics Section
                                _buildInfoCard('Topics & Events', [
                                  {'label': 'Inquiry Topic', 'value': stripHtml(_programPlanData!.plan.inquiryTopic ?? 'Not specified')},
                                  {'label': 'Sustainability Topic', 'value': stripHtml(_programPlanData!.plan.sustainabilityTopic ?? 'Not specified')},
                                  {'label': 'Special Events', 'value': stripHtml(_programPlanData!.plan.specialEvents ?? 'Not specified')},
                                ]),
                                const SizedBox(height: 16),

                                // Voices & Input Section
                                _buildInfoCard('Community Input', [
                                  {'label': "Children's Voices", 'value': stripHtml(_programPlanData!.plan.childrenVoices ?? 'Not specified')},
                                  {'label': 'Families Input', 'value': stripHtml(_programPlanData!.plan.familiesInput ?? 'Not specified')},
                                ]),
                                const SizedBox(height: 16),

                                // Experiences Section
                                _buildInfoCard('Learning Experiences', [
                                  {'label': 'Group Experience', 'value': stripHtml(_programPlanData!.plan.groupExperience ?? 'Not specified')},
                                  {'label': 'Spontaneous Experience', 'value': stripHtml(_programPlanData!.plan.spontaneousExperience ?? 'Not specified')},
                                  {'label': 'Mindfulness Experiences', 'value': stripHtml(_programPlanData!.plan.mindfulnessExperiences ?? 'Not specified')},
                                ]),
                                const SizedBox(height: 20),

                                // Footer
                                const Center(
                                  child: Text(
                                    '1 Capricorn Road, Truganina, VIC 3029',
                                    style: TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  String _formatEylfText(String eylf) {
    // Replace line breaks and format the EYLF text
    return eylf
        .replaceAll('\r\n', '\n')
        .replaceAll('Outcome ', '\nOutcome ')
        .trim();
  }

  Widget _buildLearningAreaCardFromText(String area, String content) {
    final sections = _parseFormattedText(content);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PatternBackground(
        elevation: 2,
        width: screenWidth * 0.95,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  area,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...sections.map((section) => _buildSection(section)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section['title']?.isNotEmpty == true) ...[
          Text(
            stripHtml(section['title']),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (section['items']?.isNotEmpty == true) ...[
          ...section['items'].map<Widget>((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                        child: Text(stripHtml(item),
                            style: const TextStyle(color: Colors.black87))),
                  ],
                ),
              )).toList(),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  List<Map<String, dynamic>> _parseFormattedText(String content) {
    final sections = <Map<String, dynamic>>[];
    final lines = content.split('\r\n');
    
    String? currentTitle;
    List<String> currentItems = [];
    
    for (String line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;
      
      // Check if line is a title (starts with ** and ends with ** -)
      if (trimmedLine.startsWith('**') && trimmedLine.contains('** -')) {
        // Save previous section
        if (currentTitle != null) {
          sections.add({
            'title': currentTitle,
            'items': List<String>.from(currentItems),
          });
        }
        
        // Extract new title and strip HTML
        currentTitle = stripHtml(trimmedLine
            .replaceAll('**', '')
            .replaceAll(' -', '')
            .trim());
        currentItems.clear();
      } else if (trimmedLine.startsWith('**• **')) {
        // This is an item and strip HTML
        final item = stripHtml(trimmedLine
            .replaceAll('**• **', '')
            .replaceAll('**', '')
            .trim());
        if (item.isNotEmpty) {
          currentItems.add(item);
        }
      }
    }
    
    // Add the last section
    if (currentTitle != null) {
      sections.add({
        'title': currentTitle,
        'items': List<String>.from(currentItems),
      });
    }
    
    return sections;
  }

  Widget _buildInfoCard(String title, List<Map<String, String>> items) {
    return PatternBackground(
      elevation: 2,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                            width: 100,
                            child: Text(
                              '${stripHtml(item['label']??'')}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              stripHtml(item['value'] ?? ''),
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

  Widget _buildPhotoGalleryCard() {
    final ScrollController scrollController = ScrollController();
    final List<String> imageUrls = [
      'https://mydiaree.com.au/assets/img/profile_1739442700.jpeg',
      'https://mydiaree.com.au/uploads/Reflections/1755620263_68a4a3a74dde7.jpg',
      'https://mydiaree.com.au/assets/img/profile_1739442700.jpeg',
      'https://mydiaree.com.au/uploads/Reflections/1755620263_68a4a3a74dde7.jpg',
      'https://mydiaree.com.au/assets/img/profile_1739442700.jpeg',
      'https://mydiaree.com.au/uploads/Reflections/1755620263_68a4a3a74dde7.jpg',
    ];

    return PatternBackground(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Program Photos',
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
}
