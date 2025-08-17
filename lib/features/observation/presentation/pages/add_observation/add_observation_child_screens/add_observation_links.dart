import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/observation/data/model/add_new_observation_response.dart'
    hide Center;
import 'package:mydiaree/features/observation/data/model/observation_links_response.dart';
import 'package:mydiaree/features/observation/data/model/observation_list_response.dart';
import 'package:mydiaree/features/observation/data/repositories/observation_repositories.dart';
import 'package:mydiaree/features/observation/presentation/widget/observation_list_custom_widgets.dart';

String stripHtmlTags(String htmlString) {
  if (htmlString.isEmpty) return '';

  return htmlString
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('\n', ' ')
      .trim();
}

class ObservationLinkingScreen extends StatefulWidget {
  final AddNewObservationData? observationData;
  final String observationId;

  const ObservationLinkingScreen({
    super.key,
    this.observationData,
    this.observationId = '',
  });

  @override
  State<ObservationLinkingScreen> createState() =>
      _ObservationLinkingScreenState();
}

class _ObservationLinkingScreenState extends State<ObservationLinkingScreen> {
  List<ObservationListItem> allObservations = [];
  List<ObservationListItem> linkedObservations = [];
  List<int> linkedObservationIds = [];
  Set<int> selectedObservationIds = {};
  bool isLoading = true;
  bool isSaving = false;
  final TextEditingController _searchController = TextEditingController();
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch linked observation IDs
      await _fetchLinkedObservationIds();

      // Fetch all observations
      await _fetchAllObservations();

      // Update linked observations list
      _updateLinkedObservations();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading observations: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateLinkedObservations() {
    linkedObservations = allObservations
        .where((obs) => linkedObservationIds.contains(obs.id))
        .toList();
  }

  Future<void> _fetchLinkedObservationIds() async {
    try {
      final headers = await ApiServices.getAuthHeaders();

      final response = await dio.get(
        '${AppUrls.baseUrl}/api/observation/observationslink?obsId=${widget.observationId}&center_id=1',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final linksResponse = ObservationLinksResponse.fromJson(data);

        setState(() {
          linkedObservationIds = linksResponse.linkedIds;
          selectedObservationIds = Set.from(linkedObservationIds);
        });

        print('Linked observation IDs: $linkedObservationIds');
      }
    } catch (e) {
      print('Error fetching linked observations: $e');
      linkedObservationIds = [];
    }
  }

  Future<void> _fetchAllObservations() async {
    try {
      final headers = await ApiServices.getAuthHeaders();

      final response = await dio.get(
        '${AppUrls.baseUrl}/api/observation/view?center_id=1',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final obsResponse = ObservationListResponse.fromJson(data);

        // Filter out the current observation
        final filteredObservations = obsResponse.observations
            .where((obs) => obs.id.toString() != widget.observationId)
            .toList();

        setState(() {
          allObservations = filteredObservations;
        });

        print('Fetched ${allObservations.length} observations');
      }
    } catch (e) {
      print('Error fetching all observations: $e');
      throw e;
    }
  }

