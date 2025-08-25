import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/snapshot/presentation/widget/snapshot_custom.dart';
import 'package:mydiaree/main.dart';
import 'package:mydiaree/features/observation/data/repositories/observation_repositories.dart';
import 'package:mydiaree/features/observation/data/model/observation_detail_model.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';

class ObservationPrintScreen extends StatefulWidget {
  final String observationId;

  const ObservationPrintScreen({
    super.key,
    required this.observationId,
  });

  @override
  State<ObservationPrintScreen> createState() => _ObservationPrintScreenState();
}

class _ObservationPrintScreenState extends State<ObservationPrintScreen> {
  final ObservationRepository _repository = ObservationRepository();
  ObservationDetailData? _observationData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchObservationDetail();
  }

  Future<void> _fetchObservationDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final ApiResponse<ObservationDetailData?> response = await _repository
          .viewObservationDetail(observationId: widget.observationId);

      if (response.success && response.data != null) {
        setState(() {
          _observationData = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? 'Failed to load observation details';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Child\'s Observation'),
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
                        onPressed: _fetchObservationDetail,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _observationData == null
                  ? const Center(child: Text('No data available'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Header Section
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Logo and Title
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
                                      'Child\'s Observation',
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
                              _buildInfoCard(
                                  'Child Information', _getChildInfoItems()),
                              const SizedBox(height: 16),

                              _buildInfoCard('Observation Details',
                                  _getObservationDetailsItems()),
                              const SizedBox(height: 16),

                              // Child's Photos Section
                              _buildPhotoGalleryCard(),
                              const SizedBox(height: 16),

                              // Observation Text
                              _buildTextCard('Observation',
                                  _observationData!.getCleanNotes()),
                              const SizedBox(height: 16),

                              // EYLF Outcomes Section
                              _buildEylfOutcomesCard(),
                              const SizedBox(height: 16),

                              // Analysis/Evaluation
                              _buildTextCard('Analysis/Evaluation',
                                  _observationData!.getCleanNotes()),
                              const SizedBox(height: 16),

                              // Reflection
                              _buildTextCard('Reflection',
                                  _observationData!.reflection ?? ''),
                              const SizedBox(height: 16),

                              // Child's Voice
                              _buildTextCard(
                                  'Child\'s Voice',
                                  _observationData!.childVoice?.toString() ??
                                      ''),
                              const SizedBox(height: 16),

                              // Montessori Assessment
                              _buildMontessoriAssessmentCard(),
                              const SizedBox(height: 16),

                              // Development Milestones
                              _buildDevelopmentMilestonesCard(),
                              const SizedBox(height: 16),

                              // Future Plan/Extension
                              _buildTextCard(
                                  'Future Plan/Extension',
                                  _observationData!.futurePlan?.toString() ??
                                      ''),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }

  List<Map<String, String>> _getChildInfoItems() {
    if (_observationData?.child.isEmpty ?? true) {
      return [
        {'label': 'Child\'s Name', 'value': 'No child data available'},
        {'label': 'Date', 'value': _observationData?.dateAdded ?? ''},
        {'label': 'Educator\'s Name', 'value': 'N/A'},
        {
          'label': 'Classroom',
          'value': _observationData?.room?.toString() ?? 'N/A'
        },
      ];
    }

    final child = _observationData!.child.first.child;
    return [
      {'label': 'Child\'s Name', 'value': child.getFullName()},
      {'label': 'Date', 'value': _observationData!.dateAdded},
      {
        'label': 'Educator\'s Name',
        'value': 'Deepti'
      }, // This might need to come from user data
      {
        'label': 'Classroom',
        'value': _observationData!.room?.toString() ?? 'N/A'
      },
    ];
  }

  List<Map<String, String>> _getObservationDetailsItems() {
    return [
      {'label': 'Title', 'value': _observationData!.getCleanTitle()},
    ];
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
                              '${item['label']}:',
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
      width: screenWidth * .95,
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
              stripHtml(content),
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
    final List<String> imageUrls = _observationData!.media
        .map((media) => '${AppUrls.baseUrl}/${media.mediaUrl}')
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
    if (_observationData!.eylfLinks.isEmpty) {
      return PatternBackground(
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
              const Text('No EYLF outcomes selected for this observation.'),
            ],
          ),
        ),
      );
    }

    // Group EYLF links by outcome
    final Map<String, Map<String, List<EylfLink>>> groupedOutcomes = {};

    for (final link in _observationData!.eylfLinks) {
      final outcome = link.subActivity.activity.outcome;
      final activity = link.subActivity.activity;

      groupedOutcomes[outcome.title] ??= {};
      groupedOutcomes[outcome.title]![activity.title] ??= [];
      groupedOutcomes[outcome.title]![activity.title]!.add(link);
    }

    return PatternBackground(
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
            ...groupedOutcomes.entries.map((outcomeEntry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...outcomeEntry.value.entries.map((activityEntry) {
                    return _buildOutcomeSection(
                      outcomeEntry.key,
                      activityEntry.key,
                      activityEntry.value
                          .map((link) => link.subActivity.title)
                          .toList(),
                    );
                  }).toList(),
                  if (outcomeEntry.key != groupedOutcomes.keys.last)
                    const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeSection(
      String outcomeTitle, String outcomeDescription, List<String> activities) {
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
        Text(
          '- $outcomeDescription',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        ...activities
            .map((activity) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 2),
                  child: Text(
                    '• $activity',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildMontessoriAssessmentCard() {
    if (_observationData!.montessoriLinks.isEmpty) {
      return PatternBackground(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Montessori Assessment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text('No Montessori assessments for this observation.'),
            ],
          ),
        ),
      );
    }

    // Group by subject
    final Map<String, List<MontessoriLink>> groupedBySubject = {};

    for (final link in _observationData!.montessoriLinks) {
      final subject = link.subActivity.activity.subject.name;
      groupedBySubject[subject] ??= [];
      groupedBySubject[subject]!.add(link);
    }

    return PatternBackground(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Montessori Assessment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...groupedBySubject.entries.map((entry) {
              final skills = entry.value
                  .map((link) => {
                        'skill':
                            '${link.subActivity.activity.title} - ${link.subActivity.title}',
                        'level': link.assessment,
                      })
                  .toList();

              return _buildMontessoriSection(entry.key, skills);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMontessoriSection(
      String sectionTitle, List<Map<String, String>> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...skills
            .map((skill) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold)),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '${skill['skill']} ',
                            style: const TextStyle(color: Colors.black87),
                            children: [
                              TextSpan(
                                text: '(${skill['level']})',
                                style: TextStyle(
                                  color: _getLevelColor(skill['level'] ?? ''),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildDevelopmentMilestonesCard() {
    if (_observationData!.devMilestoneSubs.isEmpty) {
      return PatternBackground(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Development Milestones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text('No development milestones for this observation.'),
            ],
          ),
        ),
      );
    }

    // Group by age group and category
    final Map<String, Map<String, List<DevMilestoneSub>>> groupedMilestones =
        {};

    for (final milestone in _observationData!.devMilestoneSubs) {
      final ageGroup = milestone.devMilestone.milestone.ageGroup;
      final category = milestone.devMilestone.main.name;

      groupedMilestones[ageGroup] ??= {};
      groupedMilestones[ageGroup]![category] ??= [];
      groupedMilestones[ageGroup]![category]!.add(milestone);
    }

    return PatternBackground(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Development Milestones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...groupedMilestones.entries.map((ageEntry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...ageEntry.value.entries.map((categoryEntry) {
                    final milestones = categoryEntry.value
                        .map((milestone) => {
                              'milestone': milestone.devMilestone.name,
                              'level': milestone.assessment,
                            })
                        .toList();

                    return _buildMilestoneSection(
                      ageEntry.key,
                      categoryEntry.key,
                      milestones,
                    );
                  }).toList(),
                  if (ageEntry.key != groupedMilestones.keys.last)
                    const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneSection(
      String ageGroup, String category, List<Map<String, String>> milestones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ageGroup,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '- $category',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        ...milestones
            .map((milestone) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 2),
                  child: RichText(
                    text: TextSpan(
                      text: '• ${milestone['milestone']} ',
                      style: const TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: '(${milestone['level']})',
                          style: TextStyle(
                            color: _getLevelColor(milestone['level'] ?? ''),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'completed':
      case 'achieved':
        return Colors.green;
      case 'working':
      case 'working towards':
        return Colors.orange;
      case 'introduced':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
