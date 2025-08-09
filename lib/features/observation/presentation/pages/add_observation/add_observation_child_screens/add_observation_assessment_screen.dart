import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/observation/data/model/add_new_observation_response.dart'
    hide Center;
import 'package:mydiaree/features/observation/data/repositories/observation_repositories.dart';
import 'package:mydiaree/main.dart';

class AssessmentsScreen extends StatefulWidget {
  final AddNewObservationData? observationData;
  final Function(String) onTabChanged;
  final Function()? onSaveDevelopmentMilestone;

  const AssessmentsScreen({
    super.key,
    this.observationData,
    required this.onTabChanged,
    this.onSaveDevelopmentMilestone,
  });

  @override
  State<AssessmentsScreen> createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends State<AssessmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedSubject;
  String? selectedEYLFOutcome;
  String? selectedAgeGroup;
  bool isExpanded = true;

  bool _userSelectedTab = false;
  Map<String, String?> assessmentValues = {};
  Map<String, bool> activityCategoryExpanded = {};
  Map<String, bool> eylfSectionExpanded = {};
  Set<String> selectedEYLFActivities = {};
  Map<String, bool> devDomainExpanded = {};
  Map<String, String?> devMilestoneValues = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Add listener to notify parent when tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _userSelectedTab = true; // Set flag to indicate user selection
        String subTab = "MONTESSORI";
        switch (_tabController.index) {
          case 0:
            subTab = "MONTESSORI";
            break;
          case 1:
            subTab = "EYLF";
            break;
          case 2:
            subTab = "DEVELOPMENTAL MILESTONE";
            break;
        }
        // widget.onTabChanged(subTab);
      }
    });

    // Initialize from API data
    _initializeFromApiData();
  }

  void _initializeFromApiData() {
    if (widget.observationData != null) {
      // Find active tab from API data
      if (widget.observationData!.activesubTab == "MONTESSORI") {
        _tabController.animateTo(0);
      } else if (widget.observationData!.activesubTab == "EYLF") {
        _tabController.animateTo(1);
      } else if (widget.observationData!.activesubTab ==
          "DEVELOPMENTAL MILESTONE") {
        _tabController.animateTo(2);
      }

      // Initialize Montessori selections - normalize case to match UI
      for (var link in widget.observationData!.observation.montessoriLinks) {
        // Ensure consistent capitalization to match radio button values
        String assessment = link.assesment;
        if (assessment.toLowerCase() == 'introduced') {
          assessment = 'Introduced';
        } else if (assessment.toLowerCase() == 'practicing' ||
            assessment.toLowerCase() == 'working') {
          assessment = 'Practicing';
        } else if (assessment.toLowerCase() == 'completed') {
          assessment = 'Completed';
        }
        assessmentValues['${link.idSubActivity}'] = assessment;
        print('=======assessmentValues========');
        print(assessmentValues);
      }

      // Initialize EYLF selections
      for (var link in widget.observationData!.observation.eylfLinks) {
        selectedEYLFActivities.add('${link.eylfSubactivityId}');
      }

      // Initialize Developmental Milestone selections
      for (var milestone
          in widget.observationData!.observation.devMilestoneSubs) {
        devMilestoneValues['${milestone.devMilestoneId}'] =
            milestone.assessment;
      }
    }
  }

  @override
  void didUpdateWidget(AssessmentsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.observationData != oldWidget.observationData) {
      _initializeFromApiData();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(
                  icon: Icon(Icons.assignment),
                  text: 'MONTESSORI',
                  height: 60,
                ),
                Tab(
                  icon: Icon(Icons.list),
                  text: 'EYLF',
                  height: 60,
                ),
                Tab(
                  icon: Icon(Icons.layers),
                  text: 'DEVELOPMENTAL MILESTONE',
                  height: 60,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Montessori tab content
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject dropdown
                        const Text(
                          'Select Subject',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // Common dropdown container style - replace all 3 dropdown containers with this improved version
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors
                                    .primaryColor), // Primary color border
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors
                                  .white, // White background when dropdown opens
                              // Add these to ensure selected item has proper styling
                              focusColor: Colors.white,
                              hoverColor: Colors.white.withOpacity(0.1),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                border: InputBorder.none,
                                // Add this to ensure focus border is also primary color
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              dropdownColor: Colors
                                  .white, // Ensure dropdown menu background is white
                              hint: const Text(
                                  '-- Choose Subject --'), // Adjust text per dropdown
                              isExpanded: true,
                              value:
                                  selectedSubject, // Use appropriate variable per dropdown
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSubject =
                                      newValue; // Use appropriate variable per dropdown
                                });
                              },
                              items: widget.observationData?.subjects
                                      .map((subject) {
                                    // Adjust items per dropdown
                                    return DropdownMenuItem<String>(
                                      value: subject.idSubject.toString(),
                                      child: Text(subject.name),
                                    );
                                  }).toList() ??
                                  [],
                            ),
                          ),
                        ),

                        // Show activities after subject is selected
                        if (selectedSubject != null &&
                            widget.observationData != null) ...[
                          const SizedBox(height: 16),

                          // Find the selected subject
                          ...widget.observationData!.subjects
                              .where((subject) =>
                                  subject.idSubject.toString() ==
                                  selectedSubject)
                              .expand((subject) => subject.activities)
                              .map((activity) {
                            // Initialize expansion state if not already set
                            activityCategoryExpanded.putIfAbsent(
                                activity.idActivity.toString(), () => false);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              child: Column(
                                children: [
                                  // Category header with expand/collapse
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        activityCategoryExpanded[activity
                                                .idActivity
                                                .toString()] =
                                            !activityCategoryExpanded[activity
                                                .idActivity
                                                .toString()]!;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: activityCategoryExpanded[
                                                    activity.idActivity
                                                        .toString()]!
                                                ? Colors.grey.shade300
                                                : Colors.transparent,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.task_alt,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            width: screenWidth * 0.7,
                                            child: Text(
                                              activity.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                          const Spacer(),
                                          Icon(
                                            activityCategoryExpanded[activity
                                                    .idActivity
                                                    .toString()]!
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Category content (sub activities)
                                  if (activityCategoryExpanded[
                                      activity.idActivity.toString()]!)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      color: Colors
                                          .white, // Explicitly set white background
                                      child: Column(
                                        children: activity.subActivities
                                            .map((subActivity) {
                                          return Column(
                                            children: [
                                              _buildActivityRow(
                                                subActivity.title,
                                                subActivity.idSubActivity
                                                    .toString(),
                                              ),
                                              if (subActivity !=
                                                  activity.subActivities.last)
                                                const Divider(),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ],
                    ),
                  ),
                ),

                // EYLF tab content with API data
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Outcome selection dropdown
                        const Text(
                          'Select Outcome',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // Common dropdown container style - replace all 3 dropdown containers with this improved version
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors
                                    .primaryColor), // Primary color border
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors
                                  .white, // White background when dropdown opens
                              // Add these to ensure selected item has proper styling
                              focusColor: Colors.white,
                              hoverColor: Colors.white.withOpacity(0.1),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                border: InputBorder.none,
                                // Add this to ensure focus border is also primary color
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              dropdownColor: Colors
                                  .white, // Ensure dropdown menu background is white
                              hint: const Text(
                                  '-- Choose Outcome --'), // Adjust text per dropdown
                              isExpanded: true,
                              value:
                                  selectedEYLFOutcome, // Use appropriate variable per dropdown
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedEYLFOutcome =
                                      newValue; // Use appropriate variable per dropdown
                                });
                              },
                              items: widget.observationData?.outcomes
                                      .map((outcome) {
                                    return DropdownMenuItem<String>(
                                      value: outcome.id.toString(),
                                      child: Text("${outcome.title}"),
                                    );
                                  }).toList() ??
                                  [],
                            ),
                          ),
                        ),

                        // Show outcome sections when an outcome is selected
                        if (selectedEYLFOutcome != null &&
                            widget.observationData != null)
                          Column(
                            children: [
                              const SizedBox(height: 16),

                              // Build the relevant outcome sections from API data
                              ...widget.observationData!.outcomes
                                  .where((outcome) =>
                                      outcome.id.toString() ==
                                      selectedEYLFOutcome)
                                  .expand((outcome) => outcome.activities)
                                  .map((activity) => _buildEYLFSection(
                                        activity.title,
                                        activity.id.toString(),
                                        activity.subActivities
                                            .map((sub) => {
                                                  'id': sub.id.toString(),
                                                  'description': sub.title,
                                                })
                                            .toList(),
                                      ))
                                  .toList(),

                              // Save button
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final subactivityIds =
                                        selectedEYLFActivities
                                            .map((e) => int.parse(e))
                                            .toList();
                                    ObservationRepository _observationRepository =
                                        ObservationRepository();
                                    final response =
                                        await _observationRepository
                                            .saveEYLFAssessment(
                                      observationId: widget
                                          .observationData!.observation.id,
                                      subactivityIds: subactivityIds,
                                    );
                                    if (response.success) {
                                      UIHelpers.showToast(context,
                                          message: 'EYLF saved');
                                      _tabController.animateTo(
                                          2); // Switch to Developmental Milestone tab
                                    } else {
                                      UIHelpers.showToast(context,
                                          message: response.message);
                                    }
                                  },
                                  child: const Text('Save EYLF Selection'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Age Group Dropdown
                        const Text(
                          'Select Age Group',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // Common dropdown container style - replace all 3 dropdown containers with this improved version
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors
                                    .primaryColor), // Primary color border
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors
                                  .white, // White background when dropdown opens
                              // Add these to ensure selected item has proper styling
                              focusColor: Colors.white,
                              hoverColor: Colors.white.withOpacity(0.1),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                border: InputBorder.none,
                                // Add this to ensure focus border is also primary color
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              dropdownColor: Colors
                                  .white, // Ensure dropdown menu background is white
                              hint: const Text(
                                  '-- Choose Age Group --'), // Adjust text per dropdown
                              isExpanded: true,
                              value:
                                  selectedAgeGroup, // Use appropriate variable per dropdown
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedAgeGroup =
                                      newValue; // Use appropriate variable per dropdown
                                });
                              },
                              items: widget.observationData?.milestones
                                      .map((milestone) {
                                    return DropdownMenuItem<String>(
                                      value: milestone.id.toString(),
                                      child: Text(milestone.ageGroup),
                                    );
                                  }).toList() ??
                                  [],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Developmental milestones based on selected age group from API
                        if (selectedAgeGroup != null &&
                            widget.observationData != null) ...[
                          // Display domains for the selected age group
                          ...widget.observationData!.milestones
                              .where((milestone) =>
                                  milestone.id.toString() == selectedAgeGroup)
                              .expand((milestone) => milestone.mains)
                              .map((main) {
                            // Initialize expansion state
                            devDomainExpanded.putIfAbsent(
                                'dev-domain-${main.id}', () => false);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              child: Column(
                                children: [
                                  // Domain header
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        devDomainExpanded[
                                                'dev-domain-${main.id}'] =
                                            !devDomainExpanded[
                                                'dev-domain-${main.id}']!;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: devDomainExpanded[
                                                    'dev-domain-${main.id}']!
                                                ? Colors.grey.shade300
                                                : Colors.transparent,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            main.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Icon(
                                            devDomainExpanded[
                                                    'dev-domain-${main.id}']!
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Domain content (milestones)
                                  if (devDomainExpanded[
                                      'dev-domain-${main.id}']!)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      color: Colors.white,
                                      child: Column(
                                        children: main.subs.map<Widget>((sub) {
                                          return Column(
                                            children: [
                                              _buildMilestoneRow(
                                                  sub.id.toString(), sub.name),
                                              if (sub != main.subs.last)
                                                const Divider(),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),

                          // Save button
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
  onPressed: () async {
    final selections = devMilestoneValues.entries
      .where((e) => e.value != null)
      .map((e) => {
        "idSub": int.parse(e.key),
        "assessment": e.value,
      }).toList();
    ObservationRepository _observationRepository = ObservationRepository();
    final response = await _observationRepository.saveDevelopmentMilestone(
      observationId: widget.observationData!.observation.id,
      selections: selections,
    );
    if (response.success) {
      UIHelpers.showToast(context, message: 'Developmental milestones saved');
      if (widget.onSaveDevelopmentMilestone != null) {
        widget.onSaveDevelopmentMilestone!();
      }
    } else {
      UIHelpers.showToast(context, message: response.message);
    }
  },
  child: const Text('Save Development Milestone'),
),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final subactivities = assessmentValues.entries
                      .where((e) => e.value != null)
                      .map((e) => {
                            "idSubActivity": int.parse(e.key),
                            "assesment": e.value,
                          })
                      .toList();
                  ObservationRepository observationRepository =
                      ObservationRepository();

                  final response = await observationRepository.saveMontessoriAssessment(
                    observationId: widget.observationData!.observation.id,
                    subactivities: subactivities,
                  );
                  if (response.success) {
                    UIHelpers.showToast(context, message: 'Montessori saved');
                    _tabController.animateTo(1);
                  } else {
                    UIHelpers.showToast(context, message: response.message);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Save Montessori',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each activity row
  Widget _buildActivityRow(String activityName, String id) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity name
          SizedBox(
            width: 120,
            child: Text(
              activityName,
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Assessment options
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Triangle indicator
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CustomPaint(
                        painter: TrianglePainter(
                          level: _getAssessmentLevel(id),
                        ),
                      ),
                    ),

                    // Radio options
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.start,
                        children: [
                          _buildRadioOption(id, 'Introduced', 1),
                          _buildRadioOption(id, 'Practicing', 2),
                          _buildRadioOption(id, 'Completed', 3),

                          // Clear button
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                assessmentValues[id] = null;
                              });
                            },
                            icon: const Icon(Icons.clear, size: 16),
                            label: const Text('Clear'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ],
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
  }

  // Helper method to build each radio option
  Widget _buildRadioOption(String id, String label, int level) {
    print('------------------');
    print(id);
    print(label);
    print(level);
    print('-----------------');
    return InkWell(
      onTap: () {
        print('------------------');
        print(id);
        print(label);
        print(level);
        print('-----------------');
        setState(() {
          assessmentValues[id] = label;
        });
      },
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: label,
            groupValue: assessmentValues[id],
            activeColor:
                AppColors.primaryColor, // Set primary color for radio button
            onChanged: (value) {
              setState(() {
                assessmentValues[id] = value;
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  // Helper method to get assessment level
  int _getAssessmentLevel(String id) {
    if (assessmentValues[id] == 'Introduced') return 1;
    if (assessmentValues[id] == 'Practicing') return 2;
    if (assessmentValues[id] == 'Completed') return 3;
    return 0;
  }

  // Mock method to get activity categories based on selected subject
  List<String> _getActivityCategories(String subject) {
    // TODO: Replace with real implementation
    return [
      'Numbers',
      'Operations',
      'Algebra',
      'Geometry',
      'Measurement',
      'Data',
    ];
  }

  // // Mock method to get activities for a given category
  // List<Map<String, String>> _getActivitiesForCategory(String category) {
  //   // TODO: Replace with real implementation
  //   return [
  //     {'id': '1', 'name': 'Activity 1'},
  //     {'id': '2', 'name': 'Activity 2'},
  //     {'id': '3', 'name': 'Activity 3'},
  //   ];
  // }


  // Updated EYLF section with white background and primary color checkboxes
  Widget _buildEYLFSection(
      String title, String sectionId, List<Map<String, String>> activities) {
    // Initialize expansion state if not already set
    eylfSectionExpanded.putIfAbsent('eylf-section-$sectionId', () => false);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        children: [
          // Section header with expand/collapse
          InkWell(
            onTap: () {
              setState(() {
                eylfSectionExpanded['eylf-section-$sectionId'] =
                    !eylfSectionExpanded['eylf-section-$sectionId']!;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(
                    color: eylfSectionExpanded['eylf-section-$sectionId']!
                        ? Colors.grey.shade300
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    eylfSectionExpanded['eylf-section-$sectionId']!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),

          // Section content (checkboxes) with white background
          if (eylfSectionExpanded['eylf-section-$sectionId']!)
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.white, // Explicitly set white background
              child: Column(
                children: activities.map((activity) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          child: Checkbox(
                            value:
                                selectedEYLFActivities.contains(activity['id']),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedEYLFActivities.add(activity['id']!);
                                } else {
                                  selectedEYLFActivities.remove(activity['id']);
                                }
                              });
                            },
                            activeColor: AppColors
                                .primaryColor, // Set primary color for checkbox
                            checkColor: AppColors.white, // White check mark
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            activity['description']!,
                            style: const TextStyle(fontSize: 14),
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
  }

  
  // Helper method to build each milestone row
  Widget _buildMilestoneRow(String id, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Milestone description
          SizedBox(
            width: double.infinity,
            child: Text(
              description,
              maxLines: 4,
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Assessment options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Start align
              children: [
                // Radio options
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.start, // Start align
                  children: [
                    _buildDevRadioOption(id, 'Introduced'),
                    _buildDevRadioOption(id, 'Working towards'),
                    _buildDevRadioOption(id, 'Achieved'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build radio options for developmental milestones
  Widget _buildDevRadioOption(String id, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          devMilestoneValues[id] = label;
        });
      },
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: label,
            activeColor:
                AppColors.primaryColor, // Use primary color instead of yellow
            groupValue: devMilestoneValues[id],
            onChanged: (value) {
              setState(() {
                devMilestoneValues[id] = value;
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final int level;

  TrianglePainter({required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Color defaultColor =
        // ignore: deprecated_member_use
        Colors.grey.withOpacity(.2); // Use this for "black" sides

    // Draw the white background for the entire triangle
    final Paint backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final Path backgroundPath = Path()
      ..moveTo(0, height)
      ..lineTo(width / 2, 0)
      ..lineTo(width, height)
      ..close();

    canvas.drawPath(backgroundPath, backgroundPaint);

    // Draw triangle sides based on level
    // Level 1: bottom side green
    if (level == 1) {
      // Bottom side green, left and right sides defaultColor
      final Paint bottomPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.green;
      final Path bottomPath = Path()
        ..moveTo(width, height)
        ..lineTo(0, height);
      canvas.drawPath(bottomPath, bottomPaint);

      final Paint defaultPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = defaultColor;
      final Path leftPath = Path()
        ..moveTo(0, height)
        ..lineTo(width / 2, 0);
      final Path rightPath = Path()
        ..moveTo(width / 2, 0)
        ..lineTo(width, height);
      canvas.drawPath(leftPath, defaultPaint);
      canvas.drawPath(rightPath, defaultPaint);
    }
    // Level 2: bottom and left side yellow
    else if (level == 2) {
      final Paint bottomPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.amber;
      final Path bottomPath = Path()
        ..moveTo(width, height)
        ..lineTo(0, height);
      canvas.drawPath(bottomPath, bottomPaint);

      final Paint leftPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.amber;
      final Path leftPath = Path()
        ..moveTo(0, height)
        ..lineTo(width / 2, 0);
      canvas.drawPath(leftPath, leftPaint);

      // Third (right) side is defaultColor
      final Paint rightPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = defaultColor;
      final Path rightPath = Path()
        ..moveTo(width / 2, 0)
        ..lineTo(width, height);
      canvas.drawPath(rightPath, rightPaint);
    }
    // Level 3: all sides red
    else if (level == 3) {
      final Paint bottomPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.red;
      final Path bottomPath = Path()
        ..moveTo(width, height)
        ..lineTo(0, height);
      canvas.drawPath(bottomPath, bottomPaint);

      final Paint leftPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.red;
      final Path leftPath = Path()
        ..moveTo(0, height)
        ..lineTo(width / 2, 0);
      canvas.drawPath(leftPath, leftPaint);

      final Paint rightPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.red;
      final Path rightPath = Path()
        ..moveTo(width / 2, 0)
        ..lineTo(width, height);
      canvas.drawPath(rightPath, rightPaint);
    }
    // If not 1, 2, or 3: show defaultColor for all sides
    else {
      final Paint defaultPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = defaultColor;
      final Path leftPath = Path()
        ..moveTo(0, height)
        ..lineTo(width / 2, 0);
      final Path rightPath = Path()
        ..moveTo(width / 2, 0)
        ..lineTo(width, height);
      final Path bottomPath = Path()
        ..moveTo(width, height)
        ..lineTo(0, height);
      canvas.drawPath(leftPath, defaultPaint);
      canvas.drawPath(rightPath, defaultPaint);
      canvas.drawPath(bottomPath, defaultPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.level != level;
  }
}
