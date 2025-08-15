import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/list/learning_and_progress_bloc.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/list/learning_and_progress_event.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/list/learning_and_progress_state.dart';
import 'package:mydiaree/features/learning_and_progress/data/model/child_model.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/pages/view_progress_screen.dart';
import 'package:mydiaree/features/room/presentation/widget/room_list_custom_widgets.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';
import 'package:mydiaree/main.dart';

class LearningAndProgressScreen extends StatefulWidget {
  const LearningAndProgressScreen({super.key});

  @override
  _LearningAndProgressScreenState createState() =>
      _LearningAndProgressScreenState();
}

class _LearningAndProgressScreenState extends State<LearningAndProgressScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _selectedChildIds = [];

  List<Room> _rooms = [];
  bool _loadingRooms = true;
  String? _selectedCenterId;
  String? _selectedRoomId;

  @override
  void initState() {
    super.initState();
    _loadCenters();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _loadCenters() async {
    _selectedCenterId = globalSelectedCenterId;
    if (_selectedCenterId != null) {
      await _loadRooms(_selectedCenterId!);
    }
    // initial fetch
    _fetchChildren();
  }

  Future<void> _loadRooms(String centerId) async {
    setState(() => _loadingRooms = true);
    try {
      final repo = RoomRepository();
      final resp = await repo.getRooms(centerId: centerId);
      if (resp.success && resp.data != null) {
        _rooms = resp.data!.rooms ?? [];
        _selectedRoomId = _rooms.isNotEmpty ? _rooms.first.id.toString() : null;
      }
    } catch (_) {
      _rooms = [];
      _selectedRoomId = null;
    } finally {
      setState(() => _loadingRooms = false);
    }
  }

  void _fetchChildren() {
    if (_selectedCenterId != null && _selectedRoomId != null) {
      context.read<LearningAndProgressBloc>().add(
        FetchChildrenEvent(
          centerId: _selectedCenterId!,
          roomId: _selectedRoomId!,
        ),
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Lesson Plan"),
      body: Column(
        children: [
          // Center & Room filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                CenterDropdown(
                  selectedCenterId: _selectedCenterId,
                  onChanged: (c) async {
                    _selectedCenterId = c.id;
                    await _loadRooms(c.id);
                    _fetchChildren();
                  },
                ),
                const SizedBox(height: 12),
                _loadingRooms
                    ? Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryColor),
                          ),
                        ),
                      )
                    : CustomDropdown<Room>(
                        items: _rooms,
                        // select the Room that matches _selectedRoomId, or fallback to first
                        value: _selectedRoomId != null && _rooms.isNotEmpty
                            ? _rooms.firstWhere(
                                (room) => room.id.toString() == _selectedRoomId,
                                orElse: () => _rooms.first,
                              )
                            : null,
                        hint: _rooms.isEmpty ? 'No Rooms Available' : 'Select Room',
                        displayItem: (room) => room.name ?? '',
                        onChanged: (room) {
                          if (room != null) {
                            setState(() {
                              _selectedRoomId = room.id.toString();
                              _selectedChildIds.clear();
                            });
                            _fetchChildren();
                          }
                        },
                      ),
              ],
            ),
          ),
          // Search Bar
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: CustomTextFormWidget(
          //     prefixWidget: const Icon(Icons.search, size: 20),
          //     height: 40,
          //     contentpadding: const EdgeInsets.only(top: 2, left: 12),
          //     hintText: 'Search children by name...',
          //     controller: _searchController,
          //     onChanged: (value) {
          //       setState(() {
          //         _searchQuery = value?.toLowerCase() ?? '';
          //       });
          //     },
          //   ),
          // ),
          // Children Grid or “No rooms available”
          if (!_loadingRooms && _rooms.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No rooms available for the selected center',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          else
            Expanded(
              child: BlocConsumer<LearningAndProgressBloc, LearningAndProgressState>(
                listener: (context, state) {
                  if (state is LearningAndProgressDeleted) {
                    UIHelpers.showToast(
                      context,
                      message: state.message,
                      backgroundColor: AppColors.successColor,
                    );
                    setState(() {
                      _selectedChildIds.clear();
                    });
                  } else if (state is LearningAndProgressError) {
                    UIHelpers.showToast(
                      context,
                      message: state.message,
                      backgroundColor: AppColors.errorColor,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LearningAndProgressLoading) {
                    return _rooms.isNotEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  } else if (state is LearningAndProgressError) {
                    return Center(child: Text(state.message));
                  } else if (state is LearningAndProgressLoaded) {
                    final children = state.children
                        .where((child) =>
                            child.name.toLowerCase().contains(_searchQuery))
                        .toList();
                    if (children.isEmpty && _searchQuery.isNotEmpty) {
                      return _buildNoResults();
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: children.length,
                      itemBuilder: (context, index){
                        final child = children[index];
                        final isSelected = _selectedChildIds.contains(child.id);
                        return ChildCard(
                          isDelete: false,
                          child: child,
                          index: index,
                          isSelected: isSelected,
                          onSelect: (selected) {
                            // setState(() {
                            //   if (selected) {
                            //     _selectedChildIds.add(child.id);
                            //   } else {
                            //     _selectedChildIds.remove(child.id);
                            //   }
                            // });
                          },
                          onViewProgress: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ViewProgressScreen(childId: child.id,);
                            }));
                          },
                          onDeletePressed: () {
                            // showDeleteConfirmationDialog(context, () {
                            //   context.read<LearningAndProgressBloc>().add(
                            //         DeleteChildrenEvent([child.id], '1'),
                            //       );
                            //   Navigator.pop(context);
                            // });
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No children found',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class ChildCard extends StatelessWidget {
  final ChildModel child;
  final int index;
  final bool isSelected;
  final Function(bool) onSelect;
  final VoidCallback onViewProgress;
  final VoidCallback onDeletePressed;
  
  final bool isDelete;

  const ChildCard({
    required this.child,
    required this.index,
    required this.isSelected,
    required this.onSelect,
    required this.onViewProgress,
    required this.onDeletePressed,
    super.key, required this.isDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // calculate image height based on available card width
        final cardWidth = constraints.maxWidth;
        final imageHeight = cardWidth * 0.5;

        return Card(
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onSelect(!isSelected),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Stack(
                    children: [
                      Image.network(
                        AppUrls.baseUrl + '/' + child.imageUrl,
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                        ),
                      ),
                      Container(
                        height: imageHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Card Body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Flexible(
                          child: Text(
                            child.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // DOB
                        Row(
                          children: [
                            Icon(Icons.cake, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                child.dob != null
                                    ? DateFormat('dd MMM yyyy').format(DateTime.parse(child.dob))
                                    : 'N/A',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Age
                        Row(
                          children: [
                            Icon(Icons.child_care, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Age: ${child.getAge()} years',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${child.getAge()}y',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Gender
                        Row(
                          children: [
                            Icon(Icons.person, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Gender: ${child.gender}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: child.gender.toLowerCase() == 'male'
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.pink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                child.gender,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: child.gender.toLowerCase() == 'male'
                                          ? Colors.blue
                                          : Colors.pink,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: onViewProgress,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.trending_up, size: 16),
                                    SizedBox(width: 4),
                                    Text('View Progress'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isDelete)
                              CustomActionButton(
                                icon: Icons.delete,
                                color: AppColors.errorColor,
                                tooltip: 'Delete',
                                onPressed: onDeletePressed,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String? tooltip;
  final VoidCallback onPressed;

  const CustomActionButton({
    required this.icon,
    required this.color,
    this.tooltip,
    required this.onPressed,
    super.key,
  });

  @override
  _CustomActionButtonState createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.95),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.identity()..scale(_scale),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(0.1),
            border: Border.all(color: widget.color, width: 1),
          ),
          child: Icon(
            widget.icon,
            color: widget.color,
            size: 20,
          ),
        ),
      ),
    );
  }
}

extension on DateTime {
  T? let<T>(T Function(DateTime) cb) => cb(this);
}
