import 'package:flutter/material.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/observation/presentation/pages/add_observation_screen.dart';
import 'package:mydiaree/features/observation/presentation/widget/observation_list_custom_widgets.dart';
import 'package:mydiaree/main.dart';

class ObservationListScreen extends StatelessWidget {
  const ObservationListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Sample static data
    final observations = [
      {
        'title': 'Vicky\'s art exploration with watercolors',
        'userName': 'Vicky Patel',
        'dateAdded': '2023-06-15T14:30:00',
        'observationsMedia': 'art.jpg',
        'montessoricount': 4,
        'eylfcount': 3,
        'status': 'Published'
      },
      {
        'title': 'Vicky\'s progress in counting to 20 using Montessori beads',
        'userName': 'Priya Patel',
        'dateAdded': '2023-06-18T11:15:00',
        'observationsMedia': '',
        'montessoricount': 2,
        'eylfcount': 1,
        'status': 'Draft'
      },
      {
        'title': 'Vicky\'s art exploration with watercolors',
        'userName': 'Vicky Patel',
        'dateAdded': '2023-06-15T14:30:00',
        'observationsMedia': 'art.jpg',
        'montessoricount': 4,
        'eylfcount': 3,
        'status': 'Published'
      },
      {
        'title': 'Vicky\'s progress in counting to 20 using Montessori beads',
        'userName': 'Priya Patel',
        'dateAdded': '2023-06-18T11:15:00',
        'observationsMedia': '',
        'montessoricount': 2,
        'eylfcount': 1,
        'status': 'Draft'
      },
      {
        'title': 'Vicky\'s art exploration with watercolors',
        'userName': 'Vicky Patel',
        'dateAdded': '2023-06-15T14:30:00',
        'observationsMedia': 'art.jpg',
        'montessoricount': 4,
        'eylfcount': 3,
        'status': 'Published'
      },
      {
        'title': 'Vicky\'s progress in counting to 20 using Montessori beads',
        'userName': 'Priya Patel',
        'dateAdded': '2023-06-18T11:15:00',
        'observationsMedia': '',
        'montessoricount': 2,
        'eylfcount': 1,
        'status': 'Draft'
      },
    ];

    return CustomScaffold(
      appBar: const CustomAppBar(title: "Observations"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text('Observations',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  if (true) // Replace with your permission check
                    UIHelpers.addButton(
                      context: context,
                      ontap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return AddObservationScreen(
                            type: 'add',
                            centerId: '1',
                          );
                        }));

                        // Navigate to add observation screen
                      },
                    ),
                ],
              ),
              const SizedBox(height: 5),
              CustomDropdown(
                value: 'Main Center',
                items: const ['Main Center', 'A Center', 'B Center'],
                width: screenWidth * .9,
                onChanged: (value) {},
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 3),
                child: CustomTextFormWidget(
                  width: screenWidth * .9,
                  contentpadding: const EdgeInsets.only(top: 4),
                  prefixWidget: const Icon(Icons.search),
                  height: 40,
                  hintText: 'Search observations...',
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(height: 5),
              CustomDropdown(
                width: MediaQuery.of(context).size.width * 0.3,
                value: 'All',
                items: const ['All', 'Published', 'Draft'],
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: observations.length,
                itemBuilder: (BuildContext context, int index) {
                  return ObservationCard(
                    observation: ObservationModel.fromJson(observations[index]),
                    onTap: () {
                      // Handle card tap
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
