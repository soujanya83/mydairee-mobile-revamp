import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/observation/data/model/observation_detail_model.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_bloc.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_event.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_state.dart';
import 'package:mydiaree/features/observation/presentation/pages/add_observation/add_observation_screen.dart';
import 'package:mydiaree/features/observation/presentation/widget/view_observation_custom_widgets.dart';

class ViewObservationScreen extends StatefulWidget {
  final String id;

  const ViewObservationScreen({
    required this.id,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ViewObservationScreenState createState() => _ViewObservationScreenState();
}

class _ViewObservationScreenState extends State<ViewObservationScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }




  Widget _buildHeader(
    String? observationTitle,
    String? observationId,
    String? centerId,
  ) {
    final isParent = UserTypeHelper.isParent;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(

            child: Text(




              'Observation Details',
              // _cleanHtmlContent(observationTitle ?? 'Observation Details'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
            ),
          ),
         






          if (!UserTypeHelper.isParent)
            CustomButton(
              text: 'Edit',
              height: 35,
              width: 70,
              borderRadius: 10,
              ontap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddObservationScreen(
                    id: observationId ?? '',
                    type: 'edit',
                    centerId: centerId ?? '',
                  );
                }));
              },
            ),
        ],
      ),
    );
  }

  

  String _cleanHtmlContent(String htmlContent) {
    final decodedEntities = htmlContent
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'");

    return decodedEntities.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  Widget _buildSection(String title, String? content) {
    if (content == null || content.trim().isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryColor,
                ),
          ),
          const SizedBox(height: 8),
          PatternBackground(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Text(
              _cleanHtmlContent(content),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildTab(ObservationDetailData observation) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Child Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: observation.child.map((childItem) {
              final child = childItem.child;
              return ChildCard(
                childName: '${child.name} ${child.lastname}',
                age: _calculateAge(child.dob),
                dob: child.dob,
                imageUrl: 'https://mydiaree.com.au/${child.imageUrl}',
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  int _calculateAge(String dob) {
    if (dob.isEmpty || dob == '0000-00-00') return 0;

    try {
      final birthDate = DateTime.parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildMontessoriTab(ObservationDetailData observation) {
    if (observation.montessoriLinks.isEmpty) {
      return _buildEmptyTab('Montessori assessments', Icons.school);
    }

    // Count assessments by status
    int notAssessedCount = 0;
    int introducedCount = 0;
    int workingCount = 0;
    int completedCount = 0;

    for (var link in observation.montessoriLinks) {
      switch (link.assessment.toLowerCase()) {
        case 'not assessed':
          notAssessedCount++;
          break;
        case 'introduced':
          introducedCount++;
          break;
        case 'working':
          workingCount++;
          break;
        case 'completed':
          completedCount++;
          break;
      }
    }

    // Group by subject
    final Map<String, List<MontessoriLink>> groupedBySubject = {};
    for (var link in observation.montessoriLinks) {
      final subjectName = link.subActivity.activity.subject.name;
      if (!groupedBySubject.containsKey(subjectName)) {
        groupedBySubject[subjectName] = [];
      }
      groupedBySubject[subjectName]!.add(link);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with icon
          Row(
            children: [
              Icon(Icons.school, color: Colors.amber, size: 22),
              const SizedBox(width: 8),
              Text(
                'Montessori Assessment',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Assessment summary cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.red, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        notAssessedCount.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Not Assessed',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        introducedCount.toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Introduced',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.amber, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        workingCount.toString(),
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Working',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        completedCount.toString(),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Subject groups
          ...groupedBySubject.entries.map((entry) {
            final subjectName = entry.key;
            final subjectLinks = entry.value;
            final itemCount = subjectLinks.length;

            return Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject header
                  Row(
                    children: [
                      Icon(Icons.book, color: Colors.brown, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        subjectName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$itemCount items',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Assessment items
                  ...subjectLinks.map((link) {
                    final Color statusColor =
                        _getAssessmentColor(link.assessment);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  link.subActivity.activity.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        link.subActivity.title,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Status badge with new styling
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: statusColor,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        link.assessment,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAssessmentSummaryCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha((0.3 * 255).toInt()),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getAssessmentColor(String assessment) {
    switch (assessment.toLowerCase()) {
      case 'not assessed':
        return Colors.red;
      case 'introduced':
        return Colors.blue;
      case 'working':
        return Colors.amber;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEylfTab(ObservationDetailData observation) {
    if (observation.eylfLinks.isEmpty) {
      return _buildEmptyTab('EYLF outcomes', Icons.star);
    }

    // Group by outcome
    final Map<String, List<EylfLink>> groupedByOutcome = {};
    for (var link in observation.eylfLinks) {
      final outcomeTitle = link.subActivity.activity.outcome.title;
      if (!groupedByOutcome.containsKey(outcomeTitle)) {
        groupedByOutcome[outcomeTitle] = [];
      }
      groupedByOutcome[outcomeTitle]!.add(link);
    }

    final totalOutcomes = observation.eylfLinks.length;

    // Create a sorted list of outcome keys for consistent display order
    final sortedOutcomes = groupedByOutcome.keys.toList()
      ..sort((a, b) {
        // Extract the outcome number and convert to int for numeric sorting
        final numA = int.tryParse(a.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        final numB = int.tryParse(b.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        return numA.compareTo(numB);
      });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Icon(Icons.star, color: Colors.blue, size: 22),
                const SizedBox(width: 8),
                Text(
                  'EYLF Outcomes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total outcomes summary card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(
                    'Total EYLF outcomes achieved: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '$totalOutcomes',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Outcome groups
            ...sortedOutcomes.map((outcomeName) {
              final outcomeLinks = groupedByOutcome[outcomeName]!;
              final achievementCount = outcomeLinks.length;

              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Outcome group header
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(Icons.track_changes,
                              color: AppColors.primaryColor, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            outcomeName,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$achievementCount achievements',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Outcome items container
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        children: outcomeLinks.map((link) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Check icon
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        link.subActivity.activity.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        link.subActivity.title,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTab(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No $title recorded for this observation',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopmentTab(ObservationDetailData observation) {
    if (observation.devMilestoneSubs.isEmpty) {
      return _buildEmptyTab('Development milestones', Icons.trending_up);
    }

    // Count milestones by assessment type
    int introducedCount = 0;
    int workingTowardsCount = 0;
    int achievedCount = 0;

    for (var milestone in observation.devMilestoneSubs) {
      switch (milestone.assessment.toLowerCase()) {
        case 'introduced':
          introducedCount++;
          break;
        case 'working towards':
          workingTowardsCount++;
          break;
        case 'achieved':
          achievedCount++;
          break;
      }
    }

    // Group by age group
    final Map<String, Map<String, List<DevMilestoneSub>>>
        groupedByAgeAndCategory = {};

    for (var milestone in observation.devMilestoneSubs) {
      final ageGroup = milestone.devMilestone.milestone.ageGroup;
      final category = milestone.devMilestone.main.name;

      if (!groupedByAgeAndCategory.containsKey(ageGroup)) {
        groupedByAgeAndCategory[ageGroup] = {};
      }

      if (!groupedByAgeAndCategory[ageGroup]!.containsKey(category)) {
        groupedByAgeAndCategory[ageGroup]![category] = [];
      }

      groupedByAgeAndCategory[ageGroup]![category]!.add(milestone);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.green, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Development Milestones',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Milestone summary cards (smaller size)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 6), // Reduced padding
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          introducedCount.toString(),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // Smaller font
                          ),
                        ),
                        const SizedBox(height: 2), // Smaller spacing
                        const Text(
                          'Introduced',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 11, // Smaller font
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 6), // Reduced padding
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          workingTowardsCount.toString(),
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // Smaller font
                          ),
                        ),
                        const SizedBox(height: 2), // Smaller spacing
                        const Text(
                          'Working Towards',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                            fontSize: 11, // Smaller font
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 6), // Reduced padding
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.green, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          achievedCount.toString(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // Smaller font
                          ),
                        ),
                        const SizedBox(height: 2), // Smaller spacing
                        const Text(
                          'Achieved',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 11, // Smaller font
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Age groups
            ...groupedByAgeAndCategory.entries.map((ageEntry) {
              final ageGroup = ageEntry.key;
              final categoryMap = ageEntry.value;
              final totalMilestones = categoryMap.values
                  .fold<int>(0, (sum, list) => sum + list.length);

              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Age group header with black text color for birthday year
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Icon(Icons.cake,
                              color: Colors.purple.shade300, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            ageGroup,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Changed to black color
                                ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border: Border.all(
                                color: Colors.grey.shade600,
                                width: 2, // Border width 2
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$totalMilestones milestones',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors
                                        .grey.shade800, // Darker text color
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Categories within age group
                    ...categoryMap.entries.map((categoryEntry) {
                      final category = categoryEntry.key;
                      final milestones = categoryEntry.value;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20, left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category header
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.list,
                                      color: Colors.grey.shade700, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            // Milestone items
                            ...milestones.map((milestone) {
                              final Color statusColor =
                                  _getMilestoneStatusColor(
                                      milestone.assessment);

                              return Container(
                                margin:
                                    const EdgeInsets.only(bottom: 10, left: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        milestone.devMilestone.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Status badge with white background and colored border
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: statusColor,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        milestone.assessment,
                                        style: TextStyle(
                                          color:
                                              statusColor, // Text color matches border color
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getMilestoneStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'introduced':
        return Colors.blue;
      case 'working towards':
        return Colors.orange;
      case 'achieved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ViewObservationBloc();
        bloc.add(FetchObservationEvent(observationId: widget.id));
        return bloc;
      },
      child: BlocListener<ViewObservationBloc, ViewObservationState>(
        listener: (context, state) {
          if (state is ViewObservationLoaded) {}
        },
        child: CustomScaffold(
          appBar: const CustomAppBar(
            title: 'Observation Details',
            toolbarHeight: 60,
          ),
          body: BlocBuilder<ViewObservationBloc, ViewObservationState>(
            builder: (context, state) {
              if (state is ViewObservationLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor));
              }
              if (state is ViewObservationFailure) {
                return Center(child: Text('Error: ${state.error}'));
              }
              if (state is ViewObservationLoaded) {
                final observation = state.data;
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(
                                observation.title,
                                observation.id.toString(),
                                observation.centerid.toString()),
                            PatternBackground(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300)),
                                    ),
                                    child: TabBar(
                                      controller: _tabController,
                                      labelColor: AppColors.primaryColor,
                                      unselectedLabelColor: Colors.grey,
                                      indicatorColor: AppColors.primaryColor,
                                      tabs: const [
                                        Tab(
                                            icon: Icon(Icons
                                                .closed_caption_disabled_outlined),
                                            text: 'Observation'),
                                        Tab(
                                            icon: Icon(Icons.child_care),
                                            text: 'Child'),
                                        Tab(
                                            icon: Icon(Icons.school),
                                            text: 'Montessori'),
                                        Tab(
                                            icon: Icon(Icons.star),
                                            text: 'EYLF'),
                                        Tab(
                                            icon: Icon(Icons.trending_up),
                                            text: 'Development'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      padding: const EdgeInsets.all(16.0),
                                      child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          SingleChildScrollView(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Basic Information',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Table(
                                                    defaultColumnWidth:
                                                        const FlexColumnWidth(
                                                            100),
                                                    columnWidths: const {
                                                      0: IntrinsicColumnWidth(),
                                                      1: IntrinsicColumnWidth(),
                                                    },
                                                    defaultVerticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    children: [
                                                      TableRow(
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4),
                                                            child: Text('Date:',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        4),
                                                            child: Text(DateFormat(
                                                                    'dd MMM yyyy')
                                                                .format(DateTime
                                                                    .parse(observation
                                                                        .dateAdded))),
                                                          ),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4),
                                                            child: Text('Time:',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        4),
                                                            child: Text(DateFormat(
                                                                    'hh:mm a')
                                                                .format(DateTime
                                                                    .parse(observation
                                                                        .dateAdded))),
                                                          ),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4),
                                                            child: Text(
                                                                'Status:',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        8),
                                                            child: SizedBox(
                                                              width: 100,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: (observation
                                                                              .status ==
                                                                          'Published')
                                                                      ? Colors
                                                                          .green
                                                                      : const Color(
                                                                          0xffFFEFB8),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        6),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      (observation.status ==
                                                                              'Published')
                                                                          ? Icons
                                                                              .check_circle
                                                                          : Icons
                                                                              .drafts,
                                                                      size: 14,
                                                                      color: (observation.status ==
                                                                              'Published')
                                                                          ? Colors
                                                                              .white
                                                                          : const Color(
                                                                              0xffCC9D00),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            4),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        observation
                                                                            .status,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          color: (observation.status == 'Published')
                                                                              ? Colors.white
                                                                              : const Color(0xffCC9D00),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 32),
                                                  _buildSection(
                                                      'Observation Notes',
                                                      observation.notes),
                                                  _buildSection('Reflection',
                                                      observation.reflection),
                                                  _buildSection('Child Voice',
                                                      observation.childVoice),
                                                  _buildSection('Future Plan',
                                                      observation.futurePlan),
                                                  const SizedBox(height: 32),
                                                  Text(
                                                    'Media Files',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  if (observation
                                                      .media.isNotEmpty)
                                                    GridView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: observation
                                                          .media.length,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing: 12,
                                                        crossAxisSpacing: 12,
                                                        childAspectRatio: 1,
                                                      ),
                                                      itemBuilder:
                                                          (context, index) {
                                                        final mediaItem =
                                                            observation
                                                                .media[index];
                                                        final mediaUrl =
                                                            '${AppUrls.baseUrl}/${mediaItem.mediaUrl}';
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.08),
                                                                blurRadius: 12,
                                                                offset:
                                                                    const Offset(
                                                                        0, 6),
                                                              ),
                                                            ],
                                                            border: Border.all(
                                                              color: AppColors
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.2),
                                                              width: 2,
                                                            ),
                                                            gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                Colors.white,
                                                                AppColors
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.08),
                                                              ],
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                            ),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            child: Stack(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    // Handle tap if needed
                                                                  },
                                                                  child: SizedBox
                                                                      .expand(
                                                                    child: Image
                                                                        .network(
                                                                      mediaUrl,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) =>
                                                                          const PatternBackground(
                                                                        child:
                                                                            SizedBox(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                ]),
                                          ),
                                          SingleChildScrollView(
                                              child:
                                                  _buildChildTab(observation)),
                                          _buildMontessoriTab(observation),
                                          _buildEylfTab(observation),
                                          _buildDevelopmentTab(observation),
                                        ],
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                child: Text('No observation data available'),
              );
            },
          ),
        ),
      ),
    );
  }
}