  Future<void> _submitSelectedLinks() async {
    try {
      setState(() {
        isSaving = true;
      });

      final headers = await ApiServices.getAuthHeaders();

      var formData = FormData();
      formData.fields.add(MapEntry('obsId', widget.observationId));

      for (var id in selectedObservationIds) {
        formData.fields.add(MapEntry('observation_ids[]', id.toString()));
      }

      var response = await dio.post(
        '${AppUrls.baseUrl}/api/observation/submit-selectedoblink',
        options: Options(
          headers: headers,
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Observation links saved successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh data
        await _fetchData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error saving observation links: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  bool isStatusUpdating = false;
  String selectedStatus = '';

  Future<void> _updateObservationStatus(String status) async {
    setState(() {
      isStatusUpdating = true;
    });
    try {
      final repo = ObservationRepository();
      final resp = await repo.updateObservationStatus(
        observationId: widget.observationId,
        status: status,
      );
      if (resp.success) {
        UIHelpers.showToast(context, message: 'Status updated to $status');
        // Optionally refresh data or UI
      } else {
        UIHelpers.showToast(context,
            message: resp.message ?? 'Failed to update status');
      }
    } catch (e) {
      UIHelpers.showToast(context, message: 'Error: $e');
    } finally {
      setState(() {
        isStatusUpdating = false;
      });
    }
  }

  void _showObservationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final filteredObservations = allObservations
                .where((obs) =>
                    stripHtmlTags(obs.title)
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    _searchController.text.isEmpty)
                .toList();

            return PatternBackground(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  const Text('Select Observations',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  CustomTextFormWidget(
                    controller: _searchController,
                    hintText: 'Search',
                    prefixWidget: const Icon(Icons.search),
                    onChanged: (value) => setModalState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: filteredObservations.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (context, index) {
                              final observation = filteredObservations[index];
                              return _buildObservationCard(
                                observation,
                                selectedObservationIds.contains(observation.id),
                                linkedObservationIds.contains(observation.id),
                                () {
                                  setModalState(() {
                                    if (selectedObservationIds
                                        .contains(observation.id)) {
                                      selectedObservationIds
                                          .remove(observation.id);
                                    } else {
                                      selectedObservationIds
                                          .add(observation.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      CustomButton(
                          text: 'Save',
                          height: 35,
                          width: 100,
                          isLoading: isSaving,
                          ontap: () async {
                            Navigator.pop(context);
                            await _submitSelectedLinks();
                          }),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildObservationCard(ObservationListItem observation, bool isSelected,
      bool isLinked, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (observation.previewImage.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        '${AppUrls.baseUrl}/${observation.previewImage}',
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 80,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    stripHtmlTags(observation.title),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'By: ${observation.user.name}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  if (isLinked && !isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Text(
                        'Linked',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelpers.verticalSpace(20),
            Row(
              children: [
                CustomButton(
                  width: 150,
                  height: 40,
                  text: '+ Link Observation',
                  ontap: () {
                    _showObservationModal(context);
                  },
                ),
                const SizedBox(width: 8),
                CustomButton(
                  width: 150,
                  height: 40,
                  text: '+ Link Reflection',
                  ontap: () {
                    // TODO: Implement link reflection functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Linked Observations',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : linkedObservations.isEmpty
                      ? const Center(child: Text('No linked observations'))
                      : ListView.builder(
                          itemCount: linkedObservations.length,
                          itemBuilder: (context, index) {
                            final obs = linkedObservations[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ObservationCard(
                                title: stripHtmlTags(obs.title),
                                author: obs.user.name,
                                approvedBy:
                                    obs.approver != null ? 'Admin' : 'Pending',
                                dateAdded: obs.dateAdded,
                                mediaUrl: obs.previewImage.isNotEmpty
                                    ? 'https://mydiaree.com.au/${obs.previewImage}'
                                    : '',
                                montessoriCount:
                                    0, // You can update this if needed
                                eylfCount: 0, // You can update this if needed
                                status: obs.status,
                                onTap: () {
                                  // Handle navigation to observation details
                                },
                              ),
                            );
                          },
                        ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UIHelpers.verticalSpace(20),
                CustomButton(
                  text: 'Publish Now',
                  color: Colors.green,
                  isLoading:
                      (isStatusUpdating && selectedStatus == 'Published'),
                  ontap: isStatusUpdating
                      ? null
                      : () {
                          selectedStatus = 'Published';
                          _updateObservationStatus(selectedStatus);
                        },
                  width: 140,
                  height: 40,
                  borderRadius: 2,
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Make Draft',
                  borderRadius: 2,
                  color: Colors.orange,
                  isLoading: isStatusUpdating && selectedStatus == 'Draft',
                  ontap: isStatusUpdating
                      ? null
                      : () {
                          selectedStatus = 'Draft';
                          _updateObservationStatus(selectedStatus);
                        },
                  width: 140,
                  height: 40,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
