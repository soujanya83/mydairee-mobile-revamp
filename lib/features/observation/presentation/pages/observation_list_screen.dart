import 'package:flutter/material.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/observation/presentation/bloc/list_room/observation_list_event.dart';
import 'package:mydiaree/features/observation/presentation/bloc/list_room/observation_list_state.dart';
import 'package:mydiaree/features/observation/presentation/bloc/list_room/obsevation_list_bloc.dart';
import 'package:mydiaree/features/observation/presentation/pages/add_observation/add_observation_screen.dart';
import 'package:mydiaree/features/observation/presentation/pages/view_observation_screen.dart';
import 'package:mydiaree/features/observation/presentation/widget/observation_list_custom_widgets.dart';
import 'package:mydiaree/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ObservationListScreen extends StatelessWidget {
  const ObservationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ObservationListBloc()..add(FetchObservationsEvent(centerId: '1')),
      child: CustomScaffold(
        appBar: const CustomAppBar(title: "Observations"),
        body: BlocBuilder<ObservationListBloc, ObservationListState>(
          builder: (context, state) {
            if (state is ObservationListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ObservationListLoaded) {
              final observations = state.observationsData.observations;
              return SingleChildScrollView(
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
                          if (true)
                            UIHelpers.addButton(
                              context: context,
                              ontap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const AddObservationScreen(
                                    type: 'add',
                                    centerId: '1',
                                  );
                                }));
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
                          final observation = observations[index];
                          return ObservationCard(
                            title: observation.title ?? 'No Title',
                            author: observation.userName?.toString() ?? '',
                            approvedBy:
                                'Admin', // Provide actual value if available
                            dateAdded: observation.dateAdded?.toString() ?? '',
                            mediaUrl: '',
                            montessoriCount: 0,
                            eylfCount: 0,
                            status: observation.status?.toString() ?? '',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewObservationScreen(
                                            id: observation.id?.toString() ??
                                                '',
                                          )));
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ObservationListError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
