import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/reflection/data/repositories/reflection_repository.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/list_room/reflection_list_bloc.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/list_room/reflection_list_event.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/list_room/reflection_list_state.dart';
import 'package:mydiaree/features/reflection/presentation/pages/add_reflection_screen.dart';
import 'package:mydiaree/features/reflection/presentation/widget/reflection_list_custom_widgets.dart';
import 'package:mydiaree/features/room/presentation/widget/room_list_custom_widgets.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';

// ignore: must_be_immutable
class ReflectionListScreen extends StatefulWidget {
  ReflectionListScreen({super.key});

  @override
  State<ReflectionListScreen> createState() => _ReflectionListScreenState();
}

class _ReflectionListScreenState extends State<ReflectionListScreen> {
  String searchString = '';

  String? selectedStatus;

  String selectedCenterId = '1';

  String? selectedCenterName;

  String _monthName(int month) {
    const months = [
      '', // 0 index not used
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    if (month < 1 || month > 12) return '';
    return months[month];
  }

  Future<void> _deleteReflection(
      BuildContext context, String reflectionId) async {
    final repo = ReflectionRepository();
 
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final response = await repo.deleteReflection(reflectionId);
    Navigator.of(context, rootNavigator: true).pop();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reflection deleted successfully')),
      ); 
      context.read<ReflectionListBloc>().add(
            FetchReflectionsEvent(centerId: selectedCenterId ?? '1'),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Delete failed')),
      );
    }
  }

  initState() {
    super.initState();
    // Fetch initial data
    context.read<ReflectionListBloc>().add(
          FetchReflectionsEvent(centerId: selectedCenterId),
        );
  }

  final TextEditingController searchController = TextEditingController();
  bool get canModify => !UserTypeHelper.isParent;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Reflection"),
      body: BlocConsumer<ReflectionListBloc, ReflectionListState>(
        listener: (context, state) {
          if (state is ReflectionDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Reflections deleted successfully")),
            );
          } else if (state is ReflectionListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ReflectionListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReflectionListError) {
            return Center(child: Text(state.message));
          } else if (state is ReflectionListLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Reflection',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Spacer(),
                        // OutlinedButton(
                        //   onPressed: () {
                        //     showMaterialModalBottomSheet(
                        //       context: context,
                        //       builder: (context) => FiltersModal(
                        //         centerId: selectedCenterId,
                        //         children: [
                        //           FilterChildModel(
                        //               name: 'Vicky',
                        //               imageUrl: 'https://example.com/vicky.jpg',
                        //               id: '1'),
                        //           FilterChildModel(
                        //               name: 'John',
                        //               imageUrl: 'https://example.com/john.jpg',
                        //               id: '2'),
                        //           FilterChildModel(
                        //               name: 'Jane',
                        //               imageUrl: 'https://example.com/jane.jpg',
                        //               id: '3'),
                        //           FilterChildModel(
                        //               name: 'Doe',
                        //               imageUrl: 'https://example.com/doe.jpg',
                        //               id: '4'),
                        //         ],
                        //         staff: [
                        //           FilterEucatorModel(
                        //             name: 'John Doe',
                        //             imageUrl: 'https://example.com/john.jpg',
                        //             id: '1',
                        //           ),
                        //           FilterEucatorModel(
                        //             name: 'Jane Smith',
                        //             imageUrl: 'https://example.com/jane.jpg',
                        //             id: '2',
                        //           ),
                        //           FilterEucatorModel(
                        //             name: 'Doe John',
                        //             imageUrl: 'https://example.com/doe.jpg',
                        //             id: '3',
                        //           ),
                        //           FilterEucatorModel(
                        //             name: 'Vicky',
                        //             imageUrl: 'https://example.com/vicky.jpg',
                        //             id: '4',
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        //   child: const Text('FILTERS'),
                        //   style: OutlinedButton.styleFrom(
                        //     side:
                        //         const BorderSide(color: AppColors.primaryColor),
                        //   ),
                        // ),
                        const SizedBox(width: 8),
                        if (canModify)
                          UIHelpers.addButton(
                            context: context,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReflectionScreen(
                                    centerId: selectedCenterId ?? '1',
                                    screenType: 'add',
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    StatefulBuilder(builder: (context, setState) {
                      return CenterDropdown(
                        selectedCenterId: selectedCenterId,
                        onChanged: (value) {
                          setState(() {
                            selectedCenterId = value.id;
                            context.read<ReflectionListBloc>().add(
                                FetchReflectionsEvent(
                                    centerId: selectedCenterId ?? '1'));
                          });
                        },
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 3),
                      child: CustomTextFormWidget(
                        contentpadding: const EdgeInsets.only(top: 4),
                        prefixWidget: const Icon(Icons.search),
                        height: 40,
                        hintText: 'Search reflections...',
                        controller: searchController,
                        onChanged: (value) {},
                        onFieldSubmitted: (p0) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    StatefulBuilder(builder: (context, setState) {
                      return CustomDropdown(
                        height: 35,
                        width: 150,
                        hint: 'Select Status',
                        onChanged: (value) {
                          selectedStatus = value;
                          setState(() {});
                          context.read<ReflectionListBloc>().add(
                              FetchReflectionsEvent(
                                  centerId: selectedCenterId ?? '1',
                                  status: value));
                        },
                        value: selectedStatus,
                        items: const ['All', 'Draft', 'Published'],
                      );
                    }),
                    const SizedBox(height: 10),
                    StatefulBuilder(builder: (context, setState) {
                      // Filter reflections by searchController.text (case-insensitive)
                      final searchText =
                          searchController.text.trim().toLowerCase();
                      final filteredReflections =
                          (state.reflections.data?.reflection ?? [])
                              .where((reflection) {
                        final title = reflection.title?.toLowerCase() ?? '';
                        return searchText.isEmpty || title.contains(searchText);
                      }).toList();

                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredReflections.length,
                        itemBuilder: (context, index) {
                          final reflection = filteredReflections[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ReflectionCard(
                              images: reflection.media
                                      ?.map((m) => m.mediaUrl ?? '')
                                      .toList() ??
                                  [],
                              title: reflection.title ?? '',
                              date: (() {
                                if (reflection.createdAt == null) return '';
                                try {
                                  final date = DateTime.parse(
                                          reflection.createdAt.toString())
                                      .toLocal();
                                  return "${_monthName(date.month)} ${date.day}, ${date.year}";
                                } catch (e) {
                                  return '';
                                }
                              })(),
                              children: reflection.children
                                      ?.map((c) => ChildrenModel(
                                            name: c.child?.name ?? '',
                                            imageUrl: c.child?.imageUrl ?? '',
                                          ))
                                      .toList() ??
                                  [],
                              educators: reflection.staff
                                      ?.map((e) => EducatorModel(
                                            name:
                                                e.staff?.name?.toString() ?? '',
                                            imageUrl:
                                                e.staff?.imageUrl?.toString() ??
                                                    '',
                                          ))
                                      .toList() ??
                                  [],
                              permissionUpdate: canModify,
                              permissionDelete: canModify,
                              onEditPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddReflectionScreen(
                                        centerId: selectedCenterId,
                                        screenType: 'edit',
                                        id: reflection.id.toString()),
                                  ),
                                );
                              },
                              onDeletePressed: () async {
                                showDeleteConfirmationDialog(context, () {
                                  Navigator.pop(context);
                                  _deleteReflection(
                                      context, reflection.id.toString());
                                });
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class FilterChildModel {
  final String name;
  final String imageUrl;
  final String id;

  FilterChildModel(
      {required this.name, required this.imageUrl, required this.id});
}

class FilterEucatorModel {
  final String name;
  final String imageUrl;
  final String id;

  FilterEucatorModel(
      {required this.name, required this.imageUrl, required this.id});
}

class FiltersModal extends StatefulWidget {
  final String? centerId;
  final List<FilterChildModel> children;
  final List<FilterEucatorModel> staff;
  const FiltersModal(
      {Key? key, this.centerId, required this.children, required this.staff})
      : super(key: key);
  @override
  _FiltersModalState createState() => _FiltersModalState();
}

class _FiltersModalState extends State<FiltersModal> {
  String status = 'All';
  String added = 'None';
  bool customDateVisible = false;
  DateTime? fromDate;
  DateTime? toDate;
  String author = 'Any';
  List<FilterChildModel> selectedChildren = [];
  List<FilterEucatorModel> selectedStaff = [];
  String childSearchQuery = '';
  String staffSearchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PatternBackground(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    title: const Text('Status'),
                    initiallyExpanded: true,
                    children: [
                      RadioListTile<String>(
                        title: const Text('All'),
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        value: 'All',
                        groupValue: status,
                        onChanged: (value) => setState(() => status = value!),
                      ),
                      RadioListTile<String>(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('Draft'),
                        value: 'Draft',
                        groupValue: status,
                        onChanged: (value) => setState(() => status = value!),
                      ),
                      RadioListTile<String>(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('Published'),
                        value: 'Published',
                        groupValue: status,
                        onChanged: (value) => setState(() => status = value!),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Added'),
                    children: [
                      RadioListTile<String>(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('None'),
                        value: 'None',
                        groupValue: added,
                        onChanged: (value) {
                          setState(() {
                            added = value!;
                            customDateVisible = false;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('Today'),
                        value: 'Today',
                        groupValue: added,
                        onChanged: (value) {
                          setState(() {
                            added = value!;
                            customDateVisible = false;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('This Week'),
                        value: 'This Week',
                        groupValue: added,
                        onChanged: (value) {
                          setState(() {
                            added = value!;
                            customDateVisible = false;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('This Month'),
                        value: 'This Month',
                        groupValue: added,
                        onChanged: (value) {
                          setState(() {
                            added = value!;
                            customDateVisible = false;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('Custom Date'),
                        value: 'Custom',
                        groupValue: added,
                        onChanged: (value) {
                          setState(() {
                            added = value!;
                            customDateVisible = true;
                          });
                        },
                      ),
                      if (customDateVisible)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            children: [
                              CustomTextFormWidget(
                                hintText: 'From Date',
                                ontap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null)
                                    setState(() => fromDate = picked);
                                },
                                readOnly: true,
                                controller: TextEditingController(
                                  text: fromDate != null
                                      ? fromDate.toString().split(' ')[0]
                                      : '',
                                ),
                              ),
                              CustomTextFormWidget(
                                hintText: 'To Date',
                                ontap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null)
                                    setState(() => toDate = picked);
                                },
                                readOnly: true,
                                controller: TextEditingController(
                                  text: toDate != null
                                      ? toDate.toString().split(' ')[0]
                                      : '',
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Child'),
                    children: [
                      CheckboxListTile(
                        title: const Text('Select All'),
                        value:
                            selectedChildren.length == widget.children.length,
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              selectedChildren = widget.children
                                  .map((c) => FilterChildModel(
                                      name: c.name,
                                      imageUrl: c.imageUrl,
                                      id: c.id))
                                  .toList();
                            } else {
                              selectedChildren = [];
                            }
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomTextFormWidget(
                          onTapOutside: (p0) {},
                          hintText: 'Search child...',
                          scrollPaddingBottom: 300,
                          prefixWidget: const Icon(Icons.search),
                          onChanged: (value) {
                            setState(() => childSearchQuery = value!);
                          },
                        ),
                      ),
                      ...widget.children
                          .where((child) => child.name
                              .toLowerCase()
                              .contains(childSearchQuery.toLowerCase()))
                          .map((child) => CheckboxListTile(
                                fillColor: MaterialStateProperty.all(
                                    AppColors.primaryColor),
                                title: Text(child.name),
                                value: selectedChildren.contains(child),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      selectedChildren.add(child);
                                    } else {
                                      selectedChildren.remove(child);
                                    }
                                  });
                                },
                              ))
                          .toList(),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Author'),
                    children: [
                      CheckboxListTile(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('Any'),
                        value: author == 'Any',
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              author = 'Any';
                              selectedStaff = [];
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('Me'),
                        value: author == 'Me',
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              author = 'Me';
                              selectedStaff = [];
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        fillColor:
                            MaterialStateProperty.all(AppColors.primaryColor),
                        title: const Text('Select All'),
                        value: selectedStaff.length == widget.staff.length,
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              author = '';
                              selectedStaff = widget.staff
                                  .map((s) => FilterEucatorModel(
                                      name: s.name,
                                      imageUrl: s.imageUrl,
                                      id: s.id))
                                  .toList();
                            } else {
                              selectedStaff = [];
                            }
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomTextFormWidget(
                          hintText: 'Search staff...',
                          prefixWidget: const Icon(Icons.search),
                          onChanged: (value) {
                            setState(() => staffSearchQuery = value!);
                          },
                        ),
                      ),
                      ...widget.staff
                          .where((s) => s.name
                              .toLowerCase()
                              .contains(staffSearchQuery.toLowerCase()))
                          .map((s) => CheckboxListTile(
                                fillColor: MaterialStateProperty.all(
                                    AppColors.primaryColor),
                                title: Text(s.name),
                                value: selectedStaff.contains(s),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      author = '';
                                      selectedStaff.add(s);
                                    } else {
                                      selectedStaff.remove(s);
                                    }
                                    if (selectedStaff.isEmpty) author = 'Any';
                                  });
                                },
                              ))
                          .toList(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    status = 'All';
                    added = 'None';
                    customDateVisible = false;
                    fromDate = null;
                    toDate = null;
                    author = 'Any';
                    selectedChildren = [];
                    selectedStaff = [];
                  });
                  context
                      .read<ReflectionListBloc>()
                      .add(FetchReflectionsEvent(centerId: '1'));
                  Navigator.pop(context);
                },
                child: const Text('Clear Filters'),
              ),
              const SizedBox(width: 8),
              CustomButton(
                  width: 140,
                  height: 40,
                  ontap: () {
                    context
                        .read<ReflectionListBloc>()
                        .add(FetchReflectionsEvent(
                          // centerId: selectedCenterId ?? '1',
                          centerId: '1',
                          status: status == 'All' ? null : status,
                          added: added == 'None' ? null : added,
                          fromDate: fromDate,
                          toDate: toDate,
                          // authors: author == 'Any'
                          //     ? null
                          //     : author == 'Me'
                          //         ? ['Me']
                          //         : selectedStaff,
                          // children: selectedChildren.isEmpty
                          //     ? null
                          //     : selectedChildren,
                        ));
                    Navigator.pop(context);
                  },
                  text: 'Apply Filters'),
            ],
          ),
        ],
      ),
    );
  }
}
