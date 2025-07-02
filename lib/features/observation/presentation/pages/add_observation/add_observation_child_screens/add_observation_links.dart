import 'package:flutter/material.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/observation/presentation/widget/observation_list_custom_widgets.dart';

class ObservationLinkingScreen extends StatefulWidget {
  const ObservationLinkingScreen({super.key});

  @override
  State<ObservationLinkingScreen> createState() =>
      _ObservationLinkingScreenState();
}

class _ObservationLinkingScreenState extends State<ObservationLinkingScreen> {
  final List<Observation> linkedObservations = [
    Observation(
      id: '280',
      imageUrl: 'https://mydiaree.com.au/67e1a161c7455.jpg',
      title: '',
      createdBy: 'Deepti2',
    ),
    Observation(
      id: '287',
      imageUrl: 'https://mydiaree.com.au/67e26cc5edcc7.jpg',
      title: '',
      createdBy: 'Deepti2',
    ),
  ];

  final List<Observation> allObservations = [
    Observation(
      id: '372',
      imageUrl: '/67ff8213d8540.jpg',
      title: '',
      createdBy: 'Deepti2',
    ),
    Observation(
      id: '381',
      imageUrl: '/6801ce217a034.jpg',
      title: '',
      createdBy: 'Deepti2',
    ),
    Observation(
      id: '454',
      imageUrl: '/682edc09bf6ac.png',
      title: 'title up',
      createdBy: 'Deepti2',
    ),
  ];

  final Set<String> selectedObservationIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedObservationIds.addAll(linkedObservations.map((o) => o.id));
  }

  void _showObservationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: allObservations
                          .where((obs) =>
                              obs.title.toLowerCase().contains(
                                  _searchController.text.toLowerCase()) ||
                              _searchController.text.isEmpty)
                          .length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final filteredObservations = allObservations
                            .where((obs) =>
                                obs.title.toLowerCase().contains(
                                    _searchController.text.toLowerCase()) ||
                                _searchController.text.isEmpty)
                            .toList();
                        final observation = filteredObservations[index];
                        return SmallObservationCard(
                          id: observation.id,
                          title: observation.title,
                          userName: observation.createdBy,
                          isSelected:
                              selectedObservationIds.contains(observation.id),
                          isLinked: linkedObservations
                              .any((o) => o.id == observation.id),
                          onTap: () {
                            setModalState(() {
                              if (selectedObservationIds
                                  .contains(observation.id)) {
                                selectedObservationIds.remove(observation.id);
                              } else {
                                selectedObservationIds.add(observation.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                      text: 'Save',
                      ontap: () {
                        setState(() {
                          linkedObservations.clear();
                          linkedObservations.addAll(allObservations.where(
                              (obs) =>
                                  selectedObservationIds.contains(obs.id)));
                        });
                        Navigator.pop(context);
                      }),
                ],
              ),
            );
          },
        );
      },
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
                    //  _showObservationModal(context);
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
              child: ListView.builder(
                itemCount: linkedObservations.length,
                itemBuilder: (context, index) {
                  final obs = linkedObservations[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ObservationCard(
                      title: obs.title,
                      author: obs.createdBy,
                      approvedBy: 'Admin', // Provide actual value if available
                      dateAdded:
                          '2023-06-15T14:30:00', // Provide actual value if available
                      mediaUrl: obs.imageUrl,
                      montessoriCount: 0,
                      eylfCount: 0,
                      status: 'Published', // Provide actual value if available
                      onTap: () {
                        // Handle card tap
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Observation {
  final String id;
  final String imageUrl;
  final String title;
  final String createdBy;

  Observation({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.createdBy,
  });
}
